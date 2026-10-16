import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// UI 확인용 로딩 화면. 외부에서 제공한 전환 동작이 성공했을 때만 true를 반환한다.
/// 실제 팀 변경 API는 여기에서 직접 호출하지 않는다.
class AlarmLoadingPage extends StatefulWidget {
  const AlarmLoadingPage({
    super.key,
    required this.teamName,
    required this.teamId,
    this.onSwitchTeam,
  });

  final String teamName;
  final int teamId;
  final Future<bool> Function()? onSwitchTeam;

  @override
  State<AlarmLoadingPage> createState() => _AlarmLoadingPageState();
}

class _AlarmLoadingPageState extends State<AlarmLoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _switchTeam());
  }

  Future<void> _switchTeam() async {
    bool succeeded = false;
    try {
      if (widget.onSwitchTeam == null) {
        // 알림 API/팀 전환 연동 전: 로딩만 미리 볼 수 있다.
        await Future<void>.delayed(const Duration(milliseconds: 1100));
      } else {
        succeeded = await widget.onSwitchTeam!();
      }
    } catch (_) {
      succeeded = false;
    }

    if (mounted) Navigator.of(context).pop(succeeded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/loading_mark.png', width: 200, height: 190),
            const SizedBox(height: AppSpacing.x40),
            Text(
              "'${widget.teamName}' 페이지로\n이동 중이에요 ...",
              textAlign: TextAlign.center,
              style: FontStyles.bold22.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x40),
            SizedBox(
              width: 220,
              child: LinearProgressIndicator(
                minHeight: 4,
                color: context.brands.beatOrange1,
                backgroundColor: context.grays.gray7,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
