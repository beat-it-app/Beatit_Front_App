import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 외부 상태가 유일한 기준인 controlled switch.
/// 비활성화할 때도 [value]를 바꾸지 않으므로 하위 알림 선택값이 보존된다.
class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.width = 50.0,
    this.height = 27.0,
    this.ballPadding = 2.0,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(width > height),
       assert(height > 0),
       assert(ballPadding >= 0),
       assert(ballPadding * 2 < height);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final double width;
  final double height;
  final double ballPadding;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ballSize = height - (ballPadding * 2);
    final interactive = enabled && onChanged != null;
    final trackColor = !interactive
        ? context.grays.gray8
        : value
            ? context.grays.black
            : context.grays.gray7;
    final knobLeft = value
        ? width - ballSize - ballPadding
        : ballPadding;

    return Semantics(
      button: true,
      enabled: interactive,
      toggled: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive ? () => onChanged!(!value) : null,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              AnimatedPositioned(
                duration: duration,
                top: ballPadding,
                left: knobLeft,
                child: Container(
                  width: ballSize,
                  height: ballSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.grays.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withValues(alpha: 0.12),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: value
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/icons/check/check.svg',
                            width: ballSize * 0.65,
                            height: ballSize * 0.65,
                            colorFilter: ColorFilter.mode(
                              interactive
                                  ? context.grays.black
                                  : context.grays.gray5,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
