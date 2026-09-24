import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cal/widget/add_member_button.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_create_request.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_mutation_provider.dart';

class CalCreatePage extends ConsumerStatefulWidget {
  const CalCreatePage({super.key});

  @override
  ConsumerState<CalCreatePage> createState() => _CalCreatePageState();
}

class _CalCreatePageState extends ConsumerState<CalCreatePage> {
  static final DateTime _firstScheduleDate = DateTime(2020, 1, 1);
  static final DateTime _lastScheduleDate = DateTime(2035, 12, 31);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // 장소/멤버 선택 API가 연결되면 각 선택 화면의 결과를 이 상태에 넣으면 됩니다.
  int? _selectedLocationId;
  final List<_SelectedMember> _selectedMembers = <_SelectedMember>[];

  // 음악은 ScheduleCreateRequest의 musics로 그대로 매핑합니다.
  final List<_SelectedMusic> _selectedMusics = <_SelectedMusic>[];

  // 파일 선택기가 연결되면 로컬 path를 넣어 multipart files 파트로 전송합니다.
  final List<_SelectedFile> _selectedFiles = <_SelectedFile>[];

  bool _showValidation = false;

  bool get _hasTitle => _titleController.text.trim().isNotEmpty;

  bool get _hasValidTimeRange {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      return false;
    }

    final startsAt = _combineDateAndTime(_selectedDate!, _startTime!);
    final endsAt = _combineDateAndTime(_selectedDate!, _endTime!);

    return endsAt.isAfter(startsAt);
  }

  bool get _canSubmit {
    return _hasTitle &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null &&
        _hasValidTimeRange;
  }

  bool get _hasDraft {
    return _titleController.text.trim().isNotEmpty ||
        _selectedDate != null ||
        _selectedLocationId != null ||
        _locationController.text.trim().isNotEmpty ||
        _startTime != null ||
        _endTime != null ||
        _contentController.text.trim().isNotEmpty ||
        _selectedMembers.isNotEmpty ||
        _selectedMusics.isNotEmpty ||
        _selectedFiles.isNotEmpty;
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    FocusScope.of(context).unfocus();

    if (!_hasDraft) {
      return true;
    }

    final shouldDiscard = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      warningType: WarningType.circle,
      contentType: ContentType.small,
      confirmText: '확인',
      cancelText: '취소',
      barrierDismissible: false,
    );

    return shouldDiscard == true;
  }

  Future<void> _handleClose() async {
    final canClose = await _confirmDiscardIfNeeded();

    if (!mounted || !canClose) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<bool> _handleSystemBack() async {
    final mutationState = ref.read(calMutationProvider);

    if (mutationState.isCreating) {
      return false;
    }

    return _confirmDiscardIfNeeded();
  }

  String? get _titleErrorText {
    if (!_showValidation || _hasTitle) return null;
    return '일정 이름을 입력해주세요.';
  }

  String? get _dateErrorText {
    if (!_showValidation || _selectedDate != null) return null;
    return '날짜를 선택해주세요.';
  }

  String? get _startTimeErrorText {
    if (!_showValidation || _startTime != null) return null;
    return '시작 시간을 선택해주세요.';
  }

  String? get _endTimeErrorText {
    if (!_showValidation) return null;

    if (_endTime == null) {
      return '끝나는 시간을 선택해주세요.';
    }

    if (_startTime != null && !_hasValidTimeRange) {
      return '끝나는 시간은 시작 시간보다 늦어야 합니다.';
    }

    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    FocusScope.of(context).unfocus();

    final selectedDate = await AppTimeBottomSheet.showDatePicker(
      context,
      title: '일정 날짜 선택',
      initialDate: _selectedDate ?? DateTime.now(),
      startYear: _firstScheduleDate.year,
      maxDate: _lastScheduleDate,
    );

    if (!mounted || selectedDate == null) return;

    setState(() {
      _selectedDate = DateUtils.dateOnly(selectedDate);
      _dateController.text = _formatDate(selectedDate);
    });
  }

  Future<void> _selectStartTime() async {
    FocusScope.of(context).unfocus();

    final selectedTime = await AppTimeBottomSheet.showTimePicker(
      context,
      title: '시작 시간 선택',
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (!mounted || selectedTime == null) return;

    setState(() {
      _startTime = selectedTime;
      _startTimeController.text = _formatTime(selectedTime);
    });
  }

  Future<void> _selectEndTime() async {
    FocusScope.of(context).unfocus();

    final selectedTime = await AppTimeBottomSheet.showTimePicker(
      context,
      title: '끝나는 시간 선택',
      initialTime: _endTime ?? _startTime ?? TimeOfDay.now(),
    );

    if (!mounted || selectedTime == null) return;

    setState(() {
      _endTime = selectedTime;
      _endTimeController.text = _formatTime(selectedTime);
    });
  }

  Future<void> _createSchedule() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _showValidation = true;
    });

    if (!_canSubmit) return;

    final selectedDate = _selectedDate!;
    final startsAt = _combineDateAndTime(selectedDate, _startTime!);
    final endsAt = _combineDateAndTime(selectedDate, _endTime!);

    final result = await ref
        .read(calMutationProvider.notifier)
        .createSchedule(
          request: ScheduleCreateRequest(
            locationId: _selectedLocationId,
            title: _titleController.text.trim(),
            content: _nullableTrimmedText(_contentController.text),
            startsAt: startsAt,
            endsAt: endsAt,
            participantUserIds: _selectedMembers
                .map((member) => member.userId)
                .toList(growable: false),
            musics: _selectedMusics
                .map(
                  (music) => ScheduleCreateMusicRequest(
                    musicTitle: music.title,
                    musicArtist: music.artist,
                    musicPreviewUrl: music.previewUrl,
                  ),
                )
                .toList(growable: false),
          ),
          filePaths: _selectedFiles
              .map((file) => file.path)
              .toList(growable: false),
        );

    if (!mounted) return;

    if (result == null) {
      final errorMessage =
          ref.read(calMutationProvider).errorMessage ?? '일정 생성에 실패했습니다.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('일정이 생성되었습니다.')));

    Navigator.of(context).pop(result);
  }

  void _openLocationSelector() {
    // TODO: 장소 검색/선택 화면 연결 후 아래 세 값을 갱신하면 됩니다.
    // _selectedLocationId = result.locationId;
    // _locationController.text = result.name;
    // setState(() {});
    _showPendingSelectorMessage('장소 선택');
  }

  void _openMemberSelector() {
    // TODO: 팀 멤버 선택 API/화면 연결 후 _selectedMembers를 갱신합니다.
    _showPendingSelectorMessage('참여 인원 선택');
  }

  void _openMusicSelector() {
    // TODO: 음원 선택 화면 연결 후 _selectedMusics를 갱신합니다.
    _showPendingSelectorMessage('음원 선택');
  }

  void _openFileSelector() {
    // TODO: 파일 선택기 연결 후 _selectedFiles에 로컬 파일 path를 추가합니다.
    _showPendingSelectorMessage('파일 선택');
  }

  void _showPendingSelectorMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능은 선택 API 연결 후 사용할 수 있습니다.')),
    );
  }

  void _removeMember(int index) {
    setState(() {
      _selectedMembers.removeAt(index);
    });
  }

  void _removeMusic(int index) {
    setState(() {
      _selectedMusics.removeAt(index);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = <String>['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}. $month. $day.($weekday)';
  }

  String _formatTime(TimeOfDay time) {
    final isPm = time.hour >= 12;
    final period = isPm ? '오후' : '오전';
    var displayHour = time.hourOfPeriod;
    if (displayHour == 0) displayHour = 12;
    final minute = time.minute.toString().padLeft(2, '0');

    return '$period $displayHour:$minute';
  }

  String? _nullableTrimmedText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final mutationState = ref.watch(calMutationProvider);

    return WillPopScope(
      onWillPop: _handleSystemBack,
      child: Scaffold(
        appBar: AppTopAppBar.closeOnly(
          title: '일정 생성하기',
          onClosePressed: mutationState.isCreating ? null : _handleClose,
        ),
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
                      AppTextField(
                        label: '일정 이름',
                        requiredMark: true,
                        hintText: '일정 이름을 작성하세요.',
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        errorText: _titleErrorText,
                        onChanged: (_) {
                          if (_showValidation) setState(() {});
                        },
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextField(
                        label: '날짜',
                        requiredMark: true,
                        hintText: '날짜를 선택해주세요.',
                        controller: _dateController,
                        readOnly: true,
                        errorText: _dateErrorText,
                        onTap: _selectDate,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/calendar.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextField(
                        label: '장소',
                        hintText: '모임 장소를 검색하세요.',
                        controller: _locationController,
                        readOnly: true,
                        onTap: _openLocationSelector,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/search.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _SectionLabel(text: '시간', requiredMark: true),
                      const SizedBox(height: AppSpacing.x8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: '시작 시간',
                              controller: _startTimeController,
                              readOnly: true,
                              errorText: _startTimeErrorText,
                              onTap: _selectStartTime,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/cal/clock.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              '-',
                              style: FontStyles.reg18.copyWith(
                                color: context.grays.gray4,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x10),
                          Expanded(
                            child: AppTextField(
                              hintText: '끝나는 시간',
                              controller: _endTimeController,
                              readOnly: true,
                              errorText: _endTimeErrorText,
                              onTap: _selectEndTime,
                              suffixIcon: SvgPicture.asset(
                                'assets/icons/cal/clock.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextArea(
                        label: '일정 설명',
                        hintText: '모임에 어울리는 일정 소개글을 작성해주세요.',
                        controller: _contentController,
                        maxLength: 200,
                        fieldHeight: 120,
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _SectionLabel(
                        text: _selectedMembers.isEmpty
                            ? '참여 인원'
                            : '참여 인원 (${_selectedMembers.length})',
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      _buildMemberSection(),

                      const SizedBox(height: AppSpacing.x20),

                      _SectionLabel(text: '음원'),
                      const SizedBox(height: AppSpacing.x8),
                      _buildMusicSection(),

                      const SizedBox(height: AppSpacing.x20),

                      _SectionLabel(text: '파일'),
                      const SizedBox(height: AppSpacing.x8),
                      _buildFileSection(),

                      const SizedBox(height: AppSpacing.x16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '생성하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                isLoading: mutationState.isCreating,
                onPressed: mutationState.isCreating ? null : _createSchedule,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddMemberButton(
          text: '인원 선택하기',
          onPressed: _openMemberSelector,
        ),
        if (_selectedMembers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: AppSpacing.x8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_selectedMembers.length, (index) {
                final member = _selectedMembers[index];

                return _MemberInfoButton(
                  memberImage: member.profileImage,
                  memberName: member.name,
                  memberPart: member.part,
                  onRemove: () => _removeMember(index),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMusicSection() {
    return Column(
      children: [
        ...List.generate(_selectedMusics.length, (index) {
          final music = _selectedMusics[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x8),
            child: _SelectionRow(
              title: music.title,
              subtitle: music.artist,
              onRemove: () => _removeMusic(index),
            ),
          );
        }),
        Center(child: _AddButton(onPressed: _openMusicSelector)),
      ],
    );
  }

  Widget _buildFileSection() {
    return Column(
      children: [
        ...List.generate(_selectedFiles.length, (index) {
          final file = _selectedFiles[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x8),
            child: _SelectionRow(
              title: file.name,
              trailingText: file.sizeText,
              onRemove: () => _removeFile(index),
            ),
          );
        }),
        Center(child: _AddButton(onPressed: _openFileSelector)),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, this.requiredMark = false});

  final String text;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = FontStyles.semi16.copyWith(color: colors.onSurface);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text),
          if (requiredMark)
            TextSpan(
              text: ' *',
              style: style.copyWith(color: colors.primary),
            ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34,
        width: 34,
        decoration: ShapeDecoration(
          color: context.grays.gray8,
          shape: const OvalBorder(),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/cal/plus.svg',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _MemberInfoButton extends StatelessWidget {
  const _MemberInfoButton({
    required this.memberName,
    required this.memberPart,
    required this.memberImage,
    required this.onRemove,
  });

  final String memberName;
  final String memberPart;
  final String memberImage;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: Image.asset(
                  memberImage,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: context.grays.gray8,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: context.grays.gray5,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: ShapeDecoration(
                            color: context.colors.surface,
                            shape: const OvalBorder(),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/cal/delete.svg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            memberName,
            style: FontStyles.semi18.copyWith(color: context.grays.gray1),
          ),
          Text(
            memberPart,
            style: FontStyles.reg14.copyWith(color: context.grays.gray4),
          ),
        ],
      ),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.title,
    required this.onRemove,
    this.subtitle,
    this.trailingText,
  });

  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x8,
      ),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg16.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.med12.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
              ],
            ),
          ),
          if (trailingText != null) ...[
            const SizedBox(width: AppSpacing.x8),
            Text(
              trailingText!,
              style: FontStyles.med12.copyWith(color: context.grays.gray5),
            ),
          ],
          const SizedBox(width: AppSpacing.x8),
          GestureDetector(
            onTap: onRemove,
            child: SvgPicture.asset(
              'assets/icons/cal/delete.svg',
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedMember {
  const _SelectedMember({
    required this.userId,
    required this.name,
    required this.part,
    required this.profileImage,
  });

  final int userId;
  final String name;
  final String part;
  final String profileImage;
}

class _SelectedMusic {
  const _SelectedMusic({
    required this.title,
    required this.artist,
    this.previewUrl,
  });

  final String title;
  final String artist;
  final String? previewUrl;
}

class _SelectedFile {
  const _SelectedFile({
    required this.path,
    required this.name,
    required this.sizeText,
  });

  final String path;
  final String name;
  final String sizeText;
}
