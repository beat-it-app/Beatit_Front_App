import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_switch.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/post/post_date_time.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';
import 'package:beatit_front_app/src/domain/post/widget/poll_add_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollCreatePage extends ConsumerStatefulWidget {
  const PollCreatePage({
    super.key,
    this.initialData,
    this.initialRemindBeforeClose = false,
  });

  final PollDetailData? initialData;
  final bool initialRemindBeforeClose;

  bool get isEditing => initialData != null;

  @override
  ConsumerState<PollCreatePage> createState() => _PollCreatePageState();
}

class _PollCreatePageState extends ConsumerState<PollCreatePage> {
  static const int _maxTitleLength = 200;
  static const int _maxContentLength = 500;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController();
  final TextEditingController _deadlineTimeController = TextEditingController();

  final _optionKey = GlobalKey<PollAddBoxState>();
  final Map<int, MusicSearchResult> _musicChoices = {};
  final Map<int, LocationData> _placeChoices = {};
  final Map<int, PollDetailItem> _initialItemsByOptionId = {};
  final Set<String> _voteSelectedOptions = {};
  final List<String> _voteOptions = ['익명 투표', '중복 투표'];

  DateTime? _closeAt;
  DateTime? _selectedDeadlineDate;
  TimeOfDay? _selectedDeadlineTime;
  bool _remindBeforeClose = false;
  bool _submitting = false;

  PollOptionType _pollOptionType = PollOptionType.text;
  List<PollOptionValue> _pollOptions = const [];

  String? _titleError;
  String? _contentError;
  String? _pollOptionsError;
  String? _deadlineError;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialData;
    if (initial == null) return;

    _titleController.text = initial.title;
    _contentController.text = initial.content ?? '';
    _pollOptionType = _pollOptionTypeFromServer(initial.pollType);
    _pollOptions = List<PollOptionValue>.generate(
      initial.pollItems.length,
      (index) => PollOptionValue(
        id: index,
        value: _displayValue(initial.pollItems[index], _pollOptionType),
      ),
      growable: false,
    );
    _initialItemsByOptionId.addEntries(
      initial.pollItems.asMap().entries.map(
        (entry) => MapEntry(entry.key, entry.value),
      ),
    );

    _closeAt = initial.closeAt?.toLocal();
    if (_closeAt != null) {
      _selectedDeadlineDate = DateUtils.dateOnly(_closeAt!);
      _selectedDeadlineTime = TimeOfDay.fromDateTime(_closeAt!);
      _deadlineDateController.text = formatPostDate(_closeAt!);
      _deadlineTimeController.text = formatPostTime(
        _closeAt!.hour,
        _closeAt!.minute,
      );
    }

    _remindBeforeClose = widget.initialRemindBeforeClose;
    if (initial.isAnonymous) {
      _voteSelectedOptions.add('익명 투표');
    }
    if (initial.allowMultipleChoice) {
      _voteSelectedOptions.add('중복 투표');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _deadlineDateController.dispose();
    _deadlineTimeController.dispose();
    super.dispose();
  }

  void _handlePollOptionsChanged(
    PollOptionType type,
    List<PollOptionValue> options,
  ) {
    if (type != _pollOptionType) {
      _musicChoices.clear();
      _placeChoices.clear();
      _initialItemsByOptionId.clear();
    }

    _pollOptionType = type;
    _pollOptions = options;

    _pollOptionsError = null;

    // PollAddBox가 initState에서 초기 값을 전달할 수 있으므로,
    // 부모 build 중 setState가 발생하지 않도록 다음 프레임에 버튼 상태를 갱신한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  PollOptionType _pollOptionTypeFromServer(String value) {
    return switch (value) {
      'MUSIC' => PollOptionType.music,
      'LOCATION' => PollOptionType.place,
      _ => PollOptionType.text,
    };
  }

  String _displayValue(PollDetailItem item, PollOptionType type) {
    return switch (type) {
      PollOptionType.text => item.content ?? '',
      PollOptionType.music => [
          item.title,
          item.artist,
        ].whereType<String>().where((value) => value.isNotEmpty).join(' - '),
      PollOptionType.place =>
        item.locationName ?? item.location ?? item.roadAddress ?? '',
    };
  }

  Future<void> _handleMusicPressed(int index) async {
    final id = _pollOptions[index].id;
    final chosen = await Navigator.of(context).push<MusicSearchResult>(
      MaterialPageRoute(
        builder: (_) => const MusicSearchPage(returnOnSelect: true),
      ),
    );
    if (chosen == null || !mounted) return;

    _musicChoices[id] = chosen;
    _optionKey.currentState?.setOptionById(
      id,
      '${chosen.title} - ${chosen.artist}',
    );
  }

  Future<void> _handlePlacePressed(int index) async {
    final id = _pollOptions[index].id;
    final chosen = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) =>
            const LocationSearchPage(returnRegisteredLocationOnSelect: true),
      ),
    );
    if (chosen == null || !mounted) return;

    _placeChoices[id] = chosen;
    _optionKey.currentState?.setOptionById(
      id,
      chosen.locationName ?? chosen.roadAddress ?? '장소',
    );
  }

  Future<void> _pickDeadlineDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDeadlineDate ?? now;
    final date = await AppTimeBottomSheet.showDatePicker(
      context,
      title: '투표 마감 날짜',
      initialDate: initialDate,
      startYear: now.year,
      maxDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    setState(() {
      _selectedDeadlineDate = DateUtils.dateOnly(date);
      _deadlineDateController.text = formatPostDate(date);
      _updateDeadline();
    });
  }

  Future<void> _pickDeadlineTime() async {
    final now = DateTime.now();
    final initialTime = _selectedDeadlineTime ??
        TimeOfDay.fromDateTime(
          _roundUpToTenMinutes(now.add(const Duration(hours: 1))),
        );
    final time = await AppTimeBottomSheet.showTimePicker(
      context,
      title: '투표 마감 시간',
      initialTime: initialTime,
      minuteInterval: 10,
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDeadlineTime = time;
      _deadlineTimeController.text = formatPostTime(time.hour, time.minute);
      _updateDeadline();
    });
  }

  void _clearDeadline() {
    setState(() {
      _selectedDeadlineDate = null;
      _selectedDeadlineTime = null;
      _deadlineDateController.clear();
      _deadlineTimeController.clear();
      _closeAt = null;
      _deadlineError = null;
      _remindBeforeClose = false;
    });
  }

  void _updateDeadline() {
    final date = _selectedDeadlineDate;
    final time = _selectedDeadlineTime;
    if (date == null || time == null) {
      _closeAt = null;
      _deadlineError = null;
      return;
    }

    final deadline = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    _closeAt = deadline;
    _deadlineError = deadline.isAfter(DateTime.now())
        ? null
        : '투표 마감 시간은 현재 시간 이후여야 합니다.';
  }

  DateTime _roundUpToTenMinutes(DateTime dateTime) {
    final remainder = dateTime.minute % 10;
    if (remainder == 0) {
      return DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
      );
    }

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    ).add(Duration(minutes: 10 - remainder));
  }

  PollCreateRequest _buildInitialRequest() {
    final initial = widget.initialData!;
    final initialType = _pollOptionTypeFromServer(initial.pollType);
    final type = switch (initialType) {
      PollOptionType.music => 'MUSIC',
      PollOptionType.place => 'LOCATION',
      PollOptionType.text => 'TEXT',
    };

    return PollCreateRequest(
      title: initial.title.trim(),
      content: (initial.content ?? '').trim(),
      pollType: type,
      pollList: initial.pollItems
          .map(
            (item) => PollCreateItem(
              content: type == 'TEXT' ? (item.content ?? '').trim() : null,
              music: type == 'MUSIC'
                  ? PollCreateMusic(
                      title: item.title ?? '',
                      artist: item.artist ?? '',
                      previewUrl: item.previewUrl,
                    )
                  : null,
              location: type == 'LOCATION'
                  ? (item.location ??
                        item.locationName ??
                        item.roadAddress ??
                        '')
                  : null,
              locationId: type == 'LOCATION' ? item.locationId : null,
            ),
          )
          .toList(growable: false),
      allowMultipleChoice: initial.allowMultipleChoice,
      isAnonymous: initial.isAnonymous,
      remindBeforeClose: widget.initialRemindBeforeClose,
      closeAt: initial.closeAt?.toLocal(),
    );
  }

  bool get _hasChanges {
    if (!widget.isEditing) return true;
    return _buildRequest() != _buildInitialRequest();
  }

  bool _arePollOptionsValid() {
    if (_pollOptions.length < 2) return false;

    return _pollOptions.every((option) {
      final value = option.value.trim();
      if (value.isEmpty) return false;

      final initialItem = _initialItemsByOptionId[option.id];
      return switch (_pollOptionType) {
        PollOptionType.text => true,
        PollOptionType.music =>
          _musicChoices.containsKey(option.id) ||
              (initialItem?.title?.isNotEmpty == true),
        PollOptionType.place =>
          _placeChoices.containsKey(option.id) ||
              (initialItem?.locationId != null) ||
              (initialItem?.location?.trim().isNotEmpty == true),
      };
    });
  }

  String? _pollOptionsValidationMessage() {
    if (_pollOptions.length < 2) {
      return '투표 항목을 2개 이상 입력해주세요.';
    }

    if (!_arePollOptionsValid()) {
      return '투표 항목을 입력해주세요.';
    }

    return null;
  }

  bool _validateRequiredFields() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final deadline = _closeAt;
    final hasPartialDeadline =
        (_selectedDeadlineDate == null) != (_selectedDeadlineTime == null);

    setState(() {
      _titleError = title.isEmpty
          ? '투표 제목을 입력해주세요.'
          : title.length > _maxTitleLength
          ? '투표 제목은 $_maxTitleLength자 이하로 입력해주세요.'
          : null;
      _contentError = content.length > _maxContentLength
          ? '투표 내용은 $_maxContentLength자 이하로 입력해주세요.'
          : null;
      _pollOptionsError = _pollOptionsValidationMessage();
      _deadlineError = hasPartialDeadline
          ? '투표 마감 날짜와 시간을 모두 선택해주세요.'
          : deadline != null && !deadline.isAfter(DateTime.now())
              ? '투표 마감 시간은 현재 시간 이후여야 합니다.'
              : null;
    });

    return _titleError == null &&
        _contentError == null &&
        _pollOptionsError == null &&
        _deadlineError == null;
  }

  void _handleTitleChanged(String value) {
    final title = value.trim();

    setState(() {
      if (title.length > _maxTitleLength) {
        _titleError = '투표 제목은 $_maxTitleLength자 이하로 입력해주세요.';
      } else if (_titleError != null) {
        _titleError = null;
      }
    });
  }

  void _handleContentChanged(String value) {
    final content = value.trim();

    setState(() {
      _contentError = content.length > _maxContentLength
          ? '투표 내용은 $_maxContentLength자 이하로 입력해주세요.'
          : null;
    });
  }

  Future<void> _handleClose() async {
    final confirmed = await AppPopup.show(
      context,
      title: widget.isEditing ? '수정을 중단하시겠습니까?' : '작성을 중단하시겠습니까?',
      content: widget.isEditing
          ? '중단 시, 수정된 내용은\n저장되지 않습니다.'
          : '중단 시, 작성된 내용은\n저장되지 않습니다.',
      buttonNum: ButtonNum.two,
      warningType: WarningType.circle,
      contentType: ContentType.small,
      confirmText: '확인',
      cancelText: '취소',
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  PollCreateRequest _buildRequest() {
    final type = switch (_pollOptionType) {
      PollOptionType.music => 'MUSIC',
      PollOptionType.place => 'LOCATION',
      PollOptionType.text => 'TEXT',
    };

    final options = <PollCreateItem>[];
    for (final option in _pollOptions) {
      final text = option.value.trim();
      final music = _musicChoices[option.id];
      final place = _placeChoices[option.id];
      final initialItem = _initialItemsByOptionId[option.id];

      options.add(
        PollCreateItem(
          content: type == 'TEXT' ? text : null,
          music: type == 'MUSIC'
              ? PollCreateMusic(
                  title: music?.title ?? initialItem?.title ?? '',
                  artist: music?.artist ?? initialItem?.artist ?? '',
                  previewUrl: music?.previewUrl ?? initialItem?.previewUrl,
                )
              : null,
          location: type == 'LOCATION'
              ? (place != null
                    ? (place.locationName ?? place.roadAddress ?? text)
                    : (initialItem?.location ?? initialItem?.locationName ?? text))
              : null,
          locationId: type == 'LOCATION'
              ? (place?.locationId ?? initialItem?.locationId)
              : null,
        ),
      );
    }

    return PollCreateRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      pollType: type,
      pollList: options,
      allowMultipleChoice: _voteSelectedOptions.contains('중복 투표'),
      isAnonymous: _voteSelectedOptions.contains('익명 투표'),
      remindBeforeClose: _closeAt != null && _remindBeforeClose,
      closeAt: _closeAt,
    );
  }

  bool get _hasRequiredInputs {
    return _titleController.text.trim().isNotEmpty &&
        _pollOptions.length >= 2 &&
        _pollOptions.every((option) => option.value.trim().isNotEmpty);
  }

  Future<void> _submitPoll() async {
    if (_submitting || !_hasRequiredInputs ||
        (widget.isEditing && !_hasChanges)) return;
    if (!_validateRequiredFields()) return;

    final request = _buildRequest();
    setState(() => _submitting = true);

    try {
      final api = ref.read(postApiProvider);
      if (widget.initialData != null) {
        await api.updatePoll(widget.initialData!.pollId, request);
      } else {
        await api.createPoll(request);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(onClosePressed: _handleClose),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x4,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.x20),
                      AppTextField(
                        label: '투표 제목',
                        requiredMark: true,
                        hintText: '제목',
                        controller: _titleController,
                        errorText: _titleError,
                        onChanged: _handleTitleChanged,
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      _RequiredLabel(
                        text: '내용',
                        color: colors.onSurface,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextArea(
                        hintText: '투표 내용을 작성해주세요.',
                        controller: _contentController,
                        errorText: _contentError,
                        onChanged: _handleContentChanged,
                        maxLength: _maxContentLength,
                        fieldHeight: 200,
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      _RequiredLabel(
                        text: '투표란',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      PollAddBox(
                        key: _optionKey,
                        initialType: _pollOptionType,
                        initialValues: widget.initialData == null
                            ? const <String>[]
                            : _pollOptions
                                .map((option) => option.value)
                                .toList(growable: false),
                        onChanged: _handlePollOptionsChanged,
                        onMusicPressed: _handleMusicPressed,
                        onPlacePressed: _handlePlacePressed,
                      ),
                      if (_pollOptionsError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(
                          text: _pollOptionsError!,
                          isError: true,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x20),
                      _RequiredLabel(
                        text: '투표 마감 시간 설정',
                        color: colors.onSurface,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: AppTextField(
                              hintText: '날짜 선택',
                              controller: _deadlineDateController,
                              readOnly: true,
                              onTap: _pickDeadlineDate,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/cal/calendar.svg',
                              ),
                              isError: _deadlineError != null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x8),
                          Expanded(
                            flex: 4,
                            child: AppTextField(
                              hintText: '시간 선택',
                              controller: _deadlineTimeController,
                              readOnly: true,
                              onTap: _pickDeadlineTime,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/post/clock.svg',
                              ),
                              isError: _deadlineError != null,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedDeadlineDate != null ||
                          _selectedDeadlineTime != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _clearDeadline,
                            child: const Text('마감 시간 삭제'),
                          ),
                        ),
                      if (_closeAt != null) ...[
                        const SizedBox(height: AppSpacing.x8),
                        Text(
                          formatPostDateTime(_closeAt!),
                          style: FontStyles.med14.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (_deadlineError != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        AppFieldMessage(text: _deadlineError!, isError: true),
                      ],
                      const SizedBox(height: AppSpacing.x20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '투표 마감 알림',
                                  style: FontStyles.reg18.copyWith(
                                    color: context.grays.black,
                                  ),
                                ),
                                Text(
                                  '투표 마감 하루 전과 1시간 전에 알림을 보내드릴게요.',
                                  style: FontStyles.med14.copyWith(
                                    color: context.grays.gray4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IgnorePointer(
                            ignoring: _closeAt == null,
                            child: Opacity(
                              opacity: _closeAt == null ? 0.45 : 1,
                              child: AppSwitch(
                                value: _remindBeforeClose,
                                onChanged: (value) {
                                  setState(() => _remindBeforeClose = value);
                                },
                                height: 27.0,
                                width: 50.0,
                                ballPadding: 2.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      _RequiredLabel(text: '투표 옵션', color: colors.onSurface),
                      const SizedBox(height: AppSpacing.x8),
                      Wrap(
                        spacing: AppSpacing.x8,
                        runSpacing: AppSpacing.x8,
                        alignment: WrapAlignment.start,
                        children: _voteOptions.map((option) {
                          return AppToggle(
                            text: option,
                            isSelected: _voteSelectedOptions.contains(option),
                            onChanged: (bool isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _voteSelectedOptions.add(option);
                                } else {
                                  _voteSelectedOptions.remove(option);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.x16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: widget.isEditing ? '수정하기' : '등록하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _submitting || !_hasRequiredInputs ||
                    (widget.isEditing && !_hasChanges)
                    ? null
                    : _submitPoll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    this.requiredColor,
  });

  final String text;
  final Color color;
  final Color? requiredColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: FontStyles.semi16.copyWith(color: color),
          children: [
            TextSpan(text: text),
            if (requiredColor != null)
              TextSpan(
                text: ' *',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: requiredColor),
              ),
          ],
        ),
      ),
    );
  }
}
