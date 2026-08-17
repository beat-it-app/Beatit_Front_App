import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudItemWidget extends StatefulWidget {
  const CloudItemWidget({super.key});
  // CloudItemType itemType;

  @override
  State<CloudItemWidget> createState() => _CloudItemWidgetState();
}

class _CloudItemWidgetState extends State<CloudItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: context.grays.gray5),
      height: 65.0,
      padding: EdgeInsets.only(left: AppSpacing.x30, right: AppSpacing.x16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/cloud/folder.svg'),
          const SizedBox(width: AppSpacing.x24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Basket Case.mp3',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.black,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Text(
                    '(10MB)',
                    style: FontStyles.med16.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Text(
                    '2026.08.26',
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
                  Text(
                    '송하은',
                    style: FontStyles.med12.copyWith(
                      color: context.grays.gray5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset('assets/icons/appbar/menu.svg'),
        ],
      ),
    );
  }
}
