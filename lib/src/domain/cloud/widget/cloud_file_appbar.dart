import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_basic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CloudFileAppbar({
    super.key,
    required this.titleText,
    this.onLeadingPressed,
    this.onTitlePressed,
  });

  final String titleText;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onTitlePressed;

  @override
  Size get preferredSize => const Size.fromHeight(84.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.grays.white,
      surfaceTintColor: context.grays.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: AppSpacing.x20,
                child: CloudBasicButton(onPressed: onLeadingPressed),
              ),
              Padding(
                // 왼쪽 버튼이 있어도 제목은 화면 전체의 정중앙에 유지한다.
                padding: const EdgeInsets.symmetric(horizontal: 106.0),
                child: _CloudFileTitleButton(
                  titleText: titleText,
                  onPressed: onTitlePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloudFileTitleButton extends StatelessWidget {
  const _CloudFileTitleButton({
    required this.titleText,
    required this.onPressed,
  });

  final String titleText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onPressed != null,
      label: onPressed == null ? null : '파일 목록 열기',
      child: MouseRegion(
        cursor: onPressed == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.semi18.copyWith(
                    color: context.grays.black,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/cloud/toggle_down.svg',
                    width: 24.0,
                    height: 24.0,
                    colorFilter: ColorFilter.mode(
                      context.grays.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
