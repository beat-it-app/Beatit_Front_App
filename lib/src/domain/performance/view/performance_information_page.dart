import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_form_widgets.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_ticket_selector.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_ticket_information_popup.dart';
import 'package:beatit_front_app/src/domain/performance/widget/progress_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PerformanceInformationPage extends StatefulWidget {
  const PerformanceInformationPage({super.key, this.onSubmit});

  /// 공연 API가 준비되면 부모 화면에서 실제 등록 콜백을 전달한다.
  final ValueChanged<PerformanceCreateData>? onSubmit;

  @override
  State<PerformanceInformationPage> createState() =>
      _PerformanceInformationPageState();
}

class _PerformanceInformationPageState
    extends State<PerformanceInformationPage> {
  final _title = TextEditingController();
  final _startsAtText = TextEditingController();
  final _locationText = TextEditingController();
  final _introduction = TextEditingController();
  final _bookingClosesAtText = TextEditingController();
  final _bookingUrl = TextEditingController();
  final _hostName = TextEditingController();
  final _hostContact = TextEditingController();
  final _prices = <PerformanceTicketType, TextEditingController>{
    for (final type in PerformanceTicketType.values)
      if (type != PerformanceTicketType.free) type: TextEditingController(),
  };

  final Set<PerformanceTicketType> _ticketTypes = {};
  PerformanceHostContactType _hostType = PerformanceHostContactType.phone;
  DateTime? _startsAt;
  DateTime? _bookingClosesAt;
  LocationData? _location;
  XFile? _poster;
  bool _validate = false;

  bool get _usesBooking =>
      _ticketTypes.contains(PerformanceTicketType.advance) ||
      _ticketTypes.contains(PerformanceTicketType.general);

  bool get _pricesValid => _ticketTypes.every(
    (type) =>
        type == PerformanceTicketType.free ||
        int.tryParse(_prices[type]!.text.trim()) != null &&
            int.parse(_prices[type]!.text.trim()) >= 0,
  );

  String? _error(bool invalid, String message) =>
      _validate && invalid ? message : null;

  @override
  void dispose() {
    for (final controller in [
      _title,
      _startsAtText,
      _locationText,
      _introduction,
      _bookingClosesAtText,
      _bookingUrl,
      _hostName,
      _hostContact,
      ..._prices.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
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
      _startsAtText.text = PerformanceDateTimePicker.format(value);
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
      _bookingClosesAtText.text = PerformanceDateTimePicker.format(value);
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

  Future<void> _selectPoster() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() => _poster = file); // 단일 이미지: 재선택 시 교체
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
        _bookingClosesAtText.clear();
      }
    });
  }

  void _goNext() {
    FocusScope.of(context).unfocus();
    setState(() => _validate = true);
    if (_title.text.trim().isEmpty ||
        _startsAt == null ||
        _location == null ||
        _poster == null ||
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
          onSubmit: widget.onSubmit,
          onDiscard: () {
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    FocusScope.of(context).unfocus();
    final confirmed = await AppPopup.show(
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
    return confirmed == true;
  }

  Future<void> _handleClose() async {
    if (await _confirmDiscard() && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmDiscard,
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
                        errorText: _error(
                          _title.text.trim().isEmpty,
                          '공연 이름을 입력해주세요.',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      const PerformanceFormLabel('공연 시간', requiredMark: true),
                      PerformanceDateTimeField(
                        hintText: '공연 시간을 설정하세요.',
                        controller: _startsAtText,
                        onTap: _selectStartsAt,
                        errorText: _error(_startsAt == null, '공연 시간을 설정해주세요.'),
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      AppTextField(
                        label: '공연 장소',
                        requiredMark: true,
                        hintText: '공연 장소를 검색하세요.',
                        controller: _locationText,
                        readOnly: true,
                        onTap: _selectLocation,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/etc/search.svg',
                          colorFilter: ColorFilter.mode(
                            context.grays.gray5,
                            BlendMode.srcIn,
                          ),
                          height: 20,
                        ),
                        errorText: _error(_location == null, '공연 장소를 선택해주세요.'),
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      const PerformanceFormLabel(
                        '공연 포스터 등록',
                        requiredMark: true,
                      ),
                      PerformanceImagePicker(
                        images: _poster == null
                            ? const <XFile>[]
                            : <XFile>[_poster!],
                        maxImages: 1,
                        onAdd: _selectPoster,
                        onRemove: (_) => setState(() => _poster = null),
                      ),
                      if (_validate && _poster == null) ...[
                        const SizedBox(height: AppSpacing.x8),
                        Text(
                          '사진을 등록해주세요.',
                          style: FontStyles.med12.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x20),
                      AppTextArea(
                        label: '공연 소개',
                        hintText: '공연 소개를 입력하세요.',
                        controller: _introduction,
                        maxLength: 200,
                        fieldHeight: 200,
                      ),
                      const SizedBox(height: AppSpacing.x20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const PerformanceFormLabel(
                            '티켓 가격',
                            requiredMark: true,
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              tooltip: '일반 예매 안내',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () =>
                                  PerformanceTicketInformationPopup.show(
                                    context,
                                  ),
                              icon: SvgPicture.asset(
                                'assets/icons/performance/information.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      PerformanceTicketSelector(
                        selectedTypes: _ticketTypes,
                        priceControllers: _prices,
                        onToggle: _toggleTicket,
                        onPriceChanged: () => setState(() {}),
                        errorText: _error(
                          _ticketTypes.isEmpty || !_pricesValid,
                          '예매 유형을 선택하고 가격을 입력해주세요.',
                        ),
                      ),
                      if (_usesBooking) ...[
                        const SizedBox(height: AppSpacing.x20),
                        const PerformanceFormLabel(
                          '예매 마감 시간',
                          requiredMark: true,
                        ),
                        PerformanceDateTimeField(
                          controller: _bookingClosesAtText,
                          hintText: '예매 마감 시간을 설정하세요.',
                          onTap: _selectBookingDeadline,
                          errorText: _error(
                            _bookingClosesAt == null ||
                                (_startsAt != null &&
                                    !_bookingClosesAt!.isBefore(_startsAt!)),
                            '공연 시작 전의 예매 마감 시간을 선택해주세요.',
                          ),
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
                        errorText: _error(
                          _hostName.text.trim().isEmpty,
                          '호스트 이름을 입력해주세요.',
                        ),
                        onChanged: (_) => setState(() {}),
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
                        keyboardType:
                            _hostType == PerformanceHostContactType.phone
                            ? TextInputType.phone
                            : TextInputType.url,
                        errorText: _error(
                          _hostContact.text.trim().isEmpty,
                          _hostType == PerformanceHostContactType.phone
                              ? '연락처를 입력해주세요.'
                              : '링크를 입력해주세요.',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x20),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
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
