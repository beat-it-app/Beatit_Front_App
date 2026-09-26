import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_detail_provider.dart';
import 'package:beatit_front_app/src/domain/cal/widget/label_box.dart';
import 'package:beatit_front_app/src/domain/cal/widget/music_list_item.dart';

class CalDetailPage extends ConsumerWidget {
  const CalDetailPage({super.key, required this.scheduleId});

  final int scheduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(calDetailProvider(scheduleId));

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
        onMorePressed: () {},
      ),
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorView(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(calDetailProvider(scheduleId));
            },
          ),
          data: (schedule) => _ScheduleDetailContent(schedule: schedule),
        ),
      ),
    );
  }
}

class _ScheduleDetailContent extends StatefulWidget {
  const _ScheduleDetailContent({required this.schedule});

  final ScheduleDetailData schedule;

  @override
  State<_ScheduleDetailContent> createState() =>
      _ScheduleDetailContentState();
}

class _ScheduleDetailContentState extends State<_ScheduleDetailContent> {
  final AudioPlayer _player = AudioPlayer();

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  int? _expandedMusicId;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isLoadingMusic = false;
  String? _playbackErrorMessage;
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

    final expandedMusicId = _expandedMusicId;
    if (expandedMusicId == null) {
      return;
    }

    final stillExists = schedule.musics.any(
      (music) => music.musicId == expandedMusicId,
    );

    if (!stillExists) {
      unawaited(_closePlayer());
    }
  }

  void _bindPlayerStreams() {
    _positionSubscription = _player.positionStream.listen((position) {
      if (!mounted || _expandedMusicId == null) {
        return;
      }

      final nextPosition = _clampDuration(
        position,
        Duration.zero,
        _duration,
      );

      setState(() {
        _position = nextPosition;
      });
    });

    _durationSubscription = _player.durationStream.listen((duration) {
      if (!mounted || _expandedMusicId == null || duration == null) {
        return;
      }

      setState(() {
        _duration = duration;
      });
    });

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted || _expandedMusicId == null) {
        return;
      }

      setState(() {
        _isPlaying =
            state.playing && state.processingState != ProcessingState.completed;

        if (state.processingState == ProcessingState.completed) {
          _position = _duration;
        }
      });
    });
  }

  Future<void> _handleMusicTap(ScheduleDetailMusic music) async {
    if (_expandedMusicId == music.musicId) {
      await _closePlayer();
      return;
    }

    await _openPlayer(music);
  }

  Future<void> _openPlayer(ScheduleDetailMusic music) async {
    final requestId = ++_loadRequestId;
    final previewUrl = music.musicPreviewUrl?.trim();

    setState(() {
      _expandedMusicId = music.musicId;
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
      _isLoadingMusic = true;
      _playbackErrorMessage = null;
    });

    await _player.stop();

    if (!mounted || requestId != _loadRequestId) {
      return;
    }

    if (previewUrl == null || previewUrl.isEmpty) {
      setState(() {
        _isLoadingMusic = false;
        _playbackErrorMessage = '미리듣기 음원이 없습니다.';
      });
      return;
    }

    try {
      final resolvedDuration = await _player.setUrl(previewUrl);

      if (!mounted || requestId != _loadRequestId) {
        return;
      }

      final duration = resolvedDuration ?? _player.duration;
      if (duration == null || duration <= Duration.zero) {
        setState(() {
          _isLoadingMusic = false;
          _playbackErrorMessage = '미리듣기 음원을 불러오지 못했습니다.';
        });
        return;
      }

      setState(() {
        _duration = duration;
        _position = Duration.zero;
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
        _isLoadingMusic = false;
        _isPlaying = false;
        _playbackErrorMessage = '미리듣기 음원을 불러오지 못했습니다.';
      });
    }
  }

  Future<void> _closePlayer() async {
    ++_loadRequestId;

    if (mounted) {
      setState(() {
        _expandedMusicId = null;
        _position = Duration.zero;
        _duration = Duration.zero;
        _isPlaying = false;
        _isLoadingMusic = false;
        _playbackErrorMessage = null;
      });
    }

    await _player.stop();
  }

  Future<void> _seek(Duration target) async {
    if (_expandedMusicId == null ||
        _isLoadingMusic ||
        _playbackErrorMessage != null ||
        _duration <= Duration.zero) {
      return;
    }

    final clamped = _clampDuration(target, Duration.zero, _duration);
    final shouldResume =
        _isPlaying || _player.processingState == ProcessingState.completed;

    setState(() {
      _position = clamped;
    });

    await _player.seek(clamped);

    if (shouldResume && clamped < _duration && !_player.playing) {
      unawaited(_player.play());
    }
  }

  Duration _clampDuration(
    Duration value,
    Duration minimum,
    Duration maximum,
  ) {
    if (value < minimum) {
      return minimum;
    }
    if (value > maximum) {
      return maximum;
    }
    return value;
  }

  @override
  void dispose() {
    ++_loadRequestId;
    unawaited(_positionSubscription?.cancel());
    unawaited(_durationSubscription?.cancel());
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
          Text(
            '${_formatDateTime(schedule.createdAt)}'
            ' ｜ 최종수정일 ${_formatDateTime(schedule.updatedAt)}',
            style: FontStyles.reg14.copyWith(color: context.grays.gray5),
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
            _InfoRow(
              iconAddress: 'assets/icons/cal/location.svg',
              label: '위치',
              // 현재 상세 API는 locationId만 내려주므로 실제 장소명은
              // location API 연결 후 교체합니다.
              value: '장소 ID ${schedule.locationId}',
            ),
          ],
          if (hasMusics) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/cal/music_symbol.svg',
              value: '연습곡',
            ),
            const SizedBox(height: AppSpacing.x4),
            ..._buildMusicItems(context, schedule.musics),
          ],
          if (hasParticipants) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/profile/profile1.svg',
              value: '참여자',
            ),
            const SizedBox(height: AppSpacing.x14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: schedule.participants
                    .map(
                      (participant) =>
                          _ParticipantItem(userId: participant.userId),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
          if (hasFiles) ...[
            const SizedBox(height: AppSpacing.x20),
            const LabelBox(
              iconAddress: 'assets/icons/cloud/file.svg',
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
      final isExpanded = _expandedMusicId == music.musicId;

      return Column(
        children: [
          MusicListItem(
            trackText: _displayText(music.musicTitle, fallback: '제목 없음'),
            artistText: _displayText(
              music.musicArtist,
              fallback: '아티스트 정보 없음',
            ),
            isExpanded: isExpanded,
            isPlaying: isExpanded && _isPlaying,
            isLoading: isExpanded && _isLoadingMusic,
            position: isExpanded ? _position : Duration.zero,
            duration: isExpanded ? _duration : Duration.zero,
            errorMessage: isExpanded ? _playbackErrorMessage : null,
            onTap: () => unawaited(_handleMusicTap(music)),
            onSeek: (position) => unawaited(_seek(position)),
          ),
          if (!isLast) Divider(color: context.grays.gray7, height: 1),
        ],
      );
    });
  }

  static List<Widget> _buildFileItems(
    BuildContext context,
    List<ScheduleDetailFile> files,
  ) {
    return List.generate(files.length, (index) {
      final file = files[index];
      final isLast = index == files.length - 1;

      return Column(
        children: [
          _FileItem(file: file),
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

    return '${value.year}.${_two(value.month)}.${_two(value.day)} '
        '${_two(value.hour)}:${_two(value.minute)}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _displayText(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
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

class _ParticipantItem extends StatelessWidget {
  const _ParticipantItem({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x16),
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.grays.gray8,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.person, color: context.grays.gray5),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              '멤버 $userId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.med14.copyWith(color: context.colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileItem extends StatelessWidget {
  const _FileItem({required this.file});

  final ScheduleDetailFile file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_rounded,
            size: 22,
            color: context.colors.primary,
          ),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Text(
              file.originalFileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.med14.copyWith(color: context.colors.onSurface),
            ),
          ),
        ],
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
