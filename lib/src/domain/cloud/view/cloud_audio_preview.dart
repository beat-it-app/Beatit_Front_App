import 'package:beatit_front_app/src/domain/cloud/widget/cloud_file_appbar.dart';
import 'package:flutter/material.dart';

class CloudAudioPreview extends StatefulWidget {
  const CloudAudioPreview({super.key});
  @override
  State<CloudAudioPreview> createState() => _CloudAudioPreviewState();
}

class _CloudAudioPreviewState extends State<CloudAudioPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CloudFileAppbar(titleText: 'project'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(children: []),
      ),
    );
  }
}
