import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/alarm/widget/setting_switch_widget.dart';
import 'package:flutter/material.dart';

enum AlarmSettingType { main, detail }

class SettingSwtichSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: interactive ? () => onChanged!(!value) : null,
        hoverColor: context.brands.beatOrange6,
        focusColor: context.brands.beatOrange6,
        highlightColor: context.brands.beatOrange6,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x10),
          alignment: Alignment.center,
          constraints: BoxConstraints(
            minHeight: type == AlarmSettingType.main ? 65 : 45,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: (type == AlarmSettingType.main
                              ? FontStyles.bold18
                              : FontStyles.reg18)
                          .copyWith(
                            color: enabled
                                ? context.grays.black
                                : context.grays.gray5,
                            height: 1,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onChanged != null)
                    IgnorePointer(
                      child: SettingSwitch(
                        value: value,
                        enabled: interactive,
                        onChanged: onChanged,
                      ),
                    ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: AppSpacing.x8),
                Text(
                  description!,
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
