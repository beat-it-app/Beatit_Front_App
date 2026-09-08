import 'package:beatit_front_app/popup_test_page.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_create_page.dart';
import 'package:beatit_front_app/src/domain/post/view/poll_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_create_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_detail_page.dart';
import 'package:beatit_front_app/src/domain/post/view/post_main_page.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_audio_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_main_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signup_select_page.dart';
import 'package:beatit_front_app/src/app.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/find_id_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/reset_password_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/verify_password_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/auth/signup_page.dart';
import 'package:beatit_front_app/src/domain/auth/view/profile/complete_signup_page.dart';
<<<<<<< HEAD
import 'package:beatit_front_app/src/domain/cal/view/cal_main_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_create_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_detail_page.dart';
import 'package:beatit_front_app/src/domain/meetit/view/meetit_edit_page.dart';
=======
import 'package:beatit_front_app/src/domain/cloud/view/cloud_test_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_update_page.dart';
>>>>>>> develop
import 'package:beatit_front_app/src/domain/team/view/team_create_start_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_create_success_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_join_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_update_page.dart';
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
      home: SignupSelectPage(),
    );
  }
}
