import 'dart:io';

import 'package:beatit_front_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_field_message.dart';

import 'package:beatit_front_app/src/domain/auth/provider/auth_provider.dart';
import 'package:beatit_front_app/src/domain/auth/provider/create_profile_provider.dart';
import 'package:beatit_front_app/src/domain/auth/widget/profile_preview_item.dart';

const List<String> _profileAssetPaths = <String>[
  'assets/images/auth/profile_orange.png',
  'assets/images/auth/profile_green.png',
  'assets/images/auth/profile_blue.png',
  'assets/images/auth/profile_pink.png',
];

class PreviewProfilePage extends ConsumerStatefulWidget {
  const PreviewProfilePage({super.key, required this.userName});

  final String userName;

  @override
  ConsumerState<PreviewProfilePage> createState() => _PreviewProfilePageState();
}

class _PreviewProfilePageState extends ConsumerState<PreviewProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickCustomProfile() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (!mounted || image == null) {
      return;
    }

    ref.read(profileCreateProvider.notifier).selectCustomProfile(image);
  }

  Future<void> _handleCompletePressed() async {
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(profileCreateProvider.notifier)
        .createProfile(name: widget.userName);

    if (!mounted || !success) {
      return;
    }

    ref.read(authProvider.notifier).markProfileCreated();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MainShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(profileCreateProvider);

    final selection = state.selectedImage;

    final selectedDefaultId = selection is DefaultProfileSelection
        ? selection.defaultImageId
        : null;

    final customImage = selection is CustomProfileSelection
        ? selection.image
        : null;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '프로필\n미리보기',
                        style: FontStyles.bold46.copyWith(
                          color: colors.onSurface,
                          height: 1.2,
                          letterSpacing: -0.92,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x10),

                      Text(
                        '사용할 프로필 이미지를 선택해주세요.',
                        style: FontStyles.med16.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x60),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (
                              int index = 0;
                              index < _profileAssetPaths.length;
                              index++
                            )
                              ProfilePreviewItem(
                                isSelected: selectedDefaultId == index + 1,
                                label: widget.userName,
                                semanticsLabel:
                                    '${widget.userName} 기본 프로필 ${index + 1}',
                                onTap: () {
                                  ref
                                      .read(profileCreateProvider.notifier)
                                      .selectDefaultProfile(index + 1);
                                },
                                image: Image.asset(
                                  _profileAssetPaths[index],
                                  fit: BoxFit.contain,
                                ),
                              ),

                            ProfilePreviewItem(
                              isSelected: customImage != null,
                              label: customImage != null
                                  ? widget.userName
                                  : '프로필 추가',
                              isLabelEnabled: customImage != null,
                              semanticsLabel: customImage != null
                                  ? '${widget.userName} 커스텀 프로필'
                                  : '프로필 추가',
                              onTap: _pickCustomProfile,
                              image: customImage == null
                                  ? const AddProfileImage()
                                  : ClipOval(
                                      child: SizedBox.expand(
                                        child: Image.file(
                                          File(customImage.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state.error != null) ...[
                AppFieldMessage(text: state.error!, isError: true),
                const SizedBox(height: AppSpacing.x10),
              ],

              AppButton(
                text: state.isSubmitting ? '등록 중' : '완료',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: state.canSubmit ? _handleCompletePressed : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
