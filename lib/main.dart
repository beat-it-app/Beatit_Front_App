import 'dart:io';

import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/auth_splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      // 네이티브 Firebase 설정 파일로 앱 시작 시 한 번 초기화한다.
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    } catch (error) {
      // Firebase 설정이 미완료여도 로그인 화면은 실행할 수 있어야 한다.
      debugPrint('[Firebase] initialization failed: $error');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beatit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const AuthSplashPage(),
    );
  }
}
