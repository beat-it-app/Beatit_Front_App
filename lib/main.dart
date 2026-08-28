import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/find_id_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/reset_password_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/verify_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/theme/app_theme.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signup_select_page.dart';

void main() {
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
      home: FindIdPage(),
    );
  }
}
