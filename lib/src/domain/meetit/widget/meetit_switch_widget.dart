import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';

typedef OnCheckChange = void Function(bool isShow);

class MeetitSwitchWidget extends StatefulWidget {
  final OnCheckChange? onCheckChange;
  final bool initialValue;

  const MeetitSwitchWidget({
    super.key,
    this.onCheckChange,
    this.initialValue = false,
  });

  @override
  MeetitSwitchWidgetState createState() => MeetitSwitchWidgetState();
}

class MeetitSwitchWidgetState extends State<MeetitSwitchWidget> {
  final duration = const Duration(milliseconds: 100);

  final double width = 44.0;
  final double height = 24.0;
  final double ballPadding = 4.0;

  double get ballSize => height - (ballPadding * 2);

  late bool isChecked;
  late Color switchColor;
  late Color switchBallColor;
  late double switchLeft;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  void _updateSwitchState(BuildContext context) {
    if (isChecked) {
      switchColor = context.brands.beatOrange6;
      switchBallColor = context.brands.beatOrange1;
      switchLeft = width - ballSize - ballPadding;
    } else {
      switchColor = context.grays.gray7;
      switchBallColor = context.grays.white;
      switchLeft = ballPadding;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateSwitchState(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onCheckChange?.call(isChecked);
      },
      child: AnimatedContainer(
        curve: Curves.decelerate,
        duration: duration,
        width: width,
        height: height,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            // 배경 트랙
            AnimatedContainer(
              duration: duration,
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: switchColor,
                borderRadius: BorderRadius.all(Radius.circular(height / 2)),
              ),
            ),
            // 토글 볼
            renderSwitchBall(),
          ],
        ),
      ),
    );
  }

  Widget renderSwitchBall() {
    return AnimatedPositioned(
      duration: duration,
      top: ballPadding,
      left: switchLeft,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 반지름 계산 필요 없이 완벽한 원형 생성
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xff000000,
              ).withAlpha(30), // 그림자 색상을 자연스러운 검은색 투명도로 변경
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: switchBallColor,
        ),
      ),
    );
  }
}
