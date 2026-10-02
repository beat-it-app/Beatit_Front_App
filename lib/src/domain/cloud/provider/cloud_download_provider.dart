import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudDownloadProvider =
    NotifierProvider<CloudDownloadNotifier, CloudDownloadState>(
      CloudDownloadNotifier.new,
    );

class CloudDownloadRequest {
  const CloudDownloadRequest({
    required this.itemId,
    required this.fileName,
    required this.fileUrl,
    this.mimeType,
  });

  final int itemId;
  final String fileName;
  final String fileUrl;
  final String? mimeType;
}

class CloudDownloadState {
  const CloudDownloadState({
    this.isDownloading = false,
    this.currentFileName,
    this.currentProgress = 0.0,
    this.completedCount = 0,
    this.totalCount = 0,
    this.errorMessage,
  });

  final bool isDownloading;
  final String? currentFileName;
  final double currentProgress;
  final int completedCount;
  final int totalCount;
  final String? errorMessage;

  double? get overallProgress {
    if (!isDownloading || totalCount <= 0) return null;
    final progress = currentProgress.clamp(0.0, 1.0);
    return ((completedCount + progress) / totalCount).clamp(0.0, 1.0);
  }

  CloudDownloadState copyWith({
    bool? isDownloading,
    String? currentFileName,
    double? currentProgress,
    int? completedCount,
    int? totalCount,
    String? errorMessage,
    bool clearCurrentFileName = false,
    bool clearError = false,
  }) {
    return CloudDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      currentFileName: clearCurrentFileName
          ? null
          : currentFileName ?? this.currentFileName,
      currentProgress: currentProgress ?? this.currentProgress,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CloudDownloadNotifier extends Notifier<CloudDownloadState> {
  static const String _temporaryDirectory = 'beatit_cloud_downloads';

  @override
  CloudDownloadState build() => const CloudDownloadState();

  Future<bool> downloadFiles(List<CloudDownloadRequest> files) async {
    if (state.isDownloading || files.isEmpty) {
      return false;
    }

    state = CloudDownloadState(
      isDownloading: true,
      totalCount: files.length,
    );

    try {
      for (var index = 0; index < files.length; index += 1) {
        final file = files[index];
        final fileName = _safeFileName(file.fileName, file.itemId);

        state = state.copyWith(
          currentFileName: fileName,
          currentProgress: 0.0,
          completedCount: index,
          clearError: true,
        );

        final task = DownloadTask(
          taskId: 'cloud_${file.itemId}_${DateTime.now().microsecondsSinceEpoch}',
          url: file.fileUrl,
          filename: fileName,
          directory: _temporaryDirectory,
          baseDirectory: BaseDirectory.applicationDocuments,
          updates: Updates.statusAndProgress,
          retries: 2,
          allowPause: true,
          displayName: fileName,
        );

        final result = await FileDownloader().download(
          task,
          onProgress: (progress) {
            state = state.copyWith(
              currentProgress: progress.clamp(0.0, 1.0),
            );
          },
        );

        if (result.status != TaskStatus.complete) {
          throw CloudDownloadException(
            '다운로드에 실패했습니다: $fileName',
          );
        }

        await _ensureSharedStoragePermission();

        final savedLocation = await FileDownloader().moveToSharedStorage(
          task,
          SharedStorage.downloads,
          mimeType: file.mimeType,
        );

        if (savedLocation == null) {
          throw CloudDownloadException(
            '다운로드 폴더에 파일을 저장하지 못했습니다: $fileName',
          );
        }

        state = state.copyWith(
          currentProgress: 1.0,
          completedCount: index + 1,
        );
      }

      state = state.copyWith(
        isDownloading: false,
        currentProgress: 1.0,
        completedCount: files.length,
        clearCurrentFileName: true,
        clearError: true,
      );
      return true;
    } catch (error) {
      final message = error is CloudDownloadException
          ? error.message
          : '파일 다운로드 중 오류가 발생했습니다.';

      state = state.copyWith(
        isDownloading: false,
        currentProgress: 0.0,
        errorMessage: message,
        clearCurrentFileName: true,
      );
      return false;
    }
  }

  Future<void> _ensureSharedStoragePermission() async {
    if (!Platform.isAndroid) {
      return;
    }

    var status = await FileDownloader().permissions.status(
      PermissionType.androidSharedStorage,
    );

    if (status == PermissionStatus.granted) {
      return;
    }

    status = await FileDownloader().permissions.request(
      PermissionType.androidSharedStorage,
    );

    if (status != PermissionStatus.granted) {
      throw const CloudDownloadException(
        'Downloads 폴더에 저장하려면 저장소 권한이 필요합니다.',
      );
    }
  }

  String _safeFileName(String rawName, int itemId) {
    final trimmed = rawName.trim();
    final fallback = 'beatit_file_$itemId';
    if (trimmed.isEmpty) return fallback;

    final sanitized = trimmed
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+$'), '');

    return sanitized.isEmpty ? fallback : sanitized;
  }
}

class CloudDownloadException implements Exception {
  const CloudDownloadException(this.message);

  final String message;

  @override
  String toString() => message;
}
