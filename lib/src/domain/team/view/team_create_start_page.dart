import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/bottomsheets/app_time_bottomsheet.dart';
import '../../../core/widgets/buttons/app_upload_button.dart';
import '../../../core/widgets/inputs/app_text_area.dart';
import '../../../core/widgets/toggles/app_toggle.dart';
import '../model/team_create_request.dart';
import '../provider/team_create_provider.dart';
import 'team_create_success_page.dart';

class TeamCreatePage extends ConsumerStatefulWidget {
  const TeamCreatePage({super.key});

  @override
  ConsumerState<TeamCreatePage> createState() => _TeamCreatePageState();
}

class _TeamCreatePageState extends ConsumerState<TeamCreatePage> {
  final teamNameController = TextEditingController();
  final teamDescriptionController = TextEditingController();
  final teamDateController = TextEditingController();

  String? selectedTeamType;

  File? _selectedImage;
  bool _isDeleteOverlayVisible = false;
  final ImagePicker _picker = ImagePicker();

  final List<String> teamTypes = ['band', 'dance', 'vocal', 'team'];

  bool get _isTeamNameValid {
    final text = teamNameController.text.trim();
    return text.isNotEmpty && text.length <= 10;
  }

  String? get _teamNameErrorText {
    if (teamNameController.text.isEmpty) return null;
    if (!_isTeamNameValid) return '팀 이름은 한 글자 이상 10글자 이하로 작성해주세요.';
    return null;
  }

  bool get _canSubmit {
    return _isTeamNameValid &&
        teamDescriptionController.text.isNotEmpty &&
        selectedTeamType != null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isDeleteOverlayVisible = false;
      });
    }
  }

  // 팀 생성 API 요청
  Future<void> _submitTeamCreate() async {
    FocusScope.of(context).unfocus();

    final request = TeamCreateRequest(
      teamName: teamNameController.text.trim(),
      teamType: selectedTeamType!,
      description: teamDescriptionController.text.trim().isEmpty
          ? null
          : teamDescriptionController.text.trim(),
      establishedOn: teamDateController.text.trim().isEmpty
          ? null
          : teamDateController.text.trim(),
      teamImageUrl: _selectedImage?.path,
    );

    final success = await ref
        .read(teamCreateProvider.notifier)
        .createTeam(request);

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TeamCreateSuccessPage(teamName: teamNameController.text.trim()),
        ),
        (route) => route.isFirst,
      );
    } else {
      final error = ref.read(teamCreateProvider).createError;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  void dispose() {
    teamNameController.dispose();
    teamDescriptionController.dispose();
    teamDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(teamCreateProvider);

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
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
                      AppTextField(
                        hintText: '팀 이름 (10글자 이내)',
                        requiredMark: true,
                        label: '팀 이름',
                        controller: teamNameController,
                        errorText: _teamNameErrorText,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

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

                      _RequiredLabel(
                        text: '팀 유형 선택',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Wrap(
                        spacing: AppSpacing.x12,
                        runSpacing: AppSpacing.x8,
                        children: teamTypes.map((type) {
                          final typeUpper = type.toUpperCase();
                          final isSelected = selectedTeamType == typeUpper;
                          return AppToggle(
                            text: type,
                            isSelected: isSelected,
                            onChanged: (bool selected) {
                              setState(() {
                                selectedTeamType = selected ? typeUpper : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x8),
                      if (_selectedImage == null) ...[
                        AppUploadButton(
                          text: '팀 사진 등록하기',
                          onPressed: _pickImage,
                        ),
                      ] else ...[
                        GestureDetector(
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
                                Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),

                                // 사진 클릭 시 나타나는 반투명 딤 & 중앙 삭제 아이콘
                                if (_isDeleteOverlayVisible) ...[
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImage = null;
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

                      AppTextArea(
                        label: '팀 소개',
                        requiredMark: true,
                        hintText: '모임에 어울리는 팀 소개글을 작성해주세요.',
                        controller: teamDescriptionController,
                        maxLength: 200,
                        fieldHeight: 196,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              // 실제 API 연동 함수 연결 및 로딩/비활성화 처리
              AppButton(
                text: state.isLoading ? '생성 중...' : '팀 생성하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: (_canSubmit && !state.isLoading)
                    ? _submitTeamCreate
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    required this.requiredColor,
  });

  final String text;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    final style = FontStyles.med14;
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text, style: style),
            TextSpan(
              text: ' *',
              style: style.copyWith(color: requiredColor),
            ),
          ],
        ),
      ),
    );
  }
}
