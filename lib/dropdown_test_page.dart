import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class DropdownTestPage extends StatefulWidget {
  const DropdownTestPage({super.key});

  @override
  State<DropdownTestPage> createState() => _DropdownTestPageState();
}

class _DropdownTestPageState extends State<DropdownTestPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppTwoAppBar(trailing: AppTwoAppBarTrailing.all),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            AppButton(text: '드롭다운 버튼', onPressed: () {}),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: context.grays.gray7.withOpacity(0.95),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border(
                          bottom: BorderSide(color: context.grays.gray7),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/check/check.svg',
                            width: 24.0,
                          ),
                          const SizedBox(width: AppSpacing.x4),
                          Text('팀 생성하기', style: FontStyles.med16),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border(
                          bottom: BorderSide(color: context.grays.gray7),
                        ),
                        color: context.grays.white,
                      ),
                      child: Row(
                        children: [Text('팀 생성하기', style: FontStyles.med16)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
