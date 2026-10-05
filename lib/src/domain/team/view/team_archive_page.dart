import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/etc/view/location_search_page.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';

class TeamArchivePage extends ConsumerStatefulWidget {
  const TeamArchivePage({super.key});

  @override
  ConsumerState<TeamArchivePage> createState() => _TeamArchivePageState();
}

class _TeamArchivePageState extends ConsumerState<TeamArchivePage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedLocationId;
  bool _isSubmitting = false;

  final List<File> _selectedImages = [];
  final Set<int> _activeOverlayIndices = {};
  final ImagePicker _picker = ImagePicker();

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        _selectedLocationId != null &&
        _descriptionController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  void _navigateToArchiveList() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TeamArchiveListPage()),
      (route) => route.isFirst,
    );
  }

  String _displayLocationName(LocationData location) {
    final name = location.locationName?.trim();
    return name == null || name.isEmpty ? '장소 ID ${location.locationId}' : name;
  }

  Future<void> _openLocationSelector() async {
    FocusScope.of(context).unfocus();

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
    });
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 85);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (final file in pickedFiles) {
          _selectedImages.add(File(file.path));
        }
        _activeOverlayIndices.clear();
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _activeOverlayIndices.clear();
    });
  }

  // 💡 placeName 제거 및 파라미터 규격 동기화
  Future<void> _handleSubmit() async {
    if (!_canSubmit) return;

    setState(() {
      _isSubmitting = true;
    });

    final success = await ref
        .read(teamArchiveProvider.notifier)
        .createArchive(
          title: _nameController.text.trim(),
          locationId: _selectedLocationId!,
          description: _descriptionController.text.trim(),
          images: _selectedImages,
        );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('연습실 기록이 성공적으로 등록되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
      _navigateToArchiveList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기록 등록에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () async {
          final confirmed = await AppPopup.show(
            context,
            title: '작성을 중단하시겠습니까?',
            content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
            warningType: WarningType.circle,
            contentType: ContentType.small,
            buttonNum: ButtonNum.two,
            buttonSymmetric: ButtonSymmetric.horizontal,
            confirmText: '확인',
            cancelText: '취소',
          );

          if (!context.mounted) return;

          if (confirmed == true) {
            Navigator.of(context).pop();
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
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
                      // 1. 합주실/연습실 이름 (필수)
                      AppTextField(
                        label: '합주실/연습실 이름',
                        requiredMark: true,
                        hintText: '합주실/연습실 이름',
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 2. 장소 (필수)
                      AppTextField(
                        label: '장소',
                        requiredMark: true,
                        hintText: '모임 장소를 검색하세요.',
                        controller: _locationController,
                        readOnly: true,
                        onTap: _openLocationSelector,
                        suffixIcon: SvgPicture.asset(
                          'assets/icons/cal/search.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            context.grays.gray5,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 3. 일정 설명 (필수, 500자 제한)
                      AppTextArea(
                        label: '일정 설명',
                        requiredMark: true,
                        hintText: '모임에 어울리는 일정 설명을 작성해주세요.',
                        controller: _descriptionController,
                        maxLength: 500,
                        fieldHeight: 220,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 4. 사진 등록
                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      // 등록된 이미지 카드 목록
                      if (_selectedImages.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final imageFile = _selectedImages[index];
                            final isOverlayActive = _activeOverlayIndices
                                .contains(index);

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  if (isOverlayActive) {
                                    _activeOverlayIndices.remove(index);
                                  } else {
                                    _activeOverlayIndices.add(index);
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
                                        imageFile,
                                        width: double.infinity,
                                        height: 220,
                                        fit: BoxFit.cover,
                                      ),
                                      if (isOverlayActive) ...[
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _removeImage(index),
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

                      AppUploadButton(
                        text: '연습실/합주실 사진 등록하기',
                        onPressed: _pickImages,
                      ),

                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x24),

              // 5. 등록하기 버튼
              AppButton(
                text: _isSubmitting ? '등록 중...' : '등록하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: _canSubmit ? _handleSubmit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
