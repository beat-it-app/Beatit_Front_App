import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 디자인상의 토글. 값의 소유권은 상위 설정 Provider에 있다.
class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.width = 50,
    this.height = 27,
    this.ballPadding = 2,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(width > height),
       assert(ballPadding >= 0 && ballPadding * 2 < height);

  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final double ballPadding;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final diameter = height - ballPadding * 2;
    return Semantics(
      toggled: value,
      enabled: interactive,
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
                  color: !interactive
                      ? context.grays.gray8
                      : value
                          ? context.grays.black
                          : context.grays.gray7,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              AnimatedPositioned(
                duration: duration,
                top: ballPadding,
                left: value ? width - diameter - ballPadding : ballPadding,
                child: Container(
                  width: diameter,
                  height: diameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.grays.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow
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
                            width: diameter * 0.65,
                            colorFilter: ColorFilter.mode(
                              interactive ? context.grays.black : context.grays.gray5,
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
