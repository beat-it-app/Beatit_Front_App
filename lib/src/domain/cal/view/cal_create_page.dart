import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_create_request.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_detail_response.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_update_request.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_mutation_provider.dart';
import 'package:beatit_front_app/src/domain/cal/view/schedule_file_preview_page.dart';
import 'package:beatit_front_app/src/domain/cal/widget/add_member_button.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/model/music_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/provider/location_detail_provider.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/member_selection_page.dart';
import 'package:beatit_front_app/src/domain/etc/view/music_search_page.dart';
import 'package:beatit_front_app/src/domain/etc/widget/member_selection_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalCreatePage extends ConsumerStatefulWidget {
  const CalCreatePage({super.key, this.initialSchedule});

  /// 값이 있으면 동일한 화면을 일정 수정 화면으로 사용한다.
  final ScheduleDetailData? initialSchedule;

  @override
  ConsumerState<CalCreatePage> createState() => _CalCreatePageState();
}

class _CalCreatePageState extends ConsumerState<CalCreatePage> {
  static final DateTime _firstScheduleDate = DateTime(2020, 1, 1);
  static final DateTime _lastScheduleDate = DateTime(2035, 12, 31);
  static const int _maxMusicCount = 10;
  static const int _maxFileCount = 10;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int? _selectedLocationId;

  final List<_SelectedMember> _selectedMembers = <_SelectedMember>[];
  final List<_SelectedMusic> _selectedMusics = <_SelectedMusic>[];
  final List<_SelectedFile> _selectedFiles = <_SelectedFile>[];
  final List<ScheduleDetailFile> _retainedFiles = <ScheduleDetailFile>[];

  bool _showValidation = false;
  bool _isDirty = false;
  bool _membersWereEdited = false;

  bool get _isEditMode => widget.initialSchedule != null;

  int get _fileCount => _retainedFiles.length + _selectedFiles.length;

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
    if (_isEditMode) {
      return _isDirty;
    }

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

  @override
  void initState() {
    super.initState();
    _applyInitialSchedule();
  }

  void _applyInitialSchedule() {
    final schedule = widget.initialSchedule;
    if (schedule == null) {
      return;
    }

    final startsAt = schedule.startsAt.toLocal();
    final endsAt = schedule.endsAt.toLocal();

    _titleController.text = schedule.title;
    _contentController.text = schedule.content ?? '';
    _selectedDate = DateUtils.dateOnly(startsAt);
    _startTime = TimeOfDay.fromDateTime(startsAt);
    _endTime = TimeOfDay.fromDateTime(endsAt);
    _dateController.text = _formatDate(startsAt);
    _startTimeController.text = _formatTime(_startTime!);
    _endTimeController.text = _formatTime(_endTime!);
    _selectedLocationId = schedule.locationId;

    _selectedMusics.addAll(
      schedule.musics.map(
        (music) => _SelectedMusic(
          existingMusicId: music.musicId,
          title: music.musicTitle ?? '제목 없음',
          artist: music.musicArtist ?? '아티스트 정보 없음',
          previewUrl: music.musicPreviewUrl,
        ),
      ),
    );
    _retainedFiles.addAll(schedule.files);

    if (schedule.locationId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadInitialLocationName(schedule.locationId!);
      });
    }
  }

  Future<void> _loadInitialLocationName(int locationId) async {
    try {
      final location = await ref.read(
        locationDetailProvider(locationId).future,
      );
      if (!mounted || _selectedLocationId != locationId) {
        return;
      }

      _locationController.text = _displayLocationName(location);
    } catch (_) {
      if (!mounted || _selectedLocationId != locationId) {
        return;
      }
      _locationController.text = '장소 ID $locationId';
    }
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

    if (mutationState.isLoading) {
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

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
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
      _isDirty = true;
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
      _isDirty = true;
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
      _isDirty = true;
    });
  }

  Future<void> _submitSchedule() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _showValidation = true;
    });

    if (!_canSubmit) return;

    final selectedDate = _selectedDate!;
    final startsAt = _combineDateAndTime(selectedDate, _startTime!);
    final endsAt = _combineDateAndTime(selectedDate, _endTime!);
    final notifier = ref.read(calMutationProvider.notifier);

    final result = _isEditMode
        ? await notifier.updateSchedule(
            scheduleId: widget.initialSchedule!.scheduleId,
            request: ScheduleUpdateRequest(
              locationId: _selectedLocationId,
              title: _titleController.text.trim(),
              content: _nullableTrimmedText(_contentController.text),
              startsAt: startsAt,
              endsAt: endsAt,
              // 수정 화면에서 참여자 선택을 직접 변경했을 때만 새 목록을 보냅니다.
              // 변경하지 않았다면 null을 보내 기존 참여자를 그대로 유지합니다.
              participantUserIds: _membersWereEdited
                  ? _selectedMembers
                        .map((member) => member.userId)
                        .whereType<int>()
                        .toList(growable: false)
                  : null,
              retainMusicIds: _selectedMusics
                  .where((music) => music.existingMusicId != null)
                  .map((music) => music.existingMusicId!)
                  .toList(growable: false),
              musics: _selectedMusics
                  .where((music) => music.existingMusicId == null)
                  .map(
                    (music) => ScheduleUpdateMusicRequest(
                      musicTitle: music.title,
                      musicArtist: music.artist,
                      musicPreviewUrl: music.previewUrl,
                    ),
                  )
                  .toList(growable: false),
              retainFileIds: _retainedFiles
                  .map((file) => file.fileId)
                  .toList(growable: false),
            ),
            newFilePaths: _selectedFiles
                .map((file) => file.path)
                .toList(growable: false),
            newFileNamesByPath: <String, String>{
              for (final file in _selectedFiles) file.path: file.uploadName,
            },
          )
        : await notifier.createSchedule(
            request: ScheduleCreateRequest(
              locationId: _selectedLocationId,
              title: _titleController.text.trim(),
              content: _nullableTrimmedText(_contentController.text),
              startsAt: startsAt,
              endsAt: endsAt,
              participantUserIds: _selectedMembers
                  .map((member) => member.userId)
                  .whereType<int>()
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
            fileNamesByPath: <String, String>{
              for (final file in _selectedFiles) file.path: file.uploadName,
            },
          );

    if (!mounted) return;

    if (result == null) {
      final errorMessage =
          ref.read(calMutationProvider).errorMessage ??
          (_isEditMode ? '일정 수정에 실패했습니다.' : '일정 생성에 실패했습니다.');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEditMode ? '일정이 수정되었습니다.' : '일정이 생성되었습니다.')),
    );

    Navigator.of(context).pop(result);
  }

  Future<void> _openLocationSelector() async {
    final selectedLocation = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) =>
            const LocationSearchPage(returnRegisteredLocationOnSelect: true),
      ),
    );

    if (!mounted || selectedLocation == null) {
      return;
    }

    setState(() {
      _selectedLocationId = selectedLocation.locationId;
      _locationController.text = _displayLocationName(selectedLocation);
      _isDirty = true;
    });
  }

  Future<void> _openMemberSelector() async {
    final selected = await Navigator.of(context)
        .push<List<MemberSelectionMember>>(
          MaterialPageRoute(
            builder: (_) => MemberSelectionPage(
              initialSelectedMemberIds: _selectedMembers
                  .map((member) => member.userPublicId)
                  .toSet(),
              initialSelectedUserIds: _membersWereEdited
                  ? _selectedMembers
                        .map((member) => member.userId)
                        .whereType<int>()
                        .toSet()
                  : widget.initialSchedule?.participants
                            .map((participant) => participant.userId)
                            .toSet() ??
                        const <int>{},
            ),
          ),
        );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _selectedMembers
        ..clear()
        ..addAll(
          selected.map(
            (member) => _SelectedMember(
              userPublicId: member.id,
              userId: member.userId,
              name: member.name,
              part: _memberPart(member),
              profileImageUrl: member.profileImageUrl,
            ),
          ),
        );
      _membersWereEdited = true;
      _isDirty = true;
    });
  }

  Future<void> _openMusicSelector() async {
    if (_selectedMusics.length >= _maxMusicCount) {
      _showLimitMessage('음원은 최대 $_maxMusicCount개까지 추가할 수 있습니다.');
      return;
    }

    final selectedMusic = await Navigator.of(context).push<MusicSearchResult>(
      MaterialPageRoute(
        builder: (_) => const MusicSearchPage(returnOnSelect: true),
      ),
    );

    if (!mounted || selectedMusic == null) {
      return;
    }

    final isDuplicate = _selectedMusics.any(
      (music) =>
          music.title == selectedMusic.title &&
          music.artist == selectedMusic.artist &&
          music.previewUrl == selectedMusic.previewUrl,
    );

    if (isDuplicate) {
      _showLimitMessage('이미 추가된 음원입니다.');
      return;
    }

    setState(() {
      _selectedMusics.add(
        _SelectedMusic(
          title: selectedMusic.title,
          artist: selectedMusic.artist,
          previewUrl: selectedMusic.previewUrl,
        ),
      );
      _isDirty = true;
    });
  }

  Future<void> _openFileSelector() async {
    final remainingCount = _maxFileCount - _fileCount;
    if (remainingCount <= 0) {
      _showLimitMessage('파일은 최대 $_maxFileCount개까지 추가할 수 있습니다.');
      return;
    }

    final pickedFiles = await FilePicker.pickFiles();
    if (!mounted || pickedFiles.isEmpty) {
      return;
    }

    final addedFiles = <_SelectedFile>[];
    var skippedPathCount = 0;

    for (final file in pickedFiles) {
      if (addedFiles.length >= remainingCount) {
        break;
      }

      final path = file.path;
      if (path == null || path.trim().isEmpty) {
        skippedPathCount++;
        continue;
      }

      final isDuplicate = _selectedFiles.any((item) => item.path == path);
      if (isDuplicate) {
        continue;
      }

      final byteLength = await file.length() ?? 0;
      addedFiles.add(
        _SelectedFile.fromFile(
          path: path,
          name: file.name,
          sizeText: _formatFileSize(byteLength),
        ),
      );
    }

    if (!mounted) {
      return;
    }

    if (addedFiles.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(addedFiles);
        _isDirty = true;
      });
    }

    if (pickedFiles.length > remainingCount) {
      _showLimitMessage('파일은 최대 $_maxFileCount개까지 추가할 수 있습니다.');
    } else if (skippedPathCount > 0) {
      _showLimitMessage('업로드할 수 없는 파일은 제외했습니다.');
    }
  }

  void _showLimitMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeMember(int index) {
    setState(() {
      _selectedMembers.removeAt(index);
      _membersWereEdited = true;
      _isDirty = true;
    });
  }

  void _removeMusic(int index) {
    setState(() {
      _selectedMusics.removeAt(index);
      _isDirty = true;
    });
  }

  void _removeSelectedFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _isDirty = true;
    });
  }

  void _renameSelectedFile(int index, String baseName) {
    setState(() {
      _selectedFiles[index] = _selectedFiles[index].copyWithBaseName(baseName);
      _isDirty = true;
    });
  }

  void _removeRetainedFile(int index) {
    setState(() {
      _retainedFiles.removeAt(index);
      _isDirty = true;
    });
  }

  void _openFilePreview({
    required String fileName,
    required String source,
    String? fileSize,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScheduleFilePreviewPage(
          fileName: fileName,
          source: source,
          fileSize: fileSize,
        ),
      ),
    );
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    }
    final kilobytes = bytes / 1024;
    if (kilobytes < 1024) {
      return '${kilobytes.toStringAsFixed(kilobytes >= 100 ? 0 : 1)}KB';
    }
    final megabytes = kilobytes / 1024;
    return '${megabytes.toStringAsFixed(megabytes >= 100 ? 0 : 1)}MB';
  }

  String _displayLocationName(LocationData location) {
    final name = location.locationName?.trim();
    return name == null || name.isEmpty ? '장소 ID ${location.locationId}' : name;
  }

  String _memberPart(MemberSelectionMember member) {
    final position = member.position?.trim();
    if (position != null && position.isNotEmpty) {
      return position;
    }

    return switch (member.role) {
      MemberSelectionRole.leader => '대표',
      MemberSelectionRole.manager => '운영진',
      MemberSelectionRole.member => '멤버',
    };
  }

  String? _nullableTrimmedText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final mutationState = ref.watch(calMutationProvider);
    final isSubmitting = _isEditMode
        ? mutationState.isUpdating
        : mutationState.isCreating;

    return WillPopScope(
      onWillPop: _handleSystemBack,
      child: Scaffold(
        appBar: AppTopAppBar.closeOnly(
          title: _isEditMode ? '일정 수정하기' : '일정 생성하기',
          onClosePressed: isSubmitting ? null : _handleClose,
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
                            _isDirty = true;
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
                        const _SectionLabel(text: '시간', requiredMark: true),
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
                          onChanged: (_) {
                            _isDirty = true;
                          },
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
                        _SectionLabel(
                          text:
                              '음원 (${_selectedMusics.length}/$_maxMusicCount)',
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        _buildMusicSection(),
                        const SizedBox(height: AppSpacing.x20),
                        _SectionLabel(text: '파일 ($_fileCount/$_maxFileCount)'),
                        const SizedBox(height: AppSpacing.x8),
                        _buildFileSection(),
                        const SizedBox(height: AppSpacing.x16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x16),
                AppButton(
                  text: _isEditMode ? '수정하기' : '생성하기',
                  width: ButtonWidth.expand,
                  height: ButtonHeight.normal,
                  variant: ButtonVariant.primary,
                  isLoading: isSubmitting,
                  onPressed: isSubmitting ? null : _submitSchedule,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberSection() {
    if (_selectedMembers.isEmpty) {
      return AddMemberButton(text: '인원 선택하기', onPressed: _openMemberSelector);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: AppSpacing.x8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(_selectedMembers.length, (index) {
            final member = _selectedMembers[index];

            return _MemberInfoButton(
              memberImageUrl: member.profileImageUrl,
              memberName: member.name,
              memberPart: member.part,
              onRemove: () => _removeMember(index),
            );
          }),
          const SizedBox(width: AppSpacing.x8),
          _AddButton(onPressed: _openMemberSelector),
          const SizedBox(width: AppSpacing.x8),
        ],
      ),
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
        if (_selectedMusics.length < _maxMusicCount)
          Center(child: _AddButton(onPressed: _openMusicSelector)),
      ],
    );
  }

  Widget _buildFileSection() {
    return Column(
      children: [
        ...List.generate(_retainedFiles.length, (index) {
          final file = _retainedFiles[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x8),
            child: _RetainedFileRow(
              fileName: file.originalFileName,
              onTap: () => _openFilePreview(
                fileName: file.originalFileName,
                source: file.cdnUrl,
              ),
              onRemove: () => _removeRetainedFile(index),
            ),
          );
        }),
        ...List.generate(_selectedFiles.length, (index) {
          final file = _selectedFiles[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x8),
            child: _EditableSelectedFileRow(
              key: ValueKey(file.path),
              baseName: file.baseName,
              extension: file.extension,
              fileSize: file.sizeText,
              onNameChanged: (value) => _renameSelectedFile(index, value),
              onRemove: () => _removeSelectedFile(index),
            ),
          );
        }),
        if (_fileCount < _maxFileCount)
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
    required this.memberImageUrl,
    required this.onRemove,
  });

  final String memberName;
  final String memberPart;
  final String? memberImageUrl;
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
              _MemberProfileImage(imageUrl: memberImageUrl),
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

class _MemberProfileImage extends StatelessWidget {
  const _MemberProfileImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 60.0;
    final url = imageUrl?.trim();

    if (url == null || url.isEmpty) {
      return _fallback(context, size);
    }

    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(context, size),
      ),
    );
  }

  Widget _fallback(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.grays.gray8,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 24, color: context.grays.gray5),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.title,
    required this.onRemove,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
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

class _RetainedFileRow extends StatelessWidget {
  const _RetainedFileRow({
    required this.fileName,
    required this.onTap,
    required this.onRemove,
  });

  final String fileName;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 45),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          decoration: BoxDecoration(
            color: context.grays.gray8,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg18.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              _FileRemoveButton(fileName: fileName, onRemove: onRemove),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableSelectedFileRow extends StatelessWidget {
  const _EditableSelectedFileRow({
    super.key,
    required this.baseName,
    required this.extension,
    required this.fileSize,
    required this.onNameChanged,
    required this.onRemove,
  });

  final String baseName;
  final String extension;
  final String fileSize;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
      decoration: BoxDecoration(
        color: context.grays.gray8,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: baseName,
              onChanged: onNameChanged,
              maxLines: 1,
              cursorColor: context.colors.primary,
              style: FontStyles.reg18.copyWith(color: context.colors.onSurface),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
          if (extension.isNotEmpty)
            Text(
              '.$extension',
              style: FontStyles.reg18.copyWith(color: context.colors.onSurface),
            ),
          if (fileSize.trim().isNotEmpty) ...[
            const SizedBox(width: AppSpacing.x8),
            Text(
              fileSize,
              style: FontStyles.reg16.copyWith(color: context.grays.gray5),
            ),
          ],
          const SizedBox(width: AppSpacing.x8),
          _FileRemoveButton(
            fileName: extension.isEmpty ? baseName : '$baseName.$extension',
            onRemove: onRemove,
          ),
        ],
      ),
    );
  }
}

class _FileRemoveButton extends StatelessWidget {
  const _FileRemoveButton({required this.fileName, required this.onRemove});

  final String fileName;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$fileName 삭제',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onRemove,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: SvgPicture.asset(
            'assets/icons/cal/delete.svg',
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}

class _SelectedMember {
  const _SelectedMember({
    required this.userPublicId,
    required this.name,
    required this.part,
    this.userId,
    this.profileImageUrl,
  });

  final String userPublicId;

  /// 백엔드 팀 멤버 목록 응답에 userId가 추가되면 일정 생성/수정의
  /// participantUserIds에 연결하기 위해 함께 보관한다.
  final int? userId;

  final String name;
  final String part;
  final String? profileImageUrl;
}

class _SelectedMusic {
  const _SelectedMusic({
    required this.title,
    required this.artist,
    this.previewUrl,
    this.existingMusicId,
  });

  final String title;
  final String artist;
  final String? previewUrl;
  final int? existingMusicId;
}

class _SelectedFile {
  const _SelectedFile({
    required this.path,
    required this.originalName,
    required this.baseName,
    required this.extension,
    required this.sizeText,
  });

  factory _SelectedFile.fromFile({
    required String path,
    required String name,
    required String sizeText,
  }) {
    final dotIndex = name.lastIndexOf('.');
    final hasExtension = dotIndex > 0 && dotIndex < name.length - 1;

    return _SelectedFile(
      path: path,
      originalName: name,
      baseName: hasExtension ? name.substring(0, dotIndex) : name,
      extension: hasExtension ? name.substring(dotIndex + 1) : '',
      sizeText: sizeText,
    );
  }

  final String path;
  final String originalName;
  final String baseName;
  final String extension;
  final String sizeText;

  String get uploadName {
    final trimmedBaseName = baseName.trim();
    final resolvedBaseName = trimmedBaseName.isEmpty
        ? _fallbackBaseName(originalName)
        : trimmedBaseName;

    return extension.isEmpty
        ? resolvedBaseName
        : '$resolvedBaseName.$extension';
  }

  _SelectedFile copyWithBaseName(String value) {
    return _SelectedFile(
      path: path,
      originalName: originalName,
      baseName: value,
      extension: extension,
      sizeText: sizeText,
    );
  }

  static String _fallbackBaseName(String name) {
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex <= 0) {
      return name;
    }
    return name.substring(0, dotIndex);
  }
}
