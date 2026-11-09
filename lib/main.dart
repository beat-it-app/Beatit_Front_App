import 'dart:io';

import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/core/theme/theme_mode_provider.dart'; // 💡 테마 모드 프로바이더 import
import 'package:beatit_front_app/src/domain/auth/api/kakao_auth_client.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/auth_splash_page.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
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

  if (KakaoAuthClient.nativeAppKey.isNotEmpty) {
    await KakaoSdk.init(nativeAppKey: KakaoAuthClient.nativeAppKey);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Beatit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: currentThemeMode,
      home: const AuthSplashPage(),
    );
  }
}
