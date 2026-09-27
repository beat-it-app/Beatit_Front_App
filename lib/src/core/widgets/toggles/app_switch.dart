import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  static const Duration _duration = Duration(milliseconds: 100);
  static const double _width = 44.0;
  static const double _height = 24.0;
  static const double _ballPadding = 4.0;

  double get _ballSize => _height - (_ballPadding * 2);

  @override
  Widget build(BuildContext context) {
    final switchColor = widget.value
        ? context.brands.beatOrange6
        : context.grays.gray7;
    final switchBallColor = widget.value
        ? context.brands.beatOrange1
        : context.grays.white;
    final switchLeft = widget.value
        ? _width - _ballSize - _ballPadding
        : _ballPadding;

    return Semantics(
      button: true,
      toggled: widget.value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChanged(!widget.value),
        child: SizedBox(
          width: _width,
          height: _height,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: _duration,
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: switchColor,
                  borderRadius: BorderRadius.circular(_height / 2),
                ),
              ),
              AnimatedPositioned(
                duration: _duration,
                top: _ballPadding,
                left: switchLeft,
                child: Container(
                  width: _ballSize,
                  height: _ballSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: switchBallColor,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
