import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 44.0,
    this.height = 24.0,
    this.ballPadding = 4.0,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(width > 0),
       assert(height > 0),
       assert(ballPadding >= 0),
       assert(ballPadding * 2 < height);

  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;
  final double ballPadding;
  final Duration duration;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  double get _ballSize => widget.height - (widget.ballPadding * 2);

  @override
  Widget build(BuildContext context) {
    final switchColor = widget.value
        ? context.brands.beatOrange6
        : context.grays.gray7;

    final switchBallColor = widget.value
        ? context.brands.beatOrange1
        : context.grays.white;

    final switchLeft = widget.value
        ? widget.width - _ballSize - widget.ballPadding
        : widget.ballPadding;

    return Semantics(
      button: true,
      toggled: widget.value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onChanged(!widget.value),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: widget.duration,
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: switchColor,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),
              AnimatedPositioned(
                duration: widget.duration,
                top: widget.ballPadding,
                left: switchLeft,
                child: Container(
                  width: _ballSize,
                  height: _ballSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: switchBallColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.shadow.withValues(alpha: 0.12),
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
