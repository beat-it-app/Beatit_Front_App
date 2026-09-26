import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_audio_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_video_preview.dart';
import 'package:beatit_front_app/src/domain/etc/view/picture_preview_page.dart';
import 'package:flutter/material.dart';

class ScheduleFilePreviewPage extends StatelessWidget {
  const ScheduleFilePreviewPage({
    super.key,
    required this.fileName,
    required this.source,
    this.fileSize,
  });

  final String fileName;
  final String source;
  final String? fileSize;

  @override
  Widget build(BuildContext context) {
    final extension = _extension(fileName);

    if (_imageExtensions.contains(extension)) {
      return PicturePreviewPage(imageUrls: [source]);
    }

    final previewUri = _toUri(source);
    if (previewUri == null) {
      return _UnsupportedScheduleFilePreview(fileName: fileName);
    }

    final item = CloudFilePreviewItem(
      name: fileName,
      uploadedAt: '',
      uploaderName: '',
      type: _cloudType(extension),
      iconPath: 'assets/icons/cloud/file.svg',
      previewUri: previewUri,
      sizeLabel: fileSize,
    );

    if (_audioExtensions.contains(extension)) {
      return CloudAudioPreview(
        folderName: '일정 파일',
        files: [item],
        onDeletePressed: (_) => _showUnavailable(context),
        onMovePressed: (_) => _showUnavailable(context),
        onDownloadPressed: (_) => _showUnavailable(context),
      );
    }

    if (_videoExtensions.contains(extension)) {
      return CloudVideoPreview(
        folderName: '일정 파일',
        files: [item],
        onDeletePressed: (_) => _showUnavailable(context),
        onMovePressed: (_) => _showUnavailable(context),
        onDownloadPressed: (_) => _showUnavailable(context),
      );
    }

    if (extension == 'pdf') {
      return CloudFilePreview(
        folderName: '일정 파일',
        files: [item],
        onDeletePressed: (_) => _showUnavailable(context),
        onMovePressed: (_) => _showUnavailable(context),
        onDownloadPressed: (_) => _showUnavailable(context),
      );
    }

    return _UnsupportedScheduleFilePreview(fileName: fileName);
  }

  Uri? _toUri(String source) {
    if (source.trim().isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(source);
    if (parsed != null &&
        (parsed.scheme == 'http' ||
            parsed.scheme == 'https' ||
            parsed.scheme == 'file')) {
      return parsed;
    }

    return Uri.file(source);
  }

  CloudPreviewFileType _cloudType(String extension) {
    if (_audioExtensions.contains(extension)) {
      return CloudPreviewFileType.audio;
    }
    if (_videoExtensions.contains(extension)) {
      return CloudPreviewFileType.video;
    }
    return CloudPreviewFileType.document;
  }

  String _extension(String name) {
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) {
      return '';
    }
    return name.substring(index + 1).toLowerCase();
  }

  void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('일정 첨부 파일에서는 해당 기능을 지원하지 않습니다.')),
    );
  }

  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',
  };

  static const Set<String> _audioExtensions = {
    'mp3',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'flac',
  };

  static const Set<String> _videoExtensions = {
    'mp4',
    'mov',
    'm4v',
    'avi',
    'mkv',
    'webm',
  };
}

class _UnsupportedScheduleFilePreview extends StatelessWidget {
  const _UnsupportedScheduleFilePreview({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopAppBar.backTitle(
        title: fileName,
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: const Center(
        child: Text('이 파일 형식은 앱에서 미리보기를 지원하지 않습니다.'),
      ),
    );
  }
}
