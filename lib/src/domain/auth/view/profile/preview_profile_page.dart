import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottons/app_button.dart';
import 'package:beatit_front_app/src/domain/auth/widget/profile_preview_item.dart';

import 'complete_signup_page.dart';

const List<String> _profileAssetPaths = <String>[
  'assets/images/auth/profile_orange.png',
  'assets/images/auth/profile_green.png',
  'assets/images/auth/profile_blue.png',
  'assets/images/auth/profile_pink.png',
];

class PreviewProfilePage extends StatefulWidget {
  final String userName;

  const PreviewProfilePage({super.key, this.userName = '송하은'});

  @override
  State<PreviewProfilePage> createState() => _PreviewProfilePageState();
}

class _PreviewProfilePageState extends State<PreviewProfilePage> {
  int? _selectedProfileIndex;
  bool _isCustomProfileAdded = false;

  int get _customProfileIndex => _profileAssetPaths.length;

  bool get _isCustomProfileSelected {
    return _selectedProfileIndex == _customProfileIndex;
  }

  bool get _canSubmit {
    return _selectedProfileIndex != null;
  }

  void _selectProfile(int index) {
    setState(() {
      _selectedProfileIndex = index;
    });
  }

  void _selectCustomProfile() {
    setState(() {
      _isCustomProfileAdded = true;
      _selectedProfileIndex = _customProfileIndex;
    });
  }

  void _handleNextPressed() {
    if (!_canSubmit) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompleteSignupPage(userName: widget.userName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
                                isSelected: _selectedProfileIndex == index,
                                label: widget.userName,
                                semanticsLabel:
                                    '${widget.userName} 기본 프로필 ${index + 1}',
                                onTap: () {
                                  _selectProfile(index);
                                },
                                image: Image.asset(
                                  _profileAssetPaths[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ProfilePreviewItem(
                              isSelected: _isCustomProfileSelected,
                              label: _isCustomProfileAdded
                                  ? widget.userName
                                  : '프로필 추가',
                              isLabelEnabled: _isCustomProfileAdded,
                              semanticsLabel: _isCustomProfileAdded
                                  ? '${widget.userName} 커스텀 프로필'
                                  : '프로필 추가',
                              onTap: _selectCustomProfile,
                              image: const AddProfileImage(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '완료',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _canSubmit ? _handleNextPressed : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
