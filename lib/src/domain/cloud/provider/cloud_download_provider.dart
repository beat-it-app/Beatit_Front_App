import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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
    this.successMessage,
  });

  final bool isDownloading;
  final String? currentFileName;
  final double currentProgress;
  final int completedCount;
  final int totalCount;
  final String? errorMessage;

  /// 공유 시트를 열었는지, 또는 Android 저장소에 실제 저장되었는지 구분합니다.
  final String? successMessage;

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
    String? successMessage,
    bool clearCurrentFileName = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
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
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
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
          // 공유 대상 앱에 넘기기 전까지만 필요하므로 앱 임시 디렉터리를 이용합니다.
          baseDirectory: BaseDirectory.temporary,
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

        // iOS는 시스템 공유 시트에서 사용자가 저장할 위치를 선택합니다.
        // Android는 공유 시트 없이 사진→갤러리, 일반 파일→Downloads로 저장합니다.
        final message = await _shareOrSave(task, file, fileName);

        state = state.copyWith(
          currentProgress: 1.0,
          completedCount: index + 1,
          successMessage: message,
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

  Future<String> _shareOrSave(
    DownloadTask task,
    CloudDownloadRequest file,
    String fileName,
  ) async {
    // Android에는 iOS의 사진/파일 저장 메뉴가 공통으로 제공되지 않으므로
    // 공유 시트를 거치지 않고 플랫폼 공유 저장소로 직접 저장합니다.
    if (Platform.isAndroid) {
      return _saveToAndroidStorage(task, file, fileName);
    }

    if (Platform.isIOS) {
      try {
        final filePath = await task.filePath();
        final result = await SharePlus.instance.share(
          ShareParams(
            title: fileName,
            files: [XFile(filePath, mimeType: file.mimeType)],
            sharePositionOrigin: _sharePositionOrigin(),
          ),
        );

        // 공유 시트에서 취소한 것은 저장 완료로 보고하지 않습니다.
        if (result.status == ShareResultStatus.dismissed) {
          throw const CloudDownloadException('공유가 취소되었습니다.');
        }
        return result.status == ShareResultStatus.unavailable
            ? '파일 다운로드가 완료되었습니다. 저장 여부를 확인해주세요.'
            : '파일 다운로드가 완료되었습니다.';
      } on CloudDownloadException {
        rethrow;
      } catch (_) {
        throw const CloudDownloadException('공유 창을 열지 못했습니다.');
      }
    }

    // 데스크톱 등 기타 플랫폼은 기존 다운로드 경로를 사용합니다.
    await _ensureSharedStoragePermission();
    final location = await FileDownloader().moveToSharedStorage(
      task,
      SharedStorage.downloads,
      mimeType: file.mimeType,
    );
    if (location == null) {
      throw CloudDownloadException('다운로드 폴더에 저장하지 못했습니다: $fileName');
    }
    return 'Downloads 폴더에 저장했습니다.';
  }

  Rect _sharePositionOrigin() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return const Rect.fromLTWH(0, 0, 1, 1);
    final view = views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    final height = view.physicalSize.height / view.devicePixelRatio;
    return Rect.fromLTWH(width / 2, height / 2, 1, 1);
  }

  Future<String> _saveToAndroidStorage(
    DownloadTask task,
    CloudDownloadRequest file,
    String fileName,
  ) async {
    final isImage = _isPhoto(fileName, file.mimeType);
    final destination = isImage ? SharedStorage.images : SharedStorage.downloads;
    // Android 10+는 일반적으로 별도의 저장소 권한 요청 없이
    // MediaStore로 저장할 수 있습니다. 먼저 저장을 시도하고 필요한 경우만 요청합니다.
    String? savedLocation;
    try {
      savedLocation = await FileDownloader().moveToSharedStorage(
        task,
        destination,
        mimeType: file.mimeType,
      );
    } catch (_) {
      // 예전 Android에서 권한 부족 시 아래에서 요청 후 재시도합니다.
    }
    if (savedLocation == null) {
      await _ensureSharedStoragePermission();
      savedLocation = await FileDownloader().moveToSharedStorage(
        task,
        destination,
        mimeType: file.mimeType,
      );
    }
    if (savedLocation == null) {
      throw CloudDownloadException(
        isImage
            ? '사진 앱에 파일을 저장하지 못했습니다: $fileName'
            : 'Downloads 폴더에 파일을 저장하지 못했습니다: $fileName',
      );
    }
    return isImage ? '이미지 저장이 완료되었습니다.' : '파일 다운로드가 완료되었습니다.';
  }

  bool _isPhoto(String name, String? mimeType) {
    // SVG 등 사진 앱에서 지원하지 않을 수 있는 이미지 형식은 일반 파일로 취급합니다.
    const extensions = <String>{
      'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp', 'avif',
    };
    final lowerName = name.toLowerCase();
    final ext = lowerName.contains('.') ? lowerName.split('.').last : '';
    if (extensions.contains(ext)) return true;
    final mime = mimeType?.toLowerCase().split(';').first.trim();
    return mime != null &&
        mime.startsWith('image/') &&
        mime != 'image/svg+xml';
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
        '기기에 파일을 저장하려면 저장소 권한이 필요합니다.',
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
