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
import 'package:beatit_front_app/src/domain/team/api/team_archive_api.dart';
import 'package:beatit_front_app/src/domain/team/model/team_archive_detail_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';

class TeamArchiveUpdatePage extends ConsumerStatefulWidget {
  final TeamArchiveDetailModel detail;

  const TeamArchiveUpdatePage({super.key, required this.detail});

  @override
  ConsumerState<TeamArchiveUpdatePage> createState() =>
      _TeamArchiveUpdatePageState();
}

class _TeamArchiveUpdatePageState extends ConsumerState<TeamArchiveUpdatePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  late int _selectedLocationId;
  bool _isSubmitting = false;

  // 기존 등록된 사진 (URL) 및 삭제 관리
  late List<String> _existingImages;
  final Set<int> _activeExistingOverlayIndices = {};

  // 새로 추가할 사진 (File) 및 삭제 관리
  final List<File> _newImages = [];
  final Set<int> _activeNewOverlayIndices = {};

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.detail.title);
    _locationController = TextEditingController(
      text: widget.detail.roadAddress ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.detail.description,
    );
    _selectedLocationId = widget.detail.locationId;
    _existingImages = List<String>.from(widget.detail.archiveImageUrls);
  }

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        !_isSubmitting;
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
          _newImages.add(File(file.path));
        }
        _activeNewOverlayIndices.clear();
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
      _activeExistingOverlayIndices.clear();
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
      _activeNewOverlayIndices.clear();
    });
  }

  Future<void> _submitUpdate() async {
    if (!_canSubmit) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final api = ref.read(teamArchiveApiProvider);
      await api.updateArchive(
        archiveId: widget.detail.archiveId,
        title: _nameController.text.trim(),
        locationId: _selectedLocationId,
        description: _descriptionController.text.trim(),
        newImages: _newImages,
      );

      ref.read(teamArchiveProvider.notifier).fetchArchives();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('수정이 완료되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('수정 실패: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
            content: '중단 시, 수정된 내용은\n저장되지 않습니다.',
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

                      // 2. 장소 (필수, 검색 페이지 연동)
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

                      // 4. 사진 등록 영역
                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      // 4-1. 기존 등록된 사진 목록 (딤드 및 삭제 가능)
                      if (_existingImages.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _existingImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final imageUrl = _existingImages[index];
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
                                        imageUrl,
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
                                            color: Colors.white.withOpacity(
                                              0.5,
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

                      // 4-2. 새로 추가한 사진 목록 (딤드 및 삭제 가능)
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

                      // 사진 등록/추가 버튼
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

              // 5. 저장하기 버튼
              AppButton(
                text: _isSubmitting ? '수정 중...' : '저장하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: _canSubmit ? _submitUpdate : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
