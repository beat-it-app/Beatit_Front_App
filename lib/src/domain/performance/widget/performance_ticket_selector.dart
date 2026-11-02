// lib/src/domain/performance/widget/performance_ticket_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_ticket_information_popup.dart';

class PerformanceTicketSelector extends StatelessWidget {
  const PerformanceTicketSelector({
    super.key,
    required this.selectedTypes,
    required this.priceControllers,
    required this.onToggle,
    this.onPriceChanged,
    this.errorText,
  });

  final Set<PerformanceTicketType> selectedTypes;
  final Map<PerformanceTicketType, TextEditingController> priceControllers;
  final ValueChanged<PerformanceTicketType> onToggle;
  final VoidCallback? onPriceChanged;
  final String? errorText;

  static const labels = {
    PerformanceTicketType.free: '무료 공연',
    PerformanceTicketType.advance: '사전 예매 공연',
    PerformanceTicketType.onsite: '현장 예매 공연',
    PerformanceTicketType.general: '일반 예매 공연',
  };

  bool _isDisabled(PerformanceTicketType type) {
    if (selectedTypes.contains(type) || selectedTypes.isEmpty) return false;
    if (selectedTypes.contains(PerformanceTicketType.free) ||
        selectedTypes.contains(PerformanceTicketType.general)) {
      return true;
    }
    return type == PerformanceTicketType.free ||
        type == PerformanceTicketType.general;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. 티켓 가격 라벨 및 info 안내 버튼
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '티켓 가격',
                  style: FontStyles.med15.copyWith(color: context.grays.black),
                ),
                TextSpan(
                  text: ' *',
                  style: FontStyles.med15.copyWith(
                    color: context.brands.beatOrange1,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => PerformanceTicketInformationPopup.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // 💡 터치 타겟 영역 확장
              child: SvgPicture.asset(
                'assets/icons/performance/info.svg',
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  context.grays.gray5,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.x8),

      // 2. 안내 문구
      Text(
        '사전 예매와 현장 예매 공연은 중복 선택이 가능합니다.',
        style: FontStyles.med14.copyWith(color: context.grays.gray4),
      ),
      const SizedBox(height: AppSpacing.x12),

      // 3. 티켓 옵션 및 가격 입력창 리스트
      for (final type in PerformanceTicketType.values) ...[
        _TicketOption(
          text: labels[type]!,
          selected: selectedTypes.contains(type),
          disabled: _isDisabled(type),
          onTap: () => onToggle(type),
        ),
        if (type != PerformanceTicketType.free &&
            selectedTypes.contains(type)) ...[
          const SizedBox(height: AppSpacing.x8),
          AppTextField(
            hintText: '${labels[type]!.replaceAll(' 공연', '')} 가격을 입력해주세요.',
            controller: priceControllers[type],
            keyboardType: TextInputType.number,
            onChanged: (_) => onPriceChanged?.call(),
          ),
        ],
        const SizedBox(height: AppSpacing.x8),
      ],
      if (errorText != null)
        Text(
          errorText!,
          style: FontStyles.med12.copyWith(color: context.colors.error),
        ),
    ],
  );
}

/// Poll 상세의 선택지와 동일하게 좌측 텍스트, 우측 원형 선택 표시를 쓴다.
class _TicketOption extends StatelessWidget {
  const _TicketOption({
    required this.text,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x10,
        ),
        decoration: BoxDecoration(
          color: selected ? context.brands.beatOrange6 : context.grays.gray8,
          border: Border.all(
            color: selected ? context.brands.beatOrange2 : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: FontStyles.reg18.copyWith(
                  color: disabled
                      ? context.grays.gray7
                      : selected
                      ? context.brands.beatOrange1
                      : context.grays.gray1,
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? context.brands.beatOrange1
                    : disabled
                    ? context.grays.gray7
                    : context.grays.white,
                border: Border.all(
                  color: selected
                      ? context.brands.beatOrange1
                      : disabled
                      ? context.grays.gray7
                      : context.grays.gray6,
                ),
              ),
              child: selected
                  ? SvgPicture.asset(
                      'assets/icons/check/check.svg',
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(
                        context.grays.white,
                        BlendMode.srcIn,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}
