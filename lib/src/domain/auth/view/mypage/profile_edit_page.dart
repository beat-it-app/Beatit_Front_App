import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';

import '../../api/profile_edit_api.dart';
import '../../provider/mypage_provider.dart';
import '../../widget/profile_image_bottom_sheet.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  // 1. 프로필 이미지 변경 바텀시트 열기
  Future<void> _openImageBottomSheet(String? currentProfileUrl) async {
    final result = await ProfileImageBottomSheet.show(
      context,
      initialImageUrl: currentProfileUrl,
    );

    if (result == null || !mounted) return;

    try {
      final api = ref.read(profileEditApiProvider);

      if (result['type'] == 'default') {
        final defaultId = result['defaultId'] as int;
        await api.updateProfileImage(defaultImageId: defaultId);
      } else if (result['type'] == 'custom') {
        final file = result['file'] as File;
        await api.updateProfileImage(customImageFile: file);
      }

      ref.read(myPageProvider.notifier).fetchMyPage();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 이미지가 변경되었습니다.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // 💡 2. 글자 수 초과 안내 팝업 (AppPopup 직접 호출)
  Future<void> _showWarningPopup(String message) async {
    await AppPopup.show(
      context,
      title: '',
      warningType: WarningType.none,
      contentType: ContentType.small,
      buttonNum: ButtonNum.one,
      confirmText: '확인',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 회색 원형 느낌표 (!) 아이콘
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.grays.gray7,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '!',
              style: FontStyles.bold28.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.x20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: FontStyles.bold20.copyWith(color: Colors.black, height: 1.3),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
      ),
    );
  }

  // 💡 3. 이름 변경 팝업 및 유효성 검사 (AppPopup 직접 호출)
  Future<void> _handleNameEdit(String currentName) async {
    final controller = TextEditingController(text: currentName);

    final confirmed = await AppPopup.show(
      context,
      title: '이름 변경',
      warningType: WarningType.none,
      contentType: ContentType.large,
      buttonNum: ButtonNum.two,
      confirmText: '확인',
      cancelText: '취소',
      contentWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
        child: TextField(
          controller: controller,
          autofocus: true,
          style: FontStyles.reg16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: '새로운 이름을 입력해주세요.',
            hintStyle: FontStyles.reg14.copyWith(color: context.grays.gray5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: context.grays.gray8,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    final newName = controller.text.trim();

    // 10글자 초과 또는 2자 미만 검증 -> 팝업 띄우기
    if (newName.length > 10 || newName.length < 2) {
      await _showWarningPopup('이름은 10글자 이내로\n작성해주세요.');
      return;
    }

    // 기존 이름과 동일한 경우
    if (newName == currentName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기존 이름과 동일한 이름으로 변경할 수 없습니다.')),
      );
      return;
    }

    try {
      await ref.read(profileEditApiProvider).updateName(newName);
      ref.read(myPageProvider.notifier).fetchMyPage();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이름 변경에 성공했습니다.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  String _formatSocialAccounts(List<String> accounts) {
    if (accounts.isEmpty) return '없음';
    return accounts
        .map((acc) {
          switch (acc.toUpperCase()) {
            case 'KAKAO':
              return '카카오계정';
            case 'GOOGLE':
              return '구글계정';
            case 'APPLE':
              return '애플계정';
            case 'NAVER':
              return '네이버계정';
            default:
              return acc;
          }
        })
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final myPageState = ref.watch(myPageProvider);
    final data = myPageState.data;

    final userProfileUrl = data?.profileImageUrl?.trim();
    final bool hasProfileImage =
        userProfileUrl != null &&
        userProfileUrl.isNotEmpty &&
        userProfileUrl != 'string';

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.x16),

            // 프로필 아바타 + 편집 아이콘
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => _openImageBottomSheet(userProfileUrl),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: context.colors.primary,
                      child: hasProfileImage
                          ? ClipOval(
                              child: Image.network(
                                userProfileUrl,
                                width: 108,
                                height: 108,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/auth/profile_orange.png',
                                  width: 108,
                                  height: 108,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/images/auth/profile_orange.png',
                              width: 108,
                              height: 108,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _openImageBottomSheet(userProfileUrl),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: context.grays.gray7,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.surface, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x16),

            // 이름 + 연필 아이콘
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleNameEdit(data?.userName ?? ''),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data?.userName ?? '사용자',
                      style: FontStyles.bold22.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.edit, size: 18, color: Colors.black87),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.x30),

            Divider(height: 1, thickness: 1, color: context.grays.gray8),

            const SizedBox(height: AppSpacing.x24),

            // 기본 정보 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기본 정보',
                    style: FontStyles.bold18.copyWith(color: colors.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.x24),
                  _buildInfoRow('이름', data?.userName ?? ''),
                  const SizedBox(height: AppSpacing.x20),
                  _buildInfoRow('이메일', data?.email ?? ''),
                  const SizedBox(height: AppSpacing.x20),
                  _buildInfoRow(
                    '소셜 로그인',
                    _formatSocialAccounts(data?.socialAccounts ?? []),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: FontStyles.reg16.copyWith(color: context.grays.gray4),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: FontStyles.reg16.copyWith(color: context.grays.gray2),
          ),
        ),
      ],
    );
  }
}
