import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';

const List<String> _profileAssetPaths = <String>[
  'assets/images/auth/profile_orange.png', // 1
  'assets/images/auth/profile_green.png', // 2
  'assets/images/auth/profile_blue.png', // 3
  'assets/images/auth/profile_pink.png', // 4
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
  int? _selectedDefaultId; // 1 ~ 4 (기본 프로필인 경우)
  File? _selectedCustomFile; // 갤러리에서 새로 고른 파일
  String? _currentNetworkUrl; // 기존 네트워크 이미지 URL

  final ImagePicker _picker = ImagePicker();
  static const double _itemSpacing = 8.0;

  @override
  void initState() {
    super.initState();
    _initCurrentProfile();
  }

  // 💡 기존 프로필 사진 분석 및 초기 상태 바인딩
  void _initCurrentProfile() {
    final url = widget.initialImageUrl?.trim();

    if (url == null || url.isEmpty || url == 'string') {
      // 사진이 없는 경우 기본 1번(오렌지) 선택
      _selectedDefaultId = 1;
      return;
    }

    // 1. 기본 프로필 에셋 경로와 일치하는지 확인
    int matchedIndex = _profileAssetPaths.indexWhere(
      (path) => url.contains(path),
    );

    // 2. 서버 URL에 profile_orange, profile_green 등의 키워드가 포함된 경우도 매칭
    if (matchedIndex == -1) {
      if (url.contains('orange') || url.contains('default_1'))
        matchedIndex = 0;
      else if (url.contains('green') || url.contains('default_2'))
        matchedIndex = 1;
      else if (url.contains('blue') || url.contains('default_3'))
        matchedIndex = 2;
      else if (url.contains('pink') || url.contains('default_4'))
        matchedIndex = 3;
    }

    if (matchedIndex != -1) {
      _selectedDefaultId = matchedIndex + 1; // 1~4
    } else {
      // 일반 네트워크 커스텀 이미지인 경우
      _currentNetworkUrl = url;
      _selectedDefaultId = null;
    }
  }

  // 갤러리에서 사진 선택
  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _selectedCustomFile = File(picked.path);
        _selectedDefaultId = null;
        _currentNetworkUrl = null;
      });

      if (mounted) {
        Navigator.pop(context, {'type': 'custom', 'file': _selectedCustomFile});
      }
    }
  }

  // 기본 프로필 선택
  void _selectDefault(int id) {
    setState(() {
      _selectedDefaultId = id;
      _selectedCustomFile = null;
      _currentNetworkUrl = null;
    });

    Navigator.pop(context, {'type': 'default', 'defaultId': id});
  }

  // 중앙 원형에 띄울 위젯 결정
  Widget _buildPreviewImage() {
    if (_selectedCustomFile != null) {
      return Image.file(_selectedCustomFile!, fit: BoxFit.cover);
    }

    if (_selectedDefaultId != null) {
      return Image.asset(
        _profileAssetPaths[_selectedDefaultId! - 1],
        fit: BoxFit.contain,
      );
    }

    if (_currentNetworkUrl != null && _currentNetworkUrl!.isNotEmpty) {
      return Image.network(
        _currentNetworkUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset(_profileAssetPaths[0], fit: BoxFit.contain),
      );
    }

    return Image.asset(_profileAssetPaths[0], fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.x30),

            Center(
              child: Text(
                '프로필 사진 선택',
                style: FontStyles.bold26.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(height: AppSpacing.x50),

            // 💡 중앙 원형 프로필 미리보기
            Center(
              child: SizedBox(
                width: 130,
                height: 130,
                child: ClipOval(child: _buildPreviewImage()),
              ),
            ),
            const SizedBox(height: AppSpacing.x28),

            // 기본 프로필 선택 라벨
            Text(
              '기본 프로필 선택',
              style: FontStyles.semi16.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.x12),

            // 하단 선택 리스트 (갤러리 + 기본 프로필 4종)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // 1. 갤러리 선택 버튼
                  GestureDetector(
                    onTap: _pickFromGallery,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.grays.gray8,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/auth/gallery.svg',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ),
                  ),

                  // 2. 기본 프로필 아바타 4종
                  for (int i = 0; i < _profileAssetPaths.length; i++) ...[
                    const SizedBox(width: _itemSpacing),
                    GestureDetector(
                      onTap: () => _selectDefault(i + 1),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              _profileAssetPaths[i],
                              fit: BoxFit.contain,
                            ),
                          ),
                          // 💡 기본 프로필 중 현재 선택된 아이템에 체크 표시 노출
                          if (_selectedDefaultId == i + 1 &&
                              _selectedCustomFile == null &&
                              _currentNetworkUrl == null)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/check/check.svg',
                                  width: 12,
                                  height: 12,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x20),
          ],
        ),
      ),
    );
  }
}
