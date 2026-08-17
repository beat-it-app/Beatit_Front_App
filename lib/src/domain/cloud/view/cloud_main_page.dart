import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_folder_widget.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/auth/widget/result_box.dart';

// enum CloudItemType { video, file, link, fifi }
//
// extension CloudItemTypeExtension on CloudItemType {
//   String get iconPath {
//     switch (this) {
//       case CloudItemType.video:
//         return 'assets/icons/cloud/video.svg';
//       case CloudItemType.file:
//         return 'assets/icons/cloud/file.svg';
//       case CloudItemType.link:
//         return 'assets/icons/cloud/link.svg';
//       case CloudItemType.fifi:
//         return 'assets/icons/cloud/fifi.svg';
//     }
// }

class CloudMainPage extends StatefulWidget {
  const CloudMainPage({super.key});

  @override
  State<CloudMainPage> createState() => _CloudMainPageState();
}

class _CloudMainPageState extends State<CloudMainPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isEditing = false;
    final inFolder = false;

    return Scaffold(
      appBar: AppTwoAppBar(
        trailing: AppTwoAppBarTrailing.add,
        addMenuAlignment: AppDropdownAlignment.right,
        addMenuOffset: const Offset(0, 68),

        addMenuItems: [
          AppDropdownItem(
            label: '새폴더 만들기',
            onPressed: () {
              debugPrint('새폴더 만들기');
            },
          ),
          AppDropdownItem(
            label: '파일 등록하기',
            onPressed: () {
              debugPrint('파일 등록하기 팝업 띄우기');
            },
          ),
          AppDropdownItem(
            label: '링크 등록하기',
            onPressed: () {
              debugPrint('링크 등록하기 팝업 띄우기');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            // horizontal: AppSpacing.x16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
                child: Row(
                  children: [
                    Text(
                      '팀 클라우드',
                      style: FontStyles.bold34.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (!inFolder) ...[
                const SizedBox(height: AppSpacing.x30),
              ] else if (isEditing) ...[
                const SizedBox(height: AppSpacing.x4),
                Text(
                  '${'widget.num'}개의 파일',
                  style: FontStyles.med14.copyWith(color: context.grays.gray4),
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.x24),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.grays.gray5,
                        borderRadius: BorderRadius.circular(AppSpacing.x8),
                      ),
                    ),
                    Text(
                      '전체 선택하기',
                      style: FontStyles.med14.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x16),
              ],
              CloudFolderWidget(),
              CloudItemWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
