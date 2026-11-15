// lib/src/domain/performance/view/performance_detail_information_page.dart

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
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_invitation_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/progress_bar_widget.dart';

class PerformanceDetailInformationPage extends StatefulWidget {
  const PerformanceDetailInformationPage({
    super.key,
    required this.information,
    this.editTarget,
    this.existingPosterUrl,
    this.initialDraft,
    this.initialStep3Draft,
  });

  final PerformanceInformation information;
  final PerformanceDetailModel? editTarget;
  final String? existingPosterUrl;
  final Map<String, dynamic>? initialDraft;
  final Map<String, dynamic>? initialStep3Draft;

  @override
  State<PerformanceDetailInformationPage> createState() =>
      _PerformanceDetailInformationPageState();
}

class _PerformanceDetailInformationPageState
    extends State<PerformanceDetailInformationPage> {
  static const _maxImages = 5;
  final _description = TextEditingController();

  List<PerformanceFile> _existingImages = [];
  final Set<int> _activeExistingOverlayIndices = {};
  List<int> _deletedImageIds = [];

  List<XFile> _newImages = [];
  final Set<int> _activeNewOverlayIndices = {};

  Map<String, dynamic>? _step3Draft;

  final ImagePicker _picker = ImagePicker();
  bool _hasNoDetails = false;

  bool get _isFormValid =>
      _hasNoDetails ||
      _description.text.trim().isNotEmpty ||
      _existingImages.isNotEmpty ||
      _newImages.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _step3Draft = widget.initialStep3Draft;

    if (widget.initialDraft != null) {
      final draft = widget.initialDraft!;
      _description.text = draft['description'] as String? ?? '';
      _hasNoDetails = draft['hasNoDetails'] as bool? ?? false;
      _existingImages = List<PerformanceFile>.from(
        draft['existingImages'] as List? ?? [],
      );
      _deletedImageIds = List<int>.from(
        draft['deletedImageIds'] as List? ?? [],
      );
      _newImages = List<XFile>.from(draft['newImages'] as List? ?? []);
    } else if (widget.editTarget != null) {
      final detail = widget.editTarget!.toDetailData();
      _description.text = detail.detailDescription;
      _existingImages = List.from(widget.editTarget!.detailImages);
      _hasNoDetails = (_description.text.isEmpty && _existingImages.isEmpty);
    }
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void _handleBackWithDraft() {
    FocusManager.instance.primaryFocus?.unfocus();

    final currentStep2Draft = <String, dynamic>{
      'description': _description.text,
      'hasNoDetails': _hasNoDetails,
      'existingImages': List<PerformanceFile>.from(_existingImages),
      'deletedImageIds': List<int>.from(_deletedImageIds),
      'newImages': List<XFile>.from(_newImages),
    };

    Navigator.of(
      context,
    ).pop(<String, dynamic>{'step2': currentStep2Draft, 'step3': _step3Draft});
  }

  Future<void> _handleCloseConfirmation() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final confirmed = await AppPopup.show(
      context,
      title: '작성을 중단하시겠습니까?',
      content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
      warningType: WarningType.circle,
      buttonNum: ButtonNum.two,
      confirmText: '나가기',
      cancelText: '계속 작성',
    );

    FocusManager.instance.primaryFocus?.unfocus();

    if (confirmed == true && mounted) {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    }
  }

  Future<void> _pickImages() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final currentCount = _existingImages.length + _newImages.length;
    if (currentCount >= _maxImages) return;

    final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);

    FocusManager.instance.primaryFocus?.unfocus();

    if (!mounted || pickedFiles.isEmpty) return;

    final additions = pickedFiles.take(_maxImages - currentCount).toList();
    setState(() {
      _newImages.addAll(additions);
      _activeNewOverlayIndices.clear();
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      final removed = _existingImages.removeAt(index);
      _deletedImageIds.add(removed.fileId);
      _activeExistingOverlayIndices.clear();
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
      _activeNewOverlayIndices.clear();
    });
  }

  Future<void> _goNext() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_isFormValid) return;

    final returnedStep3Draft = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PerformanceInvitationPage(
          step1: widget.information,
          detailImages: _newImages,
          detailDescription: _hasNoDetails ? '' : _description.text.trim(),
          hasNoDetails: _hasNoDetails,
          editTarget: widget.editTarget,
          retainDetailFileIds: _existingImages.map((e) => e.fileId).toList(),
          deleteDetailFileIds: _deletedImageIds,
          deletePosterImage:
              widget.editTarget != null &&
              widget.existingPosterUrl == null &&
              widget.information.poster == null,
          initialDraft: _step3Draft,
        ),
      ),
    );

    FocusManager.instance.primaryFocus?.unfocus();

    if (returnedStep3Draft is Map<String, dynamic> && mounted) {
      setState(() {
        _step3Draft = returnedStep3Draft;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = _existingImages.length + _newImages.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackWithDraft();
      },
      child: Scaffold(
        backgroundColor: context.grays.white,
        appBar: AppTopAppBar.backClose(
          onBackPressed: _handleBackWithDraft,
          onClosePressed: _handleCloseConfirmation,
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
                      const PerformanceProgressBar(step: 2),
                      const SizedBox(height: AppSpacing.x20),
                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: context.grays.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      if (_existingImages.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _existingImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final imageItem = _existingImages[index];
                            final isOverlayActive =
                                _activeExistingOverlayIndices.contains(index);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  if (isOverlayActive) {
                                    _activeExistingOverlayIndices.remove(index);
                                  } else {
                                    _activeExistingOverlayIndices.add(index);
                                  }
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
                                      Image.network(
                                        imageItem.cdnUrl,
                                        width: double.infinity,
                                        height: 220,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: context.grays.gray8,
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                      if (isOverlayActive) ...[
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _removeExistingImage(index),
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
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.x12),
                      ],
                      if (_newImages.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _newImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final imageFile = _newImages[index];
                            final isOverlayActive = _activeNewOverlayIndices
                                .contains(index);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  if (isOverlayActive) {
                                    _activeNewOverlayIndices.remove(index);
                                  } else {
                                    _activeNewOverlayIndices.add(index);
                                  }
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
                                      Image.file(
                                        File(imageFile.path),
                                        width: double.infinity,
                                        height: 220,
                                        fit: BoxFit.cover,
                                      ),
                                      if (isOverlayActive) ...[
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _removeNewImage(index),
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
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.x12),
                      ],
                      if (totalImages < _maxImages)
                        AppUploadButton(
                          text: '공연 상세 사진 등록하기',
                          onPressed: _pickImages,
                        ),
                      const SizedBox(height: AppSpacing.x20),
                      if (!_hasNoDetails) ...[
                        AppTextArea(
                          label: '상세 정보',
                          hintText: '공연 상세 정보를 입력해주세요.',
                          controller: _description,
                          maxLength: 1000,
                          fieldHeight: 240,
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
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                _hasNoDetails
                                    ? context.brands.beatOrange1
                                    : context.grays.gray6,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x8),
                            Text(
                              '이 공연은 상세 정보를 제공하지 않습니다.',
                              style: FontStyles.reg14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                          ],
                        ),
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
    );
  }
}
