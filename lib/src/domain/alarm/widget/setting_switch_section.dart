import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/setting_switch_widget.dart';
import 'package:flutter/material.dart';

enum AlarmSettingType { main, detail }

/// 제목/설명/스위치만 표시하며 설정 상태의 소유권은 상위 페이지에 둔다.
class SettingSwtichSection extends StatefulWidget {
  const SettingSwtichSection({
    super.key,
    required this.type,
    required this.title,
    this.description,
    this.value = false,
    this.enabled = true,
    this.onChanged,
  });

  final AlarmSettingType type;
  final String title;
  final String? description;
  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  State<SettingSwtichSection> createState() => _SettingSwtichSectionState();
}

class _SettingSwtichSectionState extends State<SettingSwtichSection> {
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && widget.onChanged != null;
    final textColor = widget.enabled ? context.grays.black : context.grays.gray5;
    final highlight = interactive && _isHighlighted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      alignment: Alignment.center,
      constraints: BoxConstraints(
        minHeight: widget.type == AlarmSettingType.main ? 65.0 : 45.0,
      ),
      color: highlight ? context.brands.beatOrange6 : context.grays.white,
      child: InkWell(
        onTap: interactive ? () => widget.onChanged!(!widget.value) : null,
        onHover: (value) {
          if (_isHighlighted != value) setState(() => _isHighlighted = value);
        },
        onFocusChange: (value) {
          if (_isHighlighted != value) setState(() => _isHighlighted = value);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: (widget.type == AlarmSettingType.main
                              ? FontStyles.bold18
                              : FontStyles.reg18)
                          .copyWith(color: textColor, height: 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.onChanged != null)
                    // InkWell이 탭을 담당하며 스위치는 값 표현만 담당한다.
                    IgnorePointer(
                      child: SettingSwitch(
                        value: widget.value,
                        enabled: interactive,
                        onChanged: widget.onChanged,
                      ),
                    ),
                ],
              ),
              if (widget.description != null) ...[
                const SizedBox(height: AppSpacing.x8),
                Text(
                  widget.description!,
                  style: FontStyles.med14.copyWith(color: context.grays.gray4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
