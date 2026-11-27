import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';

const double _profileItemWidth = 120;
const double _profileImageSize = 120;

class ProfilePreviewItem extends StatelessWidget {
  final bool isSelected;
  final String label;
  final String semanticsLabel;
  final bool isLabelEnabled;
  final VoidCallback onTap;
  final Widget image;

  const ProfilePreviewItem({
    super.key,
    required this.isSelected,
    required this.label,
    required this.semanticsLabel,
    required this.onTap,
    required this.image,
    this.isLabelEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticsLabel,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x8,
              vertical: AppSpacing.x20,
            ),
            decoration: BoxDecoration(
              color: isSelected ? context.grays.gray8 : null,
              borderRadius: borderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: _profileImageSize,
                  child: Center(child: image),
                ),
                const SizedBox(height: AppSpacing.x10),
                SizedBox(
                  height: 20,
                  width: _profileItemWidth,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: FontStyles.med16.copyWith(
                      color: isLabelEnabled
                          ? context.grays.gray2
                          : context.grays.gray5,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddProfileImage extends StatelessWidget {
  const AddProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _profileImageSize,
      height: _profileImageSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.grays.gray6,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/icons/plus/plus.svg',
        height: 24,
        colorFilter: ColorFilter.mode(context.grays.white, BlendMode.srcIn),
      ),
    );
  }
}
