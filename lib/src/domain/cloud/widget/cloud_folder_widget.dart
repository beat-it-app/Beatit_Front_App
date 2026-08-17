import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudFolderWidget extends StatefulWidget {
  const CloudFolderWidget({super.key});
  @override
  State<CloudFolderWidget> createState() => _CloudFolderWidgetState();
}

class _CloudFolderWidgetState extends State<CloudFolderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: context.grays.gray5),
      height: 65.0,
      padding: EdgeInsets.only(left: AppSpacing.x30, right: AppSpacing.x24),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/cloud/folder.svg'),
          const SizedBox(width: AppSpacing.x24),
          Text(
            '__의 폴더',
            style: FontStyles.med16.copyWith(color: context.grays.black),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '10',
                style: FontStyles.med16.copyWith(color: context.grays.gray5),
              ),
              const SizedBox(width: AppSpacing.x4),
              SvgPicture.asset(
                'assets/icons/cloud/back.svg',
                color: context.grays.gray6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
