import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_form_widgets.dart';
import 'package:beatit_front_app/src/domain/performance/widget/progress_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class PerformanceDetailInformationPage extends StatefulWidget {
  const PerformanceDetailInformationPage({
    super.key,
    required this.information,
    this.initialData,
    this.onSubmit,
    this.onDiscard,
  });

  final PerformanceInformation information;
  final PerformanceCreateData? initialData;
  final ValueChanged<PerformanceCreateData>? onSubmit;
  final VoidCallback? onDiscard;

  @override
  State<PerformanceDetailInformationPage> createState() =>
      _PerformanceDetailInformationPageState();
}

class _PerformanceDetailInformationPageState
    extends State<PerformanceDetailInformationPage> {
  static const _maxImages = 10;
  final _description = TextEditingController();
  final List<XFile> _images = [];
  bool _hasNoDetails = false;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    final draft = widget.initialData;
    if (draft == null) return;
    _images.addAll(draft.detailImages.take(_maxImages));
    _description.text = draft.detailDescription;
    _hasNoDetails = draft.hasNoDetails;
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= _maxImages) return;
    final selected = await ImagePicker().pickMultiImage();
    if (!mounted || selected.isEmpty) return;
    final paths = _images.map((image) => image.path).toSet();
    final additions = selected
        .where((image) => paths.add(image.path))
        .take(_maxImages - _images.length)
        .toList();
    setState(() => _images.addAll(additions));
    if (selected.length > additions.length && mounted) {
      await AppPopup.show(
        context,
        title: '이미지 등록 안내',
        content: '이미지는 최대 10장까지 등록할 수 있습니다.',
        confirmText: '확인',
      );
    }
  }

  Future<void> _handleClose() async {
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
    if (!mounted || confirmed != true) return;
    Navigator.of(context).pop();
    widget.onDiscard?.call();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    setState(() => _validate = true);
    if (!_hasNoDetails && _description.text.trim().isEmpty) return;

    if (widget.onSubmit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('공연 등록 API가 아직 연결되지 않았습니다.')),
      );
      return;
    }
    widget.onSubmit!(
      PerformanceCreateData(
        information: widget.information,
        detailImages: List<XFile>.unmodifiable(_images),
        detailDescription: _hasNoDetails ? '' : _description.text.trim(),
        hasNoDetails: _hasNoDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      await _handleClose();
      return false;
    },
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
                    const PerformanceProgressBar(step: 2),
                    const SizedBox(height: AppSpacing.x20),
                    const PerformanceFormLabel('이미지 등록'),
                    PerformanceImagePicker(
                      images: _images,
                      maxImages: _maxImages,
                      onAdd: _pickImages,
                      onRemove: (index) =>
                          setState(() => _images.removeAt(index)),
                    ),
                    const SizedBox(height: AppSpacing.x20),
                    if (!_hasNoDetails) ...[
                      AppTextArea(
                        label: '상세 정보',
                        requiredMark: true,
                        hintText: '공연 상세 정보를 입력해주세요.',
                        controller: _description,
                        maxLength: 200,
                        fieldHeight: 200,
                        errorText: _validate && _description.text.trim().isEmpty
                            ? '상세 정보를 입력하거나 상세 정보 미제공을 선택해주세요.'
                            : null,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x12),
                    ],
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          setState(() => _hasNoDetails = !_hasNoDetails),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/check/check.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              _hasNoDetails
                                  ? context.brands.beatOrange1
                                  : context.grays.gray6,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x8),
                          Expanded(
                            child: Text(
                              '이 공연은 상세 정보를 제공하지 않습니다.',
                              style: FontStyles.semi14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x20),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x8),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                child: AppButton(text: '등록하기', onPressed: _submit),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
