import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 팀 클라우드에서 표시하는 아이템의 종류다.
///
/// 음원은 일반적으로 [audio]라고 표현한다. 현재 프로젝트의 에셋 파일명이
/// `fifi.svg`이므로 아이콘 경로만 기존 이름을 유지한다.
enum CloudItemType { audio, video, file, link }

extension CloudItemTypeExtension on CloudItemType {
  String get iconPath {
    return switch (this) {
      CloudItemType.audio => 'assets/icons/cloud/music_simbol.svg',
      CloudItemType.video => 'assets/icons/cloud/file.svg',
      CloudItemType.file => 'assets/icons/cloud/file.svg',
      CloudItemType.link => 'assets/icons/cloud/link.svg',
    };
  }

  bool get showsFileSize => this != CloudItemType.link;
}

class CloudItemWidget extends StatelessWidget {
  const CloudItemWidget({
    super.key,
    required this.itemType,
    required this.fileName,
    required this.uploadedAt,
    required this.uploaderName,
    this.fileSize,
    this.isSelected = false,
    this.onTap,
    this.onMenuTap,
    this.menuItems = const [],
    this.menuWidth = 160.0,
    this.menuItemHeight = 44.0,
    this.menuOffset = const Offset(0, 40),
  });

  final CloudItemType itemType;
  final String fileName;
  final String? fileSize;
  final String uploadedAt;
  final String uploaderName;

  /// 메인 화면에서 관리하는 현재 선택 상태다.
  final bool isSelected;

  /// 아이템 전체를 눌렀을 때 실행된다.
  final VoidCallback? onTap;

  /// 더보기 버튼을 눌렀을 때 아이템 선택 상태도 함께 갱신하기 위한 콜백이다.
  final VoidCallback? onMenuTap;

  /// 파일 형식에 맞게 메인 화면에서 만들어 전달하는 드롭다운 목록이다.
  final List<AppDropdownItem> menuItems;

  final double menuWidth;
  final double menuItemHeight;
  final Offset menuOffset;

  static const double _itemHeight = 65.0;
  static const double _menuButtonWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(18),
      colorScheme.surface,
    );
    final pressedColor = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(28),
      colorScheme.surface,
    );
    final shouldShowFileSize =
        itemType.showsFileSize && fileSize?.isNotEmpty == true;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$fileName, $uploadedAt, $uploaderName',
      child: Material(
        color: isSelected ? selectedColor : colorScheme.surface,
        animationDuration: const Duration(milliseconds: 160),
        child: InkWell(
          onTap: onTap,
          highlightColor: pressedColor,
          splashColor: pressedColor,
          child: SizedBox(
            height: _itemHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.x30,
                right: AppSpacing.x8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    itemType.iconPath,
                    width: 20.0,
                    height: 20.0,
                  ),
                  const SizedBox(width: AppSpacing.x16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FontStyles.med16.copyWith(
                                  color: context.grays.black,
                                ),
                              ),
                            ),
                            if (shouldShowFileSize) ...[
                              const SizedBox(width: AppSpacing.x4),
                              Text(
                                '($fileSize)',
                                style: FontStyles.med16.copyWith(
                                  color: context.grays.gray5,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            Text(
                              uploadedAt,
                              style: FontStyles.med12.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Text(
                              '•',
                              style: FontStyles.med12.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Flexible(
                              child: Text(
                                uploaderName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FontStyles.med12.copyWith(
                                  color: context.grays.gray5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildMoreMenu(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenu() {
    if (menuItems.isEmpty) {
      return _CloudMoreButton(onPressed: onMenuTap ?? () {});
    }

    return AppDropdownList(
      items: menuItems,
      width: menuWidth,
      anchorWidth: _menuButtonWidth,
      itemHeight: menuItemHeight,
      alignment: AppDropdownAlignment.right,
      alignmentOffset: menuOffset,
      triggerBuilder: (context, controller) {
        return _CloudMoreButton(
          onPressed: () {
            onMenuTap?.call();

            if (controller.isOpen) {
              controller.close();
              return;
            }

            controller.open();
          },
        );
      },
    );
  }
}

class _CloudMoreButton extends StatelessWidget {
  const _CloudMoreButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '파일 더보기 메뉴',
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashFactory: NoSplash.splashFactory,
        highlightColor: context.grays.gray8.withAlpha(18),
        child: SizedBox(
          width: CloudItemWidget._menuButtonWidth,
          height: 48.0,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/appbar/menu.svg',
              width: 20.0,
              height: 20.0,
              colorFilter: ColorFilter.mode(
                context.grays.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
