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
import 'package:beatit_front_app/src/core/widgets/bottomsheets/app_time_bottomsheet.dart';
import 'package:beatit_front_app/src/domain/team/api/team_detail_api.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_detail_provider.dart';

class TeamUpdatePage extends ConsumerStatefulWidget {
  const TeamUpdatePage({super.key});

  @override
  ConsumerState<TeamUpdatePage> createState() => _TeamUpdatePageState();
}

class _TeamUpdatePageState extends ConsumerState<TeamUpdatePage> {
  final teamNameController = TextEditingController();
  final teamDescriptionController = TextEditingController();
  final teamDateController = TextEditingController();

  final List<TextEditingController> _linkControllers = [];

  // 초기 원본 데이터 보관 변수 (수정 여부 비교용)
  String _initialName = '';
  String _initialDesc = '';
  String _initialDate = '';
  List<String> _initialLinks = [];
  String? _initialImageUrl;

  // 현재 이미지 상태
  String? _existingImageUrl;
  File? _newSelectedImage;
  bool _isDeleteOverlayVisible = false;
  final ImagePicker _picker = ImagePicker();

  bool _isInitialized = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFormData();
    });
  }

  void _initFormData() {
    if (_isInitialized) return;

    final teamDetail = ref.read(teamDetailProvider).teamDetail;
    if (teamDetail != null) {
      _initialName = teamDetail.teamName;
      _initialDesc = teamDetail.description ?? '';

      if (teamDetail.establishedOn != null &&
          teamDetail.establishedOn!.trim().isNotEmpty) {
        final raw = teamDetail.establishedOn!.trim();
        _initialDate = raw.length >= 10 ? raw.substring(0, 10) : raw;
      }

      _initialImageUrl = teamDetail.teamImageUrl;

      if (teamDetail.links.isNotEmpty) {
        _initialLinks = teamDetail.links
            .map((link) => link.linkUrl.trim())
            .where((url) => url.isNotEmpty)
            .toList();
      }

      // 컨트롤러 세팅
      teamNameController.text = _initialName;
      teamDescriptionController.text = _initialDesc;
      teamDateController.text = _initialDate;
      _existingImageUrl = _initialImageUrl;

      if (_initialLinks.isNotEmpty) {
        for (final url in _initialLinks) {
          _linkControllers.add(TextEditingController(text: url));
        }
      } else {
        _linkControllers.add(TextEditingController());
      }

      _isInitialized = true;
      setState(() {});
    }
  }

  // 갤러리 이미지 선택
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _newSelectedImage = File(pickedFile.path);
        _existingImageUrl = null;
        _isDeleteOverlayVisible = false;
      });
    }
  }

  bool get _isTeamNameValid {
    final text = teamNameController.text.trim();
    return text.isNotEmpty && text.length <= 10;
  }

  String? get _teamNameErrorText {
    if (teamNameController.text.isEmpty) return null;
    if (!_isTeamNameValid) return '팀 이름은 한 글자 이상 10글자 이하로 작성해주세요.';
    return null;
  }

  void _addLinkField() {
    setState(() {
      _linkControllers.add(TextEditingController());
    });
  }

  void _removeLinkField(int index) {
    setState(() {
      _linkControllers[index].dispose();
      _linkControllers.removeAt(index);
    });
  }

  // 💡 초기값 대비 하나라도 수정된 사항이 있는지 검사
  bool get _hasChanges {
    if (teamNameController.text.trim() != _initialName) return true;
    if (teamDescriptionController.text.trim() != _initialDesc) return true;
    if (teamDateController.text.trim() != _initialDate) return true;
    if (_newSelectedImage != null) return true;
    if (_existingImageUrl != _initialImageUrl) return true;

    final currentLinks = _linkControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (currentLinks.length != _initialLinks.length) return true;
    for (int i = 0; i < currentLinks.length; i++) {
      if (currentLinks[i] != _initialLinks[i]) return true;
    }

    return false;
  }

  // 💡 변경점이 있고 필수값이 유효할 때만 제출 가능
  bool get _canSubmit {
    return _isTeamNameValid &&
        teamDescriptionController.text.trim().isNotEmpty &&
        _hasChanges &&
        !_isSubmitting;
  }

  String _detectPlatformCode(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('instagram.com')) return 'INSTAGRAM';
    if (lower.contains('youtube.com') || lower.contains('youtu.be'))
      return 'YOUTUBE';
    return 'CUSTOM';
  }

  Future<void> _submitUpdate() async {
    if (!_canSubmit) return;

    setState(() {
      _isSubmitting = true;
    });

    final currentLinks = _linkControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final bool isLinksChanged =
        currentLinks.length != _initialLinks.length ||
        !currentLinks.every((url) => _initialLinks.contains(url));

    List<Map<String, String>>? linksPayload;
    if (isLinksChanged) {
      linksPayload = currentLinks
          .map(
            (url) => {'platformCode': _detectPlatformCode(url), 'linkUrl': url},
          )
          .toList();
    }

    final String newName = teamNameController.text.trim();
    final String? newDesc =
        teamDescriptionController.text.trim() != _initialDesc
        ? teamDescriptionController.text.trim()
        : null;
    final String? newDate =
        teamDateController.text.trim() != _initialDate &&
            teamDateController.text.trim().isNotEmpty
        ? teamDateController.text.trim()
        : null;

    try {
      await ref
          .read(teamDetailProvider.notifier)
          .updateTeamDetail(
            teamName: newName,
            description: newDesc,
            teamType: null,
            establishedOn: newDate,
            teamImageFile: _newSelectedImage,
            links: linksPayload,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('팀 정보가 성공적으로 수정되었습니다.'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      String errorMessage = '팀 정보 수정에 실패했습니다.';
      if (e is TeamDetailApiException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
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
    teamNameController.dispose();
    teamDescriptionController.dispose();
    teamDateController.dispose();
    for (var controller in _linkControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool hasImage =
        _newSelectedImage != null ||
        (_existingImageUrl != null && _existingImageUrl!.trim().isNotEmpty);

    return Scaffold(
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () async {
          // 수정사항이 없으면 확인 팝업 없이 바로 닫기
          if (!_hasChanges) {
            Navigator.of(context).pop();
            return;
          }

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
                      // 1. 팀 이름
                      AppTextField(
                        hintText: '팀 이름 (10글자 이내)',
                        requiredMark: true,
                        label: '팀 이름',
                        controller: teamNameController,
                        errorText: _teamNameErrorText,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 2. 팀 개설일
                      AppTextField(
                        label: '팀 개설일',
                        requiredMark: false,
                        hintText: '날짜를 선택해주세요',
                        controller: teamDateController,
                        readOnly: true,
                        onTap: () async {
                          final selectedDate =
                              await AppTimeBottomSheet.showDatePicker(
                                context,
                                title: '팀 개설일 선택',
                                initialDate: DateTime.now(),
                                maxDate: DateTime.now(),
                              );

                          if (selectedDate != null) {
                            setState(() {
                              teamDateController.text =
                                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        suffixIcon: Image.asset(
                          'assets/icons/navigation/calendar_gray.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      // 3. 사진 등록 라벨
                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      // 4. 단일 사진 및 삭제 딤 오버레이
                      if (!hasImage) ...[
                        AppUploadButton(
                          text: '팀 사진 등록하기',
                          onPressed: _pickImage,
                        ),
                      ] else ...[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _isDeleteOverlayVisible =
                                  !_isDeleteOverlayVisible;
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_newSelectedImage != null)
                                  Image.file(
                                    _newSelectedImage!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                                else if (_existingImageUrl!.startsWith('http'))
                                  Image.network(
                                    _existingImageUrl!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/team/team_profile_example.png',
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                else
                                  Image.asset(
                                    _existingImageUrl!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),

                                if (_isDeleteOverlayVisible) ...[
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _newSelectedImage = null;
                                        _existingImageUrl = null;
                                        _isDeleteOverlayVisible = false;
                                      });
                                    },
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
                      ],

                      const SizedBox(height: AppSpacing.x20),

                      // 5. 팀 소개
                      AppTextArea(
                        label: '팀 소개',
                        requiredMark: true,
                        hintText: '모임에 어울리는 팀 소개글을 작성해주세요.',
                        controller: teamDescriptionController,
                        maxLength: 200,
                        fieldHeight: 196,
                        onChanged: (_) => setState(() {}),
                      ),

                      // 6. 링크 등록
                      Text(
                        '링크 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _linkControllers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.x8),
                        itemBuilder: (context, index) {
                          return _LinkInputField(
                            controller: _linkControllers[index],
                            onDelete: () => _removeLinkField(index),
                            onChanged: (_) => setState(() {}),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.x12),

                      Center(
                        child: GestureDetector(
                          onTap: _addLinkField,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F2F7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF8E8E93),
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              // 7. 저장하기 버튼 (수정 사항이 없을 땐 비활성화)
              AppButton(
                text: _isSubmitting ? '저장 중...' : '저장하기',
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

class _LinkInputField extends StatelessWidget {
  const _LinkInputField({
    required this.controller,
    required this.onDelete,
    this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onDelete;
  final ValueChanged<String>? onChanged;

  String _getIconPath(String url) {
    final lower = url.trim().toLowerCase();
    if (lower.contains('instagram.com')) {
      return 'assets/icons/team/instagram.svg';
    } else if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
      return 'assets/icons/team/youtube.svg';
    }
    return 'assets/icons/team/link.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final iconPath = _getIconPath(controller.text);
            return Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: context.grays.gray8,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    context.grays.gray6,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: context.grays.gray8,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: FontStyles.reg18.copyWith(color: context.grays.gray1),
                decoration: InputDecoration(
                  hintText: '링크 붙여넣기',
                  border: InputBorder.none,
                  hintStyle: FontStyles.reg18.copyWith(
                    color: context.grays.gray5,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onDelete,
          child: SvgPicture.asset(
            'assets/icons/etc/cancel.svg',
            width: 16,
            height: 16,
          ),
        ),
      ],
    );
  }
}
