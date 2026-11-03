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
  DateTime? _startsAt;
  DateTime? _bookingClosesAt;
  LocationData? _location;
  XFile? _poster;
  String? _existingPosterUrl;
  bool _isPosterOverlayActive = false;
  bool _validate = false;

  final ImagePicker _picker = ImagePicker();

  bool get _isEditMode => widget.editTarget != null;

  bool get _usesBooking =>
      _ticketTypes.contains(PerformanceTicketType.advance) ||
      _ticketTypes.contains(PerformanceTicketType.general);

  bool get _pricesValid => _ticketTypes.every(
    (type) =>
        type == PerformanceTicketType.free ||
        (int.tryParse(_prices[type]!.text.trim()) != null &&
            int.parse(_prices[type]!.text.trim()) >= 0),
  );

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _prefillData(widget.editTarget!);
    }
  }

  void _prefillData(PerformanceDetailModel target) {
    final detail = target.toDetailData();

    _title.text = detail.title;
    _introduction.text = detail.introduction;

    _startsAt = detail.startsAt;
    _startDateText.text =
        '${_startsAt!.year}. ${_startsAt!.month.toString().padLeft(2, '0')}. ${_startsAt!.day.toString().padLeft(2, '0')}.';
    _startTimeText.text =
        '${_startsAt!.hour.toString().padLeft(2, '0')}:${_startsAt!.minute.toString().padLeft(2, '0')}';

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
      _bookingClosesAt = detail.bookingClosesAt;
      _bookingCloseDateText.text =
          '${_bookingClosesAt!.year}. ${_bookingClosesAt!.month.toString().padLeft(2, '0')}. ${_bookingClosesAt!.day.toString().padLeft(2, '0')}.';
      _bookingCloseTimeText.text =
          '${_bookingClosesAt!.hour.toString().padLeft(2, '0')}:${_bookingClosesAt!.minute.toString().padLeft(2, '0')}';
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

  // 💡 작성 중단 확인 팝업
  Future<void> _handleClose() async {
    FocusScope.of(context).unfocus();

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

    if (confirmed == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectStartsAt() async {
    final value = await PerformanceDateTimePicker.pick(
      context,
      title: '공연',
      initial: _startsAt,
    );
    if (value == null || !mounted) return;
    setState(() {
      _startsAt = value;
      _startDateText.text =
          '${value.year}. ${value.month.toString().padLeft(2, '0')}. ${value.day.toString().padLeft(2, '0')}.';
      _startTimeText.text =
          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _selectBookingDeadline() async {
    final value = await PerformanceDateTimePicker.pick(
      context,
      title: '예매 마감',
      initial: _bookingClosesAt,
    );
    if (value == null || !mounted) return;
    setState(() {
      _bookingClosesAt = value;
      _bookingCloseDateText.text =
          '${value.year}. ${value.month.toString().padLeft(2, '0')}. ${value.day.toString().padLeft(2, '0')}.';
      _bookingCloseTimeText.text =
          '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _selectLocation() async {
    final location = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) =>
            const LocationSearchPage(returnRegisteredLocationOnSelect: true),
      ),
    );
    if (location == null || !mounted) return;
    setState(() {
      _location = location;
      _locationText.text = location.locationName ?? location.roadAddress ?? '';
    });
  }

  Future<void> _pickPoster() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
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
        _bookingClosesAt = null;
        _bookingCloseDateText.clear();
        _bookingCloseTimeText.clear();
      }
    });
  }

  void _goNext() {
    FocusScope.of(context).unfocus();
    setState(() => _validate = true);

    if (_title.text.trim().isEmpty ||
        _startsAt == null ||
        _location == null ||
        _ticketTypes.isEmpty ||
        !_pricesValid ||
        (_usesBooking &&
            (_bookingClosesAt == null ||
                !_bookingClosesAt!.isBefore(_startsAt!))) ||
        _hostName.text.trim().isEmpty ||
        _hostContact.text.trim().isEmpty) {
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

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PerformanceDetailInformationPage(
          information: information,
          editTarget: widget.editTarget,
          existingPosterUrl: _existingPosterUrl,
        ),
      ),
    );
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
        _handleClose(); // 기기 자체 뒤로가기 제스처/버튼 시에도 팝업 노출
      },
      child: Scaffold(
        backgroundColor: context.grays.white,
        appBar: AppTopAppBar.backClose(
          onBackPressed: _handleClose, // 왼쪽 뒤로가기 클릭 시 팝업
          onClosePressed: _handleClose, // 오른쪽 X 닫기 클릭 시 팝업
        ),
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
                              onTap: _selectStartsAt,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: context.grays.gray5,
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
                              onTap: _selectStartsAt,
                              suffixIcon: Icon(
                                Icons.access_time,
                                size: 20,
                                color: context.grays.gray5,
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
                            setState(() {
                              _isPosterOverlayActive = !_isPosterOverlayActive;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: double.infinity,
                              height: 220,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (_poster != null)
                                    Image.file(
                                      File(_poster!.path),
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Image.network(
                                      _existingPosterUrl!,
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: context.grays.gray8,
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  if (_isPosterOverlayActive) ...[
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    GestureDetector(
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
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
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
                                onTap: _selectBookingDeadline,
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: context.grays.gray5,
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
                                onTap: _selectBookingDeadline,
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: context.grays.gray5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x20),
                      AppTextField(
                        label: '예매 링크',
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
                        hintText: _hostType == PerformanceHostContactType.phone
                            ? '연락처'
                            : '링크',
                      ),
                      const SizedBox(height: AppSpacing.x20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                  child: AppButton(text: '다음', onPressed: _goNext),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
