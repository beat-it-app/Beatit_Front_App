// lib/src/domain/performance/view/performance_invite_view_page.dart

import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_actions.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_hero.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_image_capture.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_export.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_export.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_scroll_arrow.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_section.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

/// 공연 상세 화면에서 진입하는 읽기 전용 모바일 초대장.
/// 공연 생성/수정 화면에서 쓰는 입력용 컨트롤러와 책임을 분리한다.
class PerformanceInviteViewPage extends StatefulWidget {
  const PerformanceInviteViewPage({super.key, required this.performance});

  final PerformanceDetailModel performance;

  @override
  State<PerformanceInviteViewPage> createState() =>
      _PerformanceInviteViewPageState();
}

class _PerformanceInviteViewPageState extends State<PerformanceInviteViewPage>
    with SingleTickerProviderStateMixin {
  static const double _arrowHeight = 80;
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _entranceController;
  late final Animation<double> _entrance;
  Timer? _entranceTimer;
  bool _isLowerSectionVisible = false;
  bool _isProgrammaticScroll = false;
  int _selectedTeamIndex = 0;
  bool _showAllSongs = false;
  double _heroHeight = 0;
  bool _isSharing = false;

  List<PerformanceSetlistTeam> get _teams =>
      widget.performance.invitationCard?.setlist ?? const [];

  List<PerformanceSetlistSong> get _selectedSongs {
    if (_teams.isEmpty || _selectedTeamIndex >= _teams.length) return const [];
    return _teams[_selectedTeamIndex].musics;
  }

  bool get _hasSetlist => _teams.any((team) => team.musics.isNotEmpty);

  // 각 팀은 처음 10곡만 노출한다. 더보기는 화면 표시만 확장하며,
  // 저장용 PNG에는 항상 해당 팀의 전체 곡이 들어간다.
  int get _visibleSongCount =>
      _showAllSongs || _selectedSongs.length <= 10 ? _selectedSongs.length : 10;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _entranceTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) _entranceController.forward();
    });
    _scrollController.addListener(_syncArrowWithScroll);
  }

  void _syncArrowWithScroll() {
    if (!_scrollController.hasClients || _isProgrammaticScroll) return;
    final target = _heroHeight.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    final expanded = target > 0 && _scrollController.offset >= target * 0.65;
    if (expanded != _isLowerSectionVisible) {
      setState(() => _isLowerSectionVisible = expanded);
    }
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    (_entrance as CurvedAnimation).dispose();
    _entranceController.dispose();
    _scrollController.removeListener(_syncArrowWithScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _toggleScroll() async {
    if (!_scrollController.hasClients ||
        _isProgrammaticScroll ||
        !_entranceController.isCompleted)
      return;
    final goingUp = _isLowerSectionVisible;
    final target = goingUp
        ? 0.0
        : _heroHeight.clamp(0.0, _scrollController.position.maxScrollExtent);
    setState(() => _isLowerSectionVisible = !goingUp);
    _isProgrammaticScroll = true;
    try {
      await _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } finally {
      _isProgrammaticScroll = false;
      if (mounted) _syncArrowWithScroll();
    }
  }

  Rect _shareAnchor() {
    final size = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(size.width / 2, size.height / 2, 1, 1);
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 항상 행사 정보(두 번째) 티켓 + 하단 안내 문구가 있는 고정 PNG를 만든다.
  Future<void> _shareInvitationImage() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final bytes = await PerformanceImageCapture.capture(
        context: context,
        width: PerformanceInvitationExport.imageWidth,
        child: PerformanceInvitationExport(performance: widget.performance),
      );
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          title: widget.performance.title,
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'beatit_invitation.png',
            ),
          ],
          sharePositionOrigin: _shareAnchor(),
        ),
      );
    } catch (_) {
      _notify('초대장 이미지를 만들거나 공유하지 못했습니다.');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  /// 셋리스트는 선택한 팀 하나가 아니라 등록된 팀별로 이미지 한 장씩 생성한다.
  /// 곡 수에 비례하여 위젯 높이가 늘어나므로 화면에 보이는 부분만 저장되지 않는다.
  Future<void> _shareSetlist() async {
    if (_isSharing || !_hasSetlist) return;
    setState(() => _isSharing = true);
    try {
      final files = <XFile>[];
      for (var i = 0; i < _teams.length; i++) {
        if (!mounted) return;
        final team = _teams[i];
        final bytes = await PerformanceImageCapture.capture(
          context: context,
          width: PerformanceSetlistExport.imageWidth,
          child: PerformanceSetlistExport(team: team),
        );
        final safeName = team.teamName.replaceAll(
          RegExp(r'[^a-zA-Z0-9가-힣_-]'),
          '_',
        );
        final filename = safeName.isNotEmpty ? safeName : 'team_${i + 1}';
        files.add(
          XFile.fromData(
            bytes,
            mimeType: 'image/png',
            name: 'beatit_setlist_${i + 1}_$filename.png',
          ),
        );
      }
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          title: '${widget.performance.title} 셋리스트',
          files: files,
          sharePositionOrigin: _shareAnchor(),
        ),
      );
    } catch (_) {
      _notify('셋리스트 이미지를 만들거나 공유하지 못했습니다.');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 참고 화면은 검정 바탕의 공연 티켓 경험이므로 Light/Dark 시스템 설정과
    // 관계없이 앱에 이미 정의된 Dark 테마 토큰을 적용한다.
    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) {
          final foreground = context.colors.onSurface;
          return Scaffold(
            backgroundColor: context.colors.surface,
            appBar: AppBar(
              backgroundColor: context.colors.surface,
              foregroundColor: foreground,
              scrolledUnderElevation: 0,
              leading: IconButton(
                tooltip: '뒤로가기',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: SvgPicture.asset(
                  'assets/icons/appbar/back.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: '현재 티켓 저장 또는 공유',
                  onPressed: _isSharing ? null : _shareInvitationImage,
                  icon: SvgPicture.asset(
                    'assets/icons/team/share.svg',
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
              ],
            ),
            body: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _heroHeight = (constraints.maxHeight - _arrowHeight).clamp(
                    0.0,
                    constraints.maxHeight,
                  );
                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: _heroHeight,
                          child: PerformanceInvitationHero(
                            performance: widget.performance,
                            entrance: _entrance,
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PerformanceInvitationArrowDelegate(
                          child: PerformanceInvitationScrollArrow(
                            entrance: _entrance,
                            isExpanded: _isLowerSectionVisible,
                            onPressed: _toggleScroll,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.x16,
                            bottom: AppSpacing.x40,
                          ),
                          child: PerformanceInvitationActions(
                            onSaveInvitation: _shareInvitationImage,
                            onSaveSetlist: _shareSetlist,
                            onViewDetails: () =>
                                Navigator.of(context).maybePop(),
                            hasSetlist: _hasSetlist,
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PerformanceSetlistHeaderDelegate(
                          child: PerformanceSetlistHeader(
                            teams: _teams,
                            selectedIndex: _selectedTeamIndex,
                            onTeamSelected: (index) {
                              setState(() {
                                _selectedTeamIndex = index;
                                _showAllSongs = false;
                              });
                            },
                          ),
                        ),
                      ),
                      if (_selectedSongs.isEmpty)
                        const SliverToBoxAdapter(
                          child: PerformanceSetlistEmpty(),
                        )
                      else
                        SliverList.builder(
                          itemCount: _visibleSongCount,
                          itemBuilder: (context, index) =>
                              PerformanceSetlistSongItem(
                                number: index + 1,
                                song: _selectedSongs[index],
                              ),
                        ),
                      if (_selectedSongs.length > 10)
                        SliverToBoxAdapter(
                          child: PerformanceSetlistExpandButton(
                            expanded: _showAllSongs,
                            onPressed: () =>
                                setState(() => _showAllSongs = !_showAllSongs),
                          ),
                        ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.x70),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
