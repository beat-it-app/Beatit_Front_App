// lib/src/domain/performance/view/performance_invite_view_page.dart

import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:beatit_front_app/src/domain/performance/provider/performance_invitation_provider.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_actions.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_hero.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_image_capture.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_export.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_image_exporter.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_invitation_scroll_arrow.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_setlist_section.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

/// 서버의 모바일 초대장 API에서 셋리스트를 읽은 뒤 기존 UI에 전달한다.
/// 디버그용 로컬 미리보기에서는 fetchFromApi: false로 기존 Mock 데이터를 사용한다.
class PerformanceInviteViewPage extends ConsumerWidget {
  const PerformanceInviteViewPage({
    super.key,
    required this.performance,
    this.fetchFromApi = true,
  });

  final PerformanceDetailModel performance;
  final bool fetchFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!fetchFromApi) {
      return _PerformanceInviteViewContent(performance: performance);
    }

    final invitationAsync = ref.watch(
      performanceInvitationProvider(performance.performancePublicId),
    );
    return invitationAsync.when(
      data: (invitation) => _PerformanceInviteViewContent(
        performance: performance.withInvitationResponse(invitation),
      ),
      loading: () => const _PerformanceInvitationLoadState(),
      error: (error, stackTrace) => _PerformanceInvitationLoadState(
        errorMessage: '초대장 정보를 불러오지 못했습니다.',
        onRetry: () => ref.invalidate(
          performanceInvitationProvider(performance.performancePublicId),
        ),
      ),
    );
  }
}

class _PerformanceInvitationLoadState extends StatelessWidget {
  const _PerformanceInvitationLoadState({this.errorMessage, this.onRetry});

  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: Center(
            child: errorMessage == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.x16),
                      TextButton(
                        onPressed: onRetry,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// 기존 티켓 캐러셀·셋리스트 슬리버 구조를 유지하면서 저장을 보완한다.
class _PerformanceInviteViewContent extends StatefulWidget {
  const _PerformanceInviteViewContent({required this.performance});

  final PerformanceDetailModel performance;

  @override
  State<_PerformanceInviteViewContent> createState() =>
      _PerformanceInviteViewContentState();
}

class _PerformanceInviteViewContentState
    extends State<_PerformanceInviteViewContent>
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

  /// 저장용 PNG는 화면의 10곡 제한과 무관하게 팀별 전체 곡을 담는다.
  /// 공유 시트가 여러 첨부파일 중 첫 번째만 저장하는 기기를 위해,
  /// 각 팀의 PNG를 갤러리에 직접 한 장씩 저장한다.
  Future<void> _shareSetlist() async {
    if (_isSharing || !_hasSetlist) return;
    setState(() => _isSharing = true);
    var savedCount = 0;
    final failedTeams = <String>[];

    try {
      if (!await Gal.hasAccess() && !await Gal.requestAccess()) {
        _notify('사진 저장 권한이 없어 셋리스트를 저장하지 못했습니다.');
        return;
      }

      // 두 번 저장해도 파일명이 충돌하지 않도록 실행 시각을 포함한다.
      final savedAt = DateTime.now().millisecondsSinceEpoch;
      for (var i = 0; i < _teams.length; i++) {
        if (!mounted) return;
        final team = _teams[i];
        try {
          final bytes = await PerformanceSetlistImageExporter.export(
            context: context,
            team: team,
          );
          final safeName = team.teamName.replaceAll(
            RegExp(r'[^a-zA-Z0-9가-힣_-]'),
            '_',
          );
          final fileName = safeName.isEmpty ? 'team_${i + 1}' : safeName;
          await Gal.putImageBytes(
            bytes,
            name: 'beatit_setlist_${savedAt}_${i + 1}_$fileName.png',
          );
          savedCount++;
        } catch (error, stackTrace) {
          debugPrint('셋리스트 이미지 저장 실패 (${team.teamName}): $error');
          debugPrintStack(stackTrace: stackTrace);
          failedTeams.add(team.teamName.isEmpty ? '${i + 1}팀' : team.teamName);
        }
      }

      if (failedTeams.isEmpty) {
        _notify('총 $savedCount팀의 셋리스트 이미지가 갤러리에 저장되었습니다.');
      } else {
        _notify(
          '$savedCount/${_teams.length}장 저장 완료. '
          '실패: ${failedTeams.join(', ')}',
        );
      }
    } catch (error, stackTrace) {
      debugPrint('셋리스트 저장 준비 실패: $error');
      debugPrintStack(stackTrace: stackTrace);
      _notify('셋리스트 저장에 실패했습니다. 저장 권한과 여유 공간을 확인해주세요.');
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
                            hasSetlist: _hasSetlist && !_isSharing,
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
                        child: SizedBox(height: AppSpacing.x20),
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
