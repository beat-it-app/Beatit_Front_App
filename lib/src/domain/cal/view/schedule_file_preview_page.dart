import 'package:beatit_front_app/src/domain/cloud/provider/cloud_download_provider.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_audio_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_image_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_other_file_preview.dart';
import 'package:beatit_front_app/src/domain/cloud/view/cloud_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 일정 첨부 파일도 Cloud Preview UI를 그대로 재사용한다.
///
/// 일정에서는 Cloud의 관리 기능(삭제/이동/폴더 관리)이 필요하지 않으므로
/// 해당 callback을 전달하지 않는다. 파일 종류에 따라 새로운 Preview Page를
/// 만들지 않고 기존 Cloud Preview 중 하나로만 분기한다.
class ScheduleFilePreviewPage extends ConsumerWidget {
  const ScheduleFilePreviewPage({
    super.key,
    required this.fileName,
    required this.source,
    this.fileSize,
    this.contextTitle,
    this.fileId,
  });

  final String fileName;
  final String source;
  final String? fileSize;
  final int? fileId;

  /// Cloud에서는 folderName으로 사용하는 위치다.
  /// 일정에서는 일정 제목을 전달하고, 없으면 빈 문자열로 사용한다.
  final String? contextTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewUri = _toUri(source);
    final previewType = _previewType(fileName);

    final item = CloudFilePreviewItem(
      itemId: fileId,
      name: fileName,
      uploadedAt: '',
      uploaderName: '',
      type: previewType,
      iconPath: 'assets/icons/cloud/file.svg',
      previewUri: previewUri,
      sizeLabel: fileSize,
    );

    final title = contextTitle?.trim() ?? '';
    final files = <CloudFilePreviewItem>[item];
    // Cloud 미리보기 UI는 다운로드 callback 유무로 버튼을 표시한다.
    // 일정 첨부 파일의 CDN URL을 Cloud의 다운로드 저장 흐름에 전달한다.
    final onDownload = previewUri != null &&
            (previewUri.scheme == 'http' || previewUri.scheme == 'https')
        ? (CloudFilePreviewItem file) => _download(context, ref, file)
        : null;

    switch (previewType) {
      case CloudPreviewFileType.image:
        return CloudImagePreview(
          folderName: title,
          files: files,
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );

      case CloudPreviewFileType.audio:
        return CloudAudioPreview(
          folderName: title,
          files: files,
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );

      case CloudPreviewFileType.video:
        return CloudVideoPreview(
          folderName: title,
          files: files,
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );

      case CloudPreviewFileType.document:
        return CloudFilePreview(
          folderName: title,
          files: files,
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );

      case CloudPreviewFileType.other:
        return CloudOtherFilePreview(
          folderName: title,
          files: files,
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );

      case CloudPreviewFileType.link:
        // 일정 첨부 파일에는 링크 타입이 없으므로 현재 분기에서는 사용하지 않는다.
        // 확장자가 없는 파일도 other로 처리한다.
        return CloudOtherFilePreview(
          folderName: title,
          files: [item.copyWithType(CloudPreviewFileType.other)],
          canManage: false,
          onDownloadPressed: onDownload,
          onOpenExternalPressed: previewUri == null
              ? null
              : (_) => _openExternal(context, previewUri),
        );
    }
  }

  Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    CloudFilePreviewItem file,
  ) async {
    if (ref.read(cloudDownloadProvider).isDownloading) {
      _showDownloadMessage(context, '다른 파일을 다운로드하고 있습니다.');
      return;
    }

    final uri = file.previewUri;
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      _showDownloadMessage(context, '다운로드 주소를 확인할 수 없습니다.');
      return;
    }

    final success = await ref.read(cloudDownloadProvider.notifier).downloadFiles([
      CloudDownloadRequest(
        // 생성/수정 화면의 로컬 파일 미리보기와 호환되는 ID 대체값입니다.
        itemId: file.itemId ?? file.name.hashCode,
        fileName: file.name,
        fileUrl: uri.toString(),
        mimeType: file.mimeType,
      ),
    ]);
    if (!context.mounted) return;

    final result = ref.read(cloudDownloadProvider);
    _showDownloadMessage(
      context,
      success
          ? result.successMessage ?? '다운로드를 완료했습니다.'
          : result.errorMessage ?? '파일 다운로드에 실패했습니다.',
    );
  }

  void _showDownloadMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Uri? _toUri(String source) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return null;

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null &&
        (parsed.scheme == 'http' ||
            parsed.scheme == 'https' ||
            parsed.scheme == 'file')) {
      return parsed;
    }

    return Uri.file(trimmed);
  }

  CloudPreviewFileType _previewType(String name) {
    final extension = _extension(name);

    if (_imageExtensions.contains(extension)) {
      return CloudPreviewFileType.image;
    }
    if (_audioExtensions.contains(extension)) {
      return CloudPreviewFileType.audio;
    }
    if (_videoExtensions.contains(extension)) {
      return CloudPreviewFileType.video;
    }
    if (extension == 'pdf') {
      return CloudPreviewFileType.document;
    }
    return CloudPreviewFileType.other;
  }

  String _extension(String name) {
    final index = name.lastIndexOf('.');
    if (index < 0 || index == name.length - 1) {
      return '';
    }
    return name.substring(index + 1).toLowerCase();
  }

  Future<void> _openExternal(BuildContext context, Uri uri) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        _showOpenError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showOpenError(context);
      }
    }
  }

  void _showOpenError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('파일을 열 수 없습니다. 다시 시도해주세요.')));
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

extension on CloudFilePreviewItem {
  CloudFilePreviewItem copyWithType(CloudPreviewFileType type) {
    return CloudFilePreviewItem(
      itemId: itemId,
      name: name,
      uploadedAt: uploadedAt,
      uploaderName: uploaderName,
      type: type,
      iconPath: iconPath,
      previewUri: previewUri,
      sizeLabel: sizeLabel,
      mimeType: mimeType,
    );
  }
}
