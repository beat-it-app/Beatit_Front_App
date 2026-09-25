import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationReferenceWidget extends StatelessWidget {
  const LocationReferenceWidget({
    super.key,
    required this.isInputVisible,
    required this.controller,
    required this.onAddPressed,
    required this.onDeletePressed,
    this.onChanged,
  });

  final bool isInputVisible;
  final TextEditingController controller;
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (!isInputVisible) {
      return _AddReferenceButton(onPressed: onAddPressed);
    }

    return AppTextField(
      controller: controller,
      hintText: '기준 위치를 입력하세요.',
      height: 45,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      suffixIcon: Semantics(
        button: true,
        label: '기준 위치 삭제',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDeletePressed,
          child: SizedBox(
            width: 16,
            height: 16,
            child: SvgPicture.asset(
              'assets/icons/etc/cancel.svg',
              colorFilter: ColorFilter.mode(
                context.grays.gray6,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddReferenceButton extends StatelessWidget {
  const _AddReferenceButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '기준 위치 추가하기',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.x8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.brands.beatOrange1,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/etc/location.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      context.grays.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(
                '기준 위치 추가하기',
                style: FontStyles.med18.copyWith(color: context.grays.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
