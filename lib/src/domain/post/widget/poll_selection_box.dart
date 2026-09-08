import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum PollStatus { inProgress, completed }

enum PollSelectionMode {
  /// 조건 문구는 표시하지 않되, 선택 동작은 단일 선택으로 처리합니다.
  unspecified,
  single,
  multiple,
}

class PollSelectionBox extends StatefulWidget {
  const PollSelectionBox({
    super.key,
    this.hintText = '댓글을 입력해주세요.',
    this.sendButtonSemanticLabel = '메시지 보내기',
    this.enabled = true,
    this.options = const ['선택지 1', '선택지 2', '선택지 3'],
    this.status = PollStatus.inProgress,
    this.participantCount = 0,
    this.isAnonymous = true,
    this.selectionMode = PollSelectionMode.single,
    this.initialVoteCounts = const [],
    this.initialSelectedIndexes = const <int>{},
    this.initialHasVoted = false,
    this.onVoteSubmitted,
    this.onMapTap,
    this.onParticipantTap,
  });

  /// 기존 호출부 호환을 위해 유지합니다.
  final String hintText;

  /// 기존 호출부 호환을 위해 유지합니다.
  final String sendButtonSemanticLabel;

  final bool enabled;
  final List<String> options;

  /// 진행 중 / 종료 상태입니다.
  final PollStatus status;

  /// 현재 투표에 참여한 사람 수입니다.
  final int participantCount;

  /// true일 때만 상단 조건에 `익명 투표`를 표시합니다.
  final bool isAnonymous;

  /// single: 복수 선택 불가 / multiple: 복수 선택 가능 / unspecified: 문구 미표시
  final PollSelectionMode selectionMode;

  /// 각 선택지의 서버 기준 득표 수입니다. options 길이보다 짧으면 나머지는 0으로 처리합니다.
  final List<int> initialVoteCounts;

  /// 현재 사용자가 선택해 둔 선택지 index입니다.
  final Set<int> initialSelectedIndexes;

  /// 현재 사용자가 이미 투표를 완료한 상태인지 여부입니다.
  final bool initialHasVoted;

  /// 실제 API 연결 지점입니다. 현재 선택된 option index들을 전달합니다.
  final ValueChanged<Set<int>>? onVoteSubmitted;

  /// `지도보기`를 눌렀을 때 option index를 전달합니다.
  final ValueChanged<int>? onMapTap;

  /// 결과 화면의 인원수 widget을 눌렀을 때 option index를 전달합니다.
  final ValueChanged<int>? onParticipantTap;

  @override
  State<PollSelectionBox> createState() => _PollSelectionBoxState();
}

class _PollSelectionBoxState extends State<PollSelectionBox> {
  late Set<int> _selectedIndexes;
  late Set<int> _submittedIndexes;
  late List<int> _voteCounts;
  late int _participantCount;
  late bool _hasVoted;
  late bool _showResults;

  @override
  void initState() {
    super.initState();
    _syncAllFromWidget();
  }

  @override
  void didUpdateWidget(covariant PollSelectionBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    final optionsChanged = !listEquals(oldWidget.options, widget.options);
    final voteCountsChanged = !listEquals(
      oldWidget.initialVoteCounts,
      widget.initialVoteCounts,
    );
    final selectedIndexesChanged = !setEquals(
      oldWidget.initialSelectedIndexes,
      widget.initialSelectedIndexes,
    );
    final voteStateChanged =
        oldWidget.initialHasVoted != widget.initialHasVoted;

    if (optionsChanged) {
      _syncAllFromWidget();
      return;
    }

    if (voteCountsChanged) {
      _voteCounts = _normalizedVoteCounts();
    }

    if (oldWidget.participantCount != widget.participantCount) {
      _participantCount = _normalizedParticipantCount(widget.participantCount);
    }

    if (selectedIndexesChanged || voteStateChanged) {
      _selectedIndexes = _normalizedSelectedIndexes(
        widget.initialSelectedIndexes,
      );
      _hasVoted = widget.initialHasVoted;
      _submittedIndexes = _hasVoted ? Set<int>.from(_selectedIndexes) : <int>{};
      _showResults = widget.status == PollStatus.completed || _hasVoted;
    }

    if (oldWidget.status != widget.status) {
      _showResults = widget.status == PollStatus.completed || _hasVoted;
    }
  }

  void _syncAllFromWidget() {
    _selectedIndexes = _normalizedSelectedIndexes(
      widget.initialSelectedIndexes,
    );
    _hasVoted = widget.initialHasVoted;
    _submittedIndexes = _hasVoted ? Set<int>.from(_selectedIndexes) : <int>{};
    _voteCounts = _normalizedVoteCounts();
    _participantCount = _normalizedParticipantCount(widget.participantCount);
    _showResults = widget.status == PollStatus.completed || _hasVoted;
  }

  Set<int> _normalizedSelectedIndexes(Set<int> indexes) {
    return indexes
        .where((index) => index >= 0 && index < widget.options.length)
        .toSet();
  }

  List<int> _normalizedVoteCounts() {
    return List<int>.generate(widget.options.length, (index) {
      if (index >= widget.initialVoteCounts.length) {
        return 0;
      }

      final count = widget.initialVoteCounts[index];
      return count < 0 ? 0 : count;
    });
  }

  int _normalizedParticipantCount(int count) => count < 0 ? 0 : count;

  bool get _canEditVote {
    return widget.enabled &&
        widget.status == PollStatus.inProgress &&
        !_showResults;
  }

  int get _maxVoteCount {
    var maxCount = 0;

    for (final count in _voteCounts) {
      if (count > maxCount) {
        maxCount = count;
      }
    }

    return maxCount;
  }

  String get _statusText {
    switch (widget.status) {
      case PollStatus.inProgress:
        return '진행 중인 투표';
      case PollStatus.completed:
        return '투표 완료';
    }
  }

  List<String> get _pollMetaTexts {
    final texts = <String>['$_participantCount명 참여'];

    if (widget.isAnonymous) {
      texts.add('익명 투표');
    }

    switch (widget.selectionMode) {
      case PollSelectionMode.unspecified:
        break;
      case PollSelectionMode.single:
        texts.add('복수 선택 불가');
        break;
      case PollSelectionMode.multiple:
        texts.add('복수 선택 가능');
        break;
    }

    return texts;
  }

  void _toggleOption(int index) {
    if (!_canEditVote) {
      return;
    }

    setState(() {
      final isSelected = _selectedIndexes.contains(index);

      if (widget.selectionMode == PollSelectionMode.multiple) {
        if (isSelected) {
          _selectedIndexes.remove(index);
        } else {
          _selectedIndexes.add(index);
        }
        return;
      }

      if (isSelected) {
        _selectedIndexes.clear();
        return;
      }

      _selectedIndexes
        ..clear()
        ..add(index);
    });
  }

  void _submitVote() {
    if (!widget.enabled ||
        widget.status != PollStatus.inProgress ||
        _selectedIndexes.isEmpty) {
      return;
    }

    final submittedIndexes = Set<int>.from(_selectedIndexes);

    setState(() {
      if (_hasVoted) {
        for (final index in _submittedIndexes) {
          if (index >= 0 &&
              index < _voteCounts.length &&
              _voteCounts[index] > 0) {
            _voteCounts[index] -= 1;
          }
        }
      } else {
        _participantCount += 1;
      }

      for (final index in submittedIndexes) {
        if (index >= 0 && index < _voteCounts.length) {
          _voteCounts[index] += 1;
        }
      }

      _submittedIndexes = submittedIndexes;
      _hasVoted = true;
      _showResults = true;
    });

    widget.onVoteSubmitted?.call(Set<int>.unmodifiable(submittedIndexes));
  }

  void _startRevote() {
    if (!widget.enabled ||
        widget.status != PollStatus.inProgress ||
        !_hasVoted) {
      return;
    }

    setState(() {
      _selectedIndexes = Set<int>.from(_submittedIndexes);
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final inputBackgroundColor =
        inputTheme.fillColor ?? colors.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.grays.gray7, width: 1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: AppSpacing.x8,
                runSpacing: AppSpacing.x4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: context.brands.beatOrange2,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/check/check.svg',
                      colorFilter: ColorFilter.mode(
                        context.grays.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Text(
                    _statusText,
                    style: FontStyles.bold14.copyWith(
                      color: context.brands.beatOrange2,
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: AppSpacing.x4,
                runSpacing: AppSpacing.x4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (var i = 0; i < _pollMetaTexts.length; i++) ...[
                    Text(
                      _pollMetaTexts[i],
                      style: FontStyles.med12.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                    if (i != _pollMetaTexts.length - 1)
                      Text(
                        '•',
                        style: FontStyles.med12.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.options.length; i++) ...[
                _PollOptionButton(
                  text: widget.options[i],
                  isSelected: _selectedIndexes.contains(i),
                  enabled: _canEditVote,
                  backgroundColor: inputBackgroundColor,
                  onPressed: () => _toggleOption(i),
                  trailing: _showResults
                      ? _PollNumWidget(
                          text: '${_voteCounts[i]}명',
                          onTap: () => widget.onParticipantTap?.call(i),
                          color:
                              _maxVoteCount > 0 &&
                                  _voteCounts[i] == _maxVoteCount
                              ? colors.primary
                              : context.grays.black,
                        )
                      : _TextLinkButton(
                          text: '지도보기',
                          onTap: () => widget.onMapTap?.call(i),
                          color: context.brands.beatOrange1,
                        ),
                ),
                const SizedBox(height: AppSpacing.x8),
              ],
              if (widget.status == PollStatus.inProgress)
                PollButton(
                  text: _showResults ? '다시 투표하기' : '투표하기',
                  onPressed: _showResults ? _startRevote : _submitVote,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PollOptionButton extends StatelessWidget {
  const _PollOptionButton({
    required this.text,
    required this.isSelected,
    required this.enabled,
    required this.backgroundColor,
    required this.onPressed,
    required this.trailing,
  });

  final String text;
  final bool isSelected;
  final bool enabled;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final optionBackgroundColor = isSelected
        ? context.brands.beatOrange6
        : backgroundColor;
    final optionBorderColor = isSelected
        ? context.brands.beatOrange2
        : Colors.transparent;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: enabled,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x12,
              vertical: AppSpacing.x12,
            ),
            decoration: BoxDecoration(
              color: optionBackgroundColor,
              border: Border.all(color: optionBorderColor, width: 1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.x8,
                    runSpacing: AppSpacing.x4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : context.grays.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : context.grays.gray6,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: isSelected
                            ? SvgPicture.asset(
                                'assets/icons/check/check.svg',
                                colorFilter: ColorFilter.mode(
                                  context.grays.white,
                                  BlendMode.srcIn,
                                ),
                              )
                            : null,
                      ),
                      Text(
                        text,
                        style: FontStyles.reg14.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x8),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({
    required this.text,
    required this.onTap,
    required this.color,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Text(
            text,
            style: FontStyles.reg14.copyWith(
              color: color,
              decoration: TextDecoration.underline,
              decorationColor: color,
              decorationThickness: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PollNumWidget extends StatelessWidget {
  const _PollNumWidget({
    required this.text,
    required this.onTap,
    required this.color,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/post/person.svg',
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(text, style: FontStyles.reg14.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
