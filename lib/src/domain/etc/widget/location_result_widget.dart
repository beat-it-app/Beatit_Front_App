import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationResultWidget extends StatelessWidget {
  const LocationResultWidget({
    super.key,
    required this.name,
    required this.address,
    this.distance,
    this.onTap,
  });

  final String name;
  final String address;
  final String? distance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.x20,
          bottom: AppSpacing.x20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyles.med20.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                ),
                if (distance != null && distance!.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.x4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      '${distance!}m',
                      style: FontStyles.med16.copyWith(
                        color: context.grays.gray5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: SvgPicture.asset(
                    'assets/icons/etc/location.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      context.grays.gray4,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    address,
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x20),
            Divider(color: context.grays.gray7),
          ],
        ),
      ),
    );
  }
}
