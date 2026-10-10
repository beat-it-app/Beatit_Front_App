import 'dart:async';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_detail_provider.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cal/view/cal_create_page.dart';
import 'package:beatit_front_app/src/domain/cal/view/schedule_file_preview_page.dart';
import 'package:beatit_front_app/src/domain/cal/widget/label_box.dart';
import 'package:beatit_front_app/src/domain/cal/widget/music_list_item.dart';
import 'package:beatit_front_app/src/domain/cal/widget/schedule_file_item.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/provider/member_selection_provider.dart';
import 'package:beatit_front_app/src/domain/etc/model/team_member_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_map_preview_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/kakao_static_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class CalDetailPage extends ConsumerStatefulWidget {
  const CalDetailPage({super.key, required this.scheduleId});

  final int scheduleId;

  @override
  ConsumerState<CalDetailPage> createState() => _CalDetailPageState();
}

class _CalDetailPageState extends ConsumerState<CalDetailPage> {
  bool _didChange = false;

  Future<void> _handleBack() async {
    Navigator.of(context).pop(_didChange);
  }

  Future<bool> _handleSystemBack() async {
    Navigator.of(context).pop(_didChange);
    return false;
  }

  Future<void> _openEditPage(ScheduleDetailData schedule) async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CalCreatePage(initialSchedule: schedule),
      ),
    );

    if (!mounted || updated == null) {
      return;
    }

    setState(() {
      _didChange = true;
    });
    ref.invalidate(calDetailProvider(widget.scheduleId));
  }

  Future<void> _deleteSchedule() async {
    final confirmed = await AppPopup.show(
      context,
      title: '일정을 삭제하시겠습니까?',
      content: '삭제된 일정은\n복구할 수 없습니다.',
      warningType: WarningType.triangle,
      contentType: ContentType.small,
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (!mounted || confirmed != true) {
      return;
    }

    final deleted = await ref
        .read(calMutationProvider.notifier)
        .deleteSchedule(scheduleId: widget.scheduleId);

    if (!mounted) {
      return;
    }

    if (!deleted) {
      final error =
          ref.read(calMutationProvider).errorMessage ?? '일정 삭제에 실패했습니다.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(calDetailProvider(widget.scheduleId));
    final moreMenuItems = detailAsync.when(
      loading: () => const <AppDropdownItem>[],
      error: (_, __) => const <AppDropdownItem>[],
      data: (schedule) => <AppDropdownItem>[
        AppDropdownItem(
          label: '일정 수정하기',
          onPressed: () => _openEditPage(schedule),
        ),
        AppDropdownItem(label: '일정 삭제하기', onPressed: _deleteSchedule),
      ],
    );

    return WillPopScope(
      onWillPop: _handleSystemBack,
      child: Scaffold(
        appBar: AppTopAppBar.backMore(
          onBackPressed: _handleBack,
          moreMenuOffset: const Offset(-16, 56),
          moreMenuItems: moreMenuItems,
        ),
        body: SafeArea(
          child: detailAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _ErrorView(
              message: error.toString(),
              onRetry: () {
                ref.invalidate(calDetailProvider(widget.scheduleId));
              },
            ),
            data: (schedule) => _ScheduleDetailContent(schedule: schedule),
          ),
        ),
      ),
    );
  }
}

class _ScheduleDetailContent extends StatefulWidget {
  const _ScheduleDetailContent({required this.schedule});

  final ScheduleDetailData schedule;

  @override
  State<_ScheduleDetailContent> createState() => _ScheduleDetailContentState();
}

class _ScheduleDetailContentState extends State<_ScheduleDetailContent> {
  static const Duration _previewLimit = Duration(seconds: 30);

  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  int? _activeMusicId;
  bool _isPlaying = false;
  bool _isLoadingMusic = false;
  bool _isStoppingPreview = false;
  int _loadRequestId = 0;

  ScheduleDetailData get schedule => widget.schedule;

  @override
  void initState() {
    super.initState();
    _bindPlayerStreams();
  }

  @override
  void didUpdateWidget(covariant _ScheduleDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final activeMusicId = _activeMusicId;
    if (activeMusicId == null) {
      return;
    }

    final stillExists = schedule.musics.any(
      (music) => music.musicId == activeMusicId,
    );

    if (!stillExists) {
      unawaited(_stopPreview());
    }
  }

  void _bindPlayerStreams() {
    _positionSubscription = _player.positionStream.listen((position) {
      if (!mounted || _activeMusicId == null || _isStoppingPreview) {
        return;
      }

      if (position >= _previewLimit) {
        unawaited(_stopPreview());
      }
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted || _activeMusicId == null || _isStoppingPreview) {
        return;
      }

      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _activeMusicId = null;
          _isPlaying = false;
          _isLoadingMusic = false;
        });
        return;
      }

      final isBuffering =
          state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      final isPlaying =
          state.playing && state.processingState == ProcessingState.ready;

      if (_isLoadingMusic != isBuffering || _isPlaying != isPlaying) {
        setState(() {
          _isLoadingMusic = isBuffering;
          _isPlaying = isPlaying;
        });
      }
    });
  }

  Future<void> _handleMusicTap(ScheduleDetailMusic music) async {
    if (_activeMusicId == music.musicId) {
      await _stopPreview();
      return;
    }

    await _playPreview(music);
  }

  Future<void> _playPreview(ScheduleDetailMusic music) async {
    final previewUrl = music.musicPreviewUrl?.trim();
    if (previewUrl == null || previewUrl.isEmpty) {
      _showPlaybackMessage('미리듣기 음원이 없습니다.');
      return;
    }

    final requestId = ++_loadRequestId;

    setState(() {
      _activeMusicId = music.musicId;
      _isPlaying = false;
      _isLoadingMusic = true;
    });

    try {
      await _player.stop();

      if (!mounted || requestId != _loadRequestId) {
        return;
      }

      await _player.setUrl(previewUrl);

      if (!mounted || requestId != _loadRequestId) {
        return;
      }

      await _player.seek(Duration.zero);

      if (!mounted || requestId != _loadRequestId) {
        return;
      }

      setState(() {
        _isLoadingMusic = false;
      });

      unawaited(_player.play());
    } catch (error, stackTrace) {
      debugPrint('[CalDetailPage] music preview load failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || requestId != _loadRequestId) {
        return;
      }

      setState(() {
        _activeMusicId = null;
        _isPlaying = false;
        _isLoadingMusic = false;
      });
      _showPlaybackMessage('미리듣기 음원을 불러오지 못했습니다.');
    }
  }

  Future<void> _stopPreview() async {
    if (_isStoppingPreview) {
      return;
    }

    _isStoppingPreview = true;
    ++_loadRequestId;

    try {
      await _player.stop();
    } finally {
      if (mounted) {
        setState(() {
          _activeMusicId = null;
          _isPlaying = false;
          _isLoadingMusic = false;
        });
      }
      _isStoppingPreview = false;
    }
  }

  void _showPlaybackMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    ++_loadRequestId;
    unawaited(_positionSubscription?.cancel());
    unawaited(_playerStateSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = schedule.content?.trim().isNotEmpty ?? false;
    final hasLocation = schedule.locationId != null;
    final hasMusics = schedule.musics.isNotEmpty;
    final hasParticipants = schedule.participants.isNotEmpty;
    final hasFiles = schedule.files.isNotEmpty;
    final hasBeenUpdated = !schedule.createdAt.isAtSameMomentAs(
      schedule.updatedAt,
    );

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x16,
        AppSpacing.x24,
        AppSpacing.x16,
        AppSpacing.x30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.title,
            style: FontStyles.bold34.copyWith(
              color: context.colors.onSurface,
              letterSpacing: -0.68,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Text(
                _formatDateTime(schedule.createdAt),
                style: FontStyles.reg14.copyWith(color: context.grays.gray4),
              ),
              if (hasBeenUpdated)
                Text(
                  ' ｜ 최종수정일  ${_formatDateTime(schedule.updatedAt)}',
                  style: FontStyles.reg14.copyWith(color: context.grays.gray5),
                ),
            ],
          ),
          if (hasContent) ...[
            const SizedBox(height: AppSpacing.x16),
            Text(
              schedule.content!.trim(),
              style: FontStyles.reg14.copyWith(color: context.colors.onSurface),
            ),
          ],
          const SizedBox(height: AppSpacing.x20),
          _InfoRow(
            iconAddress: 'assets/icons/cal/clock.svg',
            label: '시간',
            value: _formatScheduleTime(schedule.startsAt, schedule.endsAt),
          ),
          if (hasLocation) ...[
            const SizedBox(height: AppSpacing.x10),
            _LocationInfo(locationId: schedule.locationId!),
          ],
          if (hasParticipants) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/cal/music_symbol.svg',
              value: '참여자',
            ),
            const SizedBox(height: AppSpacing.x14),
            _ParticipantsSection(participants: schedule.participants),
          ],
          if (hasMusics) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/cal/music_symbol.svg',
              value: '음원',
            ),
            const SizedBox(height: AppSpacing.x8),
            ..._buildMusicItems(context, schedule.musics),
          ],
          if (hasFiles) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/cal/music_symbol.svg',
              value: '파일',
            ),
            const SizedBox(height: AppSpacing.x8),
            ..._buildFileItems(context, schedule.files),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMusicItems(
    BuildContext context,
    List<ScheduleDetailMusic> musics,
  ) {
    return List.generate(musics.length, (index) {
      final music = musics[index];
      final isLast = index == musics.length - 1;
      final isActive = _activeMusicId == music.musicId;

      return Column(
        children: [
          MusicListItem(
            trackText: _displayText(music.musicTitle, fallback: '제목 없음'),
            artistText: _displayText(music.musicArtist, fallback: '아티스트 정보 없음'),
            isPlaying: isActive && _isPlaying,
            isLoading: isActive && _isLoadingMusic,
            onTap: () => unawaited(_handleMusicTap(music)),
          ),
          if (!isLast) Divider(color: context.grays.gray7, height: 1),
        ],
      );
    });
  }

  List<Widget> _buildFileItems(
    BuildContext context,
    List<ScheduleDetailFile> files,
  ) {
    return List.generate(files.length, (index) {
      final file = files[index];
      final isLast = index == files.length - 1;

      return Column(
        children: [
          ScheduleFileItem(
            fileName: file.originalFileName,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScheduleFilePreviewPage(
                    fileName: file.originalFileName,
                    source: file.cdnUrl,
                    contextTitle: schedule.title,
                  ),
                ),
              );
            },
          ),
          if (!isLast) Divider(color: context.grays.gray7, height: 1),
        ],
      );
    });
  }

  static String _formatScheduleTime(DateTime startsAt, DateTime endsAt) {
    final start = startsAt.toLocal();
    final end = endsAt.toLocal();
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[start.weekday - 1];

    return '${start.year}.${_two(start.month)}.${_two(start.day)} '
        '$weekday요일 ${_two(start.hour)}:${_two(start.minute)}'
        '-${_two(end.hour)}:${_two(end.minute)}';
  }

  static String _formatDateTime(DateTime dateTime) {
    final value = dateTime.toLocal();

    return '${value.year}. ${_two(value.month)}. ${_two(value.day)}  '
        '${_two(value.hour)}:${_two(value.minute)}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _displayText(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
  }
}

class _LocationInfo extends ConsumerStatefulWidget {
  const _LocationInfo({required this.locationId});

  final int locationId;

  @override
  ConsumerState<_LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends ConsumerState<_LocationInfo> {
  bool _isMapVisible = false;
  bool _isMapReady = false;
  String? _preloadKey;
  Future<void>? _mapPreloadFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareMapInBackground();
    });
  }

  @override
  void didUpdateWidget(covariant _LocationInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locationId != widget.locationId) {
      _preloadKey = null;
      _mapPreloadFuture = null;
      _isMapReady = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _prepareMapInBackground();
      });
    }
  }

  Future<void> _prepareMapInBackground() async {
    try {
      final location = await ref.read(
        locationDetailProvider(widget.locationId).future,
      );

      if (!mounted) {
        return;
      }

      final latitude = location.latitude;
      final longitude = location.longitude;
      if (latitude == null || longitude == null) {
        return;
      }

      final logicalWidth =
          (MediaQuery.sizeOf(context).width - (AppSpacing.x16 * 2))
              .clamp(1.0, double.infinity)
              .toDouble();
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      final preloadKey =
          '${location.locationId}:$latitude:$longitude:'
          '$logicalWidth:$devicePixelRatio';

      if (_preloadKey == preloadKey) {
        return;
      }

      _preloadKey = preloadKey;
      final preloadFuture = KakaoStaticMapWidget.precacheMap(
        context: context,
        latitude: latitude,
        longitude: longitude,
        logicalWidth: logicalWidth,
        logicalHeight: 210,
        level: 3,
      );
      _mapPreloadFuture = preloadFuture;

      try {
        await preloadFuture;
      } catch (_) {
        // 프리로드 실패는 상세 페이지 전체나 장소 정보 표시를 막지 않습니다.
      }

      if (!mounted || _mapPreloadFuture != preloadFuture) {
        return;
      }

      setState(() {
        _isMapReady = true;
      });
    } catch (_) {
      // 장소 조회 실패도 상세 페이지 전체 로딩과 분리합니다.
    }
  }

  void _toggleMapVisibility() {
    setState(() {
      _isMapVisible = !_isMapVisible;
    });
  }

  void _openMapPreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationMapPreviewPage(locationId: widget.locationId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationDetailProvider(widget.locationId));

    return locationAsync.when(
      loading: () =>
          _buildHeader(locationName: '장소 불러오는 중...', canShowMap: false),
      error: (_, __) => _buildHeader(
        locationName: '장소 ID ${widget.locationId}',
        canShowMap: false,
      ),
      data: (location) {
        final name = location.locationName?.trim();
        final locationName = name == null || name.isEmpty
            ? '장소 ID ${location.locationId}'
            : name;
        final latitude = location.latitude;
        final longitude = location.longitude;
        final canShowMap = latitude != null && longitude != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(locationName: locationName, canShowMap: canShowMap),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isMapVisible && canShowMap
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.x12),
                      child: _isMapReady
                          ? KakaoStaticMapWidget(
                              latitude: latitude,
                              longitude: longitude,
                              height: 210,
                              level: 3,
                              borderRadius: BorderRadius.circular(8),
                              onTap: _openMapPreview,
                            )
                          : _InlineMapLoading(onReady: _prepareMapInBackground),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader({
    required String locationName,
    required bool canShowMap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const LabelBox(
          iconAddress: 'assets/icons/cal/location.svg',
          value: '위치',
        ),
        const SizedBox(width: AppSpacing.x10),
        Expanded(
          child: Text(
            locationName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontStyles.med16.copyWith(color: context.colors.onSurface),
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: canShowMap ? _toggleMapVisibility : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '지도보기',
                  style: FontStyles.med16.copyWith(
                    color: canShowMap
                        ? context.brands.beatOrange2
                        : context.grays.gray5,
                    decoration: canShowMap
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: context.brands.beatOrange2,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                AnimatedRotation(
                  turns: _isMapVisible ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  child: SvgPicture.asset(
                    'assets/icons/cal/toggle_down.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      canShowMap
                          ? context.brands.beatOrange2
                          : context.grays.gray5,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InlineMapLoading extends StatefulWidget {
  const _InlineMapLoading({required this.onReady});

  final Future<void> Function() onReady;

  @override
  State<_InlineMapLoading> createState() => _InlineMapLoadingState();
}

class _InlineMapLoadingState extends State<_InlineMapLoading> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconAddress,
    required this.label,
    required this.value,
  });

  final String iconAddress;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelBox(iconAddress: iconAddress, value: label),
        const SizedBox(width: AppSpacing.x10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.x4),
            child: Text(
              value,
              style: FontStyles.med16.copyWith(color: context.colors.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}

/// 상세 응답은 참여자 ID만 제공합니다. 팀 멤버 목록의 사용자 프로필과 연결해
/// 이름과 이미지를 표시하되, 팀원 조회가 실패해도 일정 상세 자체는 표시합니다.
class _ParticipantsSection extends ConsumerStatefulWidget {
  const _ParticipantsSection({required this.participants});

  final List<ScheduleDetailParticipant> participants;

  @override
  ConsumerState<_ParticipantsSection> createState() =>
      _ParticipantsSectionState();
}

class _ParticipantsSectionState extends ConsumerState<_ParticipantsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(memberSelectionProvider.notifier).loadMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(memberSelectionProvider).members;
    final byUserId = <int, TeamMemberSearchResult>{
      for (final member in members)
        if (member.userId != null) member.userId!: member,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.participants
            .map((participant) {
              final member = byUserId[participant.userId];
              return _ParticipantItem(
                userId: participant.userId,
                name: member?.userName,
                imageUrl: member?.profileImageUrl,
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _ParticipantItem extends StatelessWidget {
  const _ParticipantItem({required this.userId, this.name, this.imageUrl});

  final int userId;
  final String? name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final displayName = name?.trim();
    final fallback = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.grays.gray8,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.person, color: context.grays.gray5),
    );

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x16),
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            url == null || url.isEmpty
                ? fallback
                : ClipOval(
                    child: Image.network(
                      url,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => fallback,
                    ),
                  ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              displayName == null || displayName.isEmpty
                  ? '사용자 $userId'
                  : displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontStyles.reg14.copyWith(color: context.grays.gray5),
            ),
            const SizedBox(height: AppSpacing.x16),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
