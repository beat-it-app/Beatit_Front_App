import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:flutter/material.dart';

/// 다른 팀 알림을 눌렀을 때, 서버의 팀 변경 요청 동안만 표시한다.
class AlarmLoadingPage extends StatefulWidget {
  const AlarmLoadingPage({
    super.key,
    required this.teamName,
    required this.switchTeam,
  });

  final String teamName;
  final Future<AlarmClickResponse?> Function() switchTeam;

  @override
  State<AlarmLoadingPage> createState() => _AlarmLoadingPageState();
}

class _AlarmLoadingPageState extends State<AlarmLoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _switch());
  }

  Future<void> _switch() async {
    final result = await widget.switchTeam();
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/loading_mark.png', width: 200, height: 190),
              const SizedBox(height: AppSpacing.x40),
              Text(
                "'${widget.teamName}' 페이지로\n이동 중이에요...",
                textAlign: TextAlign.center,
                style: FontStyles.bold22.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: AppSpacing.x40),
              SizedBox(
                width: 220,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  color: context.brands.beatOrange1,
                  backgroundColor: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
