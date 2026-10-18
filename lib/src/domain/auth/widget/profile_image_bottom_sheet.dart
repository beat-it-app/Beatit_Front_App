import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';

const List<String> _profileAssetPaths = <String>[
  'assets/images/auth/profile_orange.png',
  'assets/images/auth/profile_green.png',
  'assets/images/auth/profile_blue.png',
  'assets/images/auth/profile_pink.png',
];

class ProfileImageBottomSheet extends ConsumerStatefulWidget {
  final String? initialImageUrl;

  const ProfileImageBottomSheet({super.key, this.initialImageUrl});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? initialImageUrl,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ProfileImageBottomSheet(initialImageUrl: initialImageUrl),
    );
  }

  @override
  ConsumerState<ProfileImageBottomSheet> createState() =>
      _ProfileImageBottomSheetState();
}

class _ProfileImageBottomSheetState
    extends ConsumerState<ProfileImageBottomSheet> {
  int? _selectedDefaultId; // 1 ~ 4
  File? _selectedCustomFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 기본 선택은 1번 오렌지로 기본 세팅
    _selectedDefaultId = 1;
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _selectedCustomFile = File(picked.path);
        _selectedDefaultId = null;
      });
      // 사진 선택 완료 후 결과 반환
      if (mounted) {
        Navigator.pop(context, {'type': 'custom', 'file': _selectedCustomFile});
      }
    }
  }

  void _selectDefault(int id) {
    setState(() {
      _selectedDefaultId = id;
      _selectedCustomFile = null;
    });
    // 선택 즉시 적용하여 닫기
    Navigator.pop(context, {'type': 'default', 'defaultId': id});
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x20,
        vertical: AppSpacing.x24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '프로필 사진 선택',
                style: FontStyles.bold22.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: AppSpacing.x30),

            // 중앙 큰 원형 미리보기
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: ClipOval(
                  child: _selectedCustomFile != null
                      ? Image.file(_selectedCustomFile!, fit: BoxFit.cover)
                      : Image.asset(
                          _profileAssetPaths[(_selectedDefaultId ?? 1) - 1],
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x40),

            // 기본 프로필 선택 라벨
            Text(
              '기본 프로필 선택',
              style: FontStyles.bold20.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.x16),

            // 선택 아이템 목록: [갤러리 아이콘] + [기본 아바타 1~4]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. 갤러리 선택 버튼
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.grays.gray8,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: context.grays.gray4,
                        size: 26,
                      ),
                    ),
                  ),
                ),

                // 2. 기본 프로필 아바타 4종
                for (int i = 0; i < _profileAssetPaths.length; i++)
                  GestureDetector(
                    onTap: () => _selectDefault(i + 1),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 58,
                          height: 58,
                          child: Image.asset(
                            _profileAssetPaths[i],
                            fit: BoxFit.contain,
                          ),
                        ),
                        // 선택된 항목의 체크 표시 오버레이
                        if (_selectedDefaultId == i + 1 &&
                            _selectedCustomFile == null)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x20),
          ],
        ),
      ),
    );
  }
}
