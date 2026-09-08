import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_two_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/auth/widget/privacy_consent_popup.dart';
import 'package:beatit_front_app/src/domain/auth/widget/service_consent_popup.dart';
import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:flutter/material.dart';

class CloudTestPage extends StatefulWidget {
  const CloudTestPage({super.key});

  @override
  State<CloudTestPage> createState() => _CloudTestPageState();
}

class _CloudTestPageState extends State<CloudTestPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CloudFileAppbar(titleText: 'project'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(children: []),
      ),
    );
  }
}
