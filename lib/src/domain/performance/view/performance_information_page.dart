// lib/src/domain/performance/view/performance_information_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_ticket_selector.dart';
import 'package:beatit_front_app/src/domain/performance/widget/progress_bar_widget.dart';

import '../widget/performance_form_widgets.dart';

class PerformanceInformationPage extends StatefulWidget {
  const PerformanceInformationPage({super.key, this.editTarget});

  final PerformanceDetailModel? editTarget;

  @override
  State<PerformanceInformationPage> createState() =>
      _PerformanceInformationPageState();
}

class _PerformanceInformationPageState
    extends State<PerformanceInformationPage> {
  final _title = TextEditingController();
  final _startDateText = TextEditingController();
  final _startTimeText = TextEditingController();
  final _locationText = TextEditingController();
  final _introduction = TextEditingController();
  final _bookingCloseDateText = TextEditingController();
  final _bookingCloseTimeText = TextEditingController();
  final _bookingUrl = TextEditingController();
  final _hostName = TextEditingController();
  final _hostContact = TextEditingController();

  final _prices = <PerformanceTicketType, TextEditingController>{
    for (final type in PerformanceTicketType.values)
      if (type != PerformanceTicketType.free) type: TextEditingController(),
  };

  final Set<PerformanceTicketType> _ticketTypes = {};
  PerformanceHostContactType _hostType = PerformanceHostContactType.link;

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _bookingCloseDate;
  TimeOfDay? _bookingCloseTime;

  LocationData? _location;
  XFile? _poster;
  String? _existingPosterUrl;
  bool _isPosterOverlayActive = false;

  Map<String, dynamic>? _step2Draft;
  Map<String, dynamic>? _step3Draft;

  final ImagePicker _picker = ImagePicker();

  bool get _isEditMode => widget.editTarget != null;

  DateTime? get _startsAt => (_startDate != null && _startTime != null)
      ? DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        )
      : null;

  DateTime? get _bookingClosesAt =>
      (_bookingCloseDate != null && _bookingCloseTime != null)
      ? DateTime(
          _bookingCloseDate!.year,
          _bookingCloseDate!.month,
          _bookingCloseDate!.day,
          _bookingCloseTime!.hour,
          _bookingCloseTime!.minute,
        )
      : null;

  bool get _usesBooking =>
      _ticketTypes.contains(PerformanceTicketType.advance) ||
      _ticketTypes.contains(PerformanceTicketType.general);

  bool get _pricesValid => _ticketTypes.every(
    (type) =>
        type == PerformanceTicketType.free ||
        (int.tryParse(_prices[type]!.text.trim()) != null &&
            int.parse(_prices[type]!.text.trim()) >= 0),
  );

  bool get _isFormValid =>
      _title.text.trim().isNotEmpty &&
      _startsAt != null &&
      _location != null &&
      _introduction.text.trim().isNotEmpty &&
      _ticketTypes.isNotEmpty &&
      _pricesValid &&
      (!_usesBooking ||
          (_bookingClosesAt != null &&
              _bookingClosesAt!.isBefore(_startsAt!) &&
              _bookingUrl.text.trim().isNotEmpty)) &&
      _hostName.text.trim().isNotEmpty &&
      _hostContact.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _title.addListener(_onFieldChanged);
    _introduction.addListener(_onFieldChanged);
    _bookingUrl.addListener(_onFieldChanged);
    _hostName.addListener(_onFieldChanged);
    _hostContact.addListener(_onFieldChanged);

    if (_isEditMode) {
      _prefillData(widget.editTarget!);
    }
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  void _unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _prefillData(PerformanceDetailModel target) {
    final detail = target.toDetailData();

    _title.text = detail.title;
    _introduction.text = detail.introduction;

    final start = detail.startsAt;
    _startDate = DateUtils.dateOnly(start);
    _startTime = TimeOfDay.fromDateTime(start);
    _startDateText.text =
        '${start.year}. ${start.month.toString().padLeft(2, '0')}. ${start.day.toString().padLeft(2, '0')}.';
    _startTimeText.text =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';

    _location = detail.location;
    _locationText.text =
        detail.location?.locationName ??
        detail.location?.roadAddress ??
        target.placeName;

    _existingPosterUrl = detail.posterUrl;

    for (final entry in detail.ticketPrices.entries) {
      _ticketTypes.add(entry.key);
      if (entry.key != PerformanceTicketType.free &&
          _prices.containsKey(entry.key)) {
        _prices[entry.key]!.text = entry.value;
      }
    }

    if (detail.bookingClosesAt != null) {
      final close = detail.bookingClosesAt!;
      _bookingCloseDate = DateUtils.dateOnly(close);
      _bookingCloseTime = TimeOfDay.fromDateTime(close);
      _bookingCloseDateText.text =
          '${close.year}. ${close.month.toString().padLeft(2, '0')}. ${close.day.toString().padLeft(2, '0')}.';
      _bookingCloseTimeText.text =
          '${close.hour.toString().padLeft(2, '0')}:${close.minute.toString().padLeft(2, '0')}';
    }
    _bookingUrl.text = detail.bookingUrl ?? '';

    _hostName.text = detail.hostName;
    _hostContact.text = detail.hostContact;
    if (detail.hostContactType != null) {
      _hostType = detail.hostContactType!;
    }
  }

  @override
  void dispose() {
    _title.removeListener(_onFieldChanged);
    _introduction.removeListener(_onFieldChanged);
    _bookingUrl.removeListener(_onFieldChanged);
    _hostName.removeListener(_onFieldChanged);
    _hostContact.removeListener(_onFieldChanged);
    _title.dispose();
    _startDateText.dispose();
    _startTimeText.dispose();
    _locationText.dispose();
    _introduction.dispose();
    _bookingCloseDateText.dispose();
    _bookingCloseTimeText.dispose();
    _bookingUrl.dispose();
    _hostName.dispose();
    _hostContact.dispose();
    for (final c in _prices.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleClose() async {
    _unfocusAll();

    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      warningType: WarningType.circle,
      buttonNum: ButtonNum.two,
      confirmText: '나가기',
      cancelText: '계속 작성',
    );

    if (!mounted) return;
    _unfocusAll();

    if (confirmed == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectStartDate() async {
    _unfocusAll();
    final value = await PerformanceDateTimePicker.pickDate(
      context,
      title: '공연',
      initial: _startDate,
    );
    if (!mounted) return;
    _unfocusAll();
    if (value == null) return;

    final today = DateUtils.dateOnly(DateTime.now());
    if (DateUtils.dateOnly(value).isBefore(today)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('과거 날짜는 선택할 수 없습니다.')));
      return;
    }

    setState(() {
      _startDate = value;
      _startDateText.text =
          '${value.year}. ${value.month.toString().padLeft(2, '0')}. ${value.day.toString().padLeft(2, '0')}.';
    });
  }

  Future<void> _selectStartTime() async {
    _unfocusAll();
    final value = await PerformanceDateTimePicker.pickTime(
      context,
      title: '공연',
      initial: _startTime,
    );
    if (!mounted) return;
    _unfocusAll();
    if (value == null) return;

    if (_startDate != null) {
      final combined = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        value.hour,
        value.minute,
      );
      if (combined.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('현재 시간 이후로 선택해주세요.')));
        return;
      }
    }

    setState(() {
      _startTime = value;
      _startTimeText.text =
          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _selectBookingCloseDate() async {
    _unfocusAll();
    final value = await PerformanceDateTimePicker.pickDate(
      context,
      title: '예매 마감',
      initial: _bookingCloseDate,
    );
    if (!mounted) return;
    _unfocusAll();
    if (value == null) return;

    final today = DateUtils.dateOnly(DateTime.now());
    if (DateUtils.dateOnly(value).isBefore(today)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('과거 날짜는 선택할 수 없습니다.')));
      return;
    }

    setState(() {
      _bookingCloseDate = value;
      _bookingCloseDateText.text =
          '${value.year}. ${value.month.toString().padLeft(2, '0')}. ${value.day.toString().padLeft(2, '0')}.';
    });
  }

  Future<void> _selectBookingCloseTime() async {
    _unfocusAll();
    final value = await PerformanceDateTimePicker.pickTime(
      context,
      title: '예매 마감',
      initial: _bookingCloseTime,
    );
    if (!mounted) return;
    _unfocusAll();
    if (value == null) return;

    if (_bookingCloseDate != null) {
      final combined = DateTime(
        _bookingCloseDate!.year,
        _bookingCloseDate!.month,
        _bookingCloseDate!.day,
        value.hour,
        value.minute,
      );
      if (combined.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('현재 시간 이후로 선택해주세요.')));
        return;
      }
    }

    setState(() {
      _bookingCloseTime = value;
      _bookingCloseTimeText.text =
          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _selectLocation() async {
    _unfocusAll();
    final location = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) =>
            const LocationSearchPage(returnRegisteredLocationOnSelect: true),
      ),
    );
    if (!mounted) return;
    _unfocusAll();
    if (location == null) return;
    setState(() {
      _location = location;
      _locationText.text = location.locationName ?? location.roadAddress ?? '';
    });
  }

  Future<void> _pickPoster() async {
    _unfocusAll();
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (!mounted) return;
    _unfocusAll();
    if (file == null) return;
    setState(() {
      _poster = file;
      _existingPosterUrl = null;
      _isPosterOverlayActive = false;
    });
  }

  void _removePoster() {
    setState(() {
      _poster = null;
      _existingPosterUrl = null;
      _isPosterOverlayActive = false;
    });
  }

  void _toggleTicket(PerformanceTicketType type) {
    setState(() {
      if (type == PerformanceTicketType.free ||
          type == PerformanceTicketType.general) {
        final wasSelected = _ticketTypes.contains(type);
        _ticketTypes.clear();
        if (!wasSelected) _ticketTypes.add(type);
      } else {
        _ticketTypes.remove(PerformanceTicketType.free);
        _ticketTypes.remove(PerformanceTicketType.general);
        if (!_ticketTypes.add(type)) _ticketTypes.remove(type);
      }
      if (!_usesBooking) {
        _bookingCloseDate = null;
        _bookingCloseTime = null;
        _bookingCloseDateText.clear();
        _bookingCloseTimeText.clear();
      }
    });
  }

  Future<void> _goNext() async {
    _unfocusAll();

    if (!_isFormValid) {
      return;
    }

    final information = PerformanceInformation(
      title: _title.text.trim(),
      startsAt: _startsAt!,
      location: _location!,
      introduction: _introduction.text.trim(),
      poster: _poster,
      ticketTypes: Set<PerformanceTicketType>.unmodifiable(_ticketTypes),
      ticketPrices: {
        for (final type in _ticketTypes)
          if (type != PerformanceTicketType.free)
            type: _prices[type]!.text.trim(),
      },
      bookingClosesAt: _usesBooking ? _bookingClosesAt : null,
      bookingUrl: _bookingUrl.text.trim(),
      hostName: _hostName.text.trim(),
      hostContactType: _hostType,
      hostContact: _hostContact.text.trim(),
    );

    final returnedDraft = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PerformanceDetailInformationPage(
          information: information,
          editTarget: widget.editTarget,
          existingPosterUrl: _existingPosterUrl,
          initialDraft: _step2Draft,
          initialStep3Draft: _step3Draft,
        ),
      ),
    );

    if (!mounted) return;
    _unfocusAll();

    if (returnedDraft is Map<String, dynamic>) {
      setState(() {
        _step2Draft = returnedDraft['step2'] as Map<String, dynamic>?;
        _step3Draft = returnedDraft['step3'] as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPoster =
        _poster != null ||
        (_existingPosterUrl != null && _existingPosterUrl!.isNotEmpty);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleClose();
      },
      child: GestureDetector(
        onTap: _unfocusAll,
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          backgroundColor: context.grays.white,
          appBar: AppTopAppBar.closeOnly(onClosePressed: _handleClose),
          body: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        const PerformanceProgressBar(step: 1),
                        const SizedBox(height: AppSpacing.x20),
                        AppTextField(
                          label: '공연 이름',
                          requiredMark: true,
                          controller: _title,
                          hintText: '공연 이름',
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: '공연 날짜',
                                requiredMark: true,
                                controller: _startDateText,
                                hintText: '공연 날짜',
                                readOnly: true,
                                onTap: _selectStartDate,
                                suffixIcon: SvgPicture.asset(
                                  'assets/icons/performance/calendar.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    context.grays.gray5,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x12),
                            Expanded(
                              child: AppTextField(
                                label: '공연 시간',
                                requiredMark: true,
                                controller: _startTimeText,
                                hintText: '공연 시간',
                                readOnly: true,
                                onTap: _selectStartTime,
                                suffixIcon: SvgPicture.asset(
                                  'assets/icons/performance/clock.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    context.grays.gray5,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        AppTextField(
                          label: '공연 장소',
                          requiredMark: true,
                          hintText: '공연 장소를 검색하세요.',
                          controller: _locationText,
                          readOnly: true,
                          onTap: _selectLocation,
                          suffixIcon: const Icon(Icons.search),
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        Text(
                          '공연 포스터 등록',
                          style: FontStyles.med15.copyWith(
                            color: context.grays.black,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        if (hasPoster) ...[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _unfocusAll();
                              setState(() {
                                _isPosterOverlayActive =
                                    !_isPosterOverlayActive;
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 165 / 210,
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.center,
                                  children: [
                                    if (_poster != null)
                                      Image.file(
                                        File(_poster!.path),
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      Image.network(
                                        _existingPosterUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: context.grays.gray8,
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    if (_isPosterOverlayActive) ...[
                                      Positioned.fill(
                                        child: Container(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: GestureDetector(
                                          onTap: _removePoster,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: context.grays.gray3,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              'assets/icons/team/delete2.svg',
                                              width: 26,
                                              height: 26,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x12),
                        ] else ...[
                          AppUploadButton(
                            text: '공연 포스터 등록하기',
                            onPressed: _pickPoster,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.x20),
                        AppTextArea(
                          label: '공연 소개',
                          requiredMark: true,
                          hintText: '공연 소개를 입력하세요.',
                          controller: _introduction,
                          maxLength: 200,
                          fieldHeight: 140,
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        PerformanceTicketSelector(
                          selectedTypes: _ticketTypes,
                          priceControllers: _prices,
                          onToggle: _toggleTicket,
                          onPriceChanged: () => setState(() {}),
                        ),
                        if (_usesBooking) ...[
                          const SizedBox(height: AppSpacing.x20),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: '사전 예매 마감 날짜',
                                  requiredMark: true,
                                  controller: _bookingCloseDateText,
                                  hintText: '예매 마감 날짜',
                                  readOnly: true,
                                  onTap: _selectBookingCloseDate,
                                  suffixIcon: SvgPicture.asset(
                                    'assets/icons/performance/calendar.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      context.grays.gray5,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x12),
                              Expanded(
                                child: AppTextField(
                                  label: '예매 마감 시간',
                                  requiredMark: true,
                                  controller: _bookingCloseTimeText,
                                  hintText: '마감 시간',
                                  readOnly: true,
                                  onTap: _selectBookingCloseTime,
                                  suffixIcon: SvgPicture.asset(
                                    'assets/icons/performance/clock.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      context.grays.gray5,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.x20),
                        AppTextField(
                          label: '예매 링크',
                          requiredMark: _usesBooking,
                          hintText: '예매 링크',
                          controller: _bookingUrl,
                        ),
                        const SizedBox(height: AppSpacing.x20),
                        AppTextField(
                          label: '호스트 정보',
                          requiredMark: true,
                          hintText: '이름',
                          controller: _hostName,
                        ),
                        const SizedBox(height: AppSpacing.x12),
                        Wrap(
                          spacing: AppSpacing.x8,
                          children: [
                            AppToggle(
                              text: '연락처',
                              isSelected:
                                  _hostType == PerformanceHostContactType.phone,
                              onChanged: (_) => setState(() {
                                _hostType = PerformanceHostContactType.phone;
                                _hostContact.clear();
                              }),
                            ),
                            AppToggle(
                              text: '링크',
                              isSelected:
                                  _hostType == PerformanceHostContactType.link,
                              onChanged: (_) => setState(() {
                                _hostType = PerformanceHostContactType.link;
                                _hostContact.clear();
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x12),
                        AppTextField(
                          controller: _hostContact,
                          hintText:
                              _hostType == PerformanceHostContactType.phone
                              ? '연락처'
                              : '링크',
                        ),
                        const SizedBox(height: AppSpacing.x20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                    child: AppButton(
                      text: '다음',
                      onPressed: _isFormValid ? _goNext : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
