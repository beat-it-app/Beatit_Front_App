import 'dart:io';

import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/theme/theme_mode_provider.dart'; // 💡 테마 모드 프로바이더 import
import 'package:beatit_front_app/src/domain/auth/view/auth/auth_splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    } catch (error) {
      debugPrint('[Firebase] initialization failed: $error');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

// 💡 StatelessWidget에서 ConsumerWidget으로 변경
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 화면 설정에서 변경되는 ThemeMode를 실시간 구독
    final currentThemeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Beatit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: currentThemeMode,
      // 👈 고정값(ThemeMode.system) 대신 프로바이더 상태 바인딩
      home: const AuthSplashPage(),
    );
  }
}
