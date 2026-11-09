// lib/src/core/utils/platform_media_image_saver.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:background_downloader/background_downloader.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

/// 클라우드에서 사용하던 플랫폼별 이미지 저장 정책을 재사용한다.
/// Android: MediaStore/Pictures에 직접 저장.
/// iOS: 공유 시트를 열어 사용자가 '이미지 저장'을 선택하도록 한다.
enum PlatformImageSaveOutcome { savedToGallery, shared }

class PlatformMediaImageSaveException implements Exception {
  const PlatformMediaImageSaveException(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract final class PlatformMediaImageSaver {
  /// 앱이 직접 만든 PNG 바이트를 임시 파일로 만든 뒤 플랫폼 저장을 수행한다.
  /// 외부 저장 후 임시 디렉터리는 정리한다.
  static Future<PlatformImageSaveOutcome> savePngBytes({
    required Uint8List bytes,
    required String fileName,
    Rect? sharePositionOrigin,
  }) async {
    if (bytes.length < 8 ||
        bytes[0] != 0x89 ||
        bytes[1] != 0x50 ||
        bytes[2] != 0x4e ||
        bytes[3] != 0x47 ||
        bytes[4] != 0x0d ||
        bytes[5] != 0x0a ||
        bytes[6] != 0x1a ||
        bytes[7] != 0x0a) {
      throw const PlatformMediaImageSaveException('생성된 데이터가 유효한 PNG가 아닙니다.');
    }

    final directory = await Directory.systemTemp.createTemp('beatit_setlist_');
    final safeName = _safeFileName(fileName);
    final pngName = safeName.toLowerCase().endsWith('.png')
        ? safeName
        : '$safeName.png';
    final file = File('${directory.path}${Platform.pathSeparator}$pngName');

    try {
      await file.writeAsBytes(bytes, flush: true);
      return await saveImageFile(
        filePath: file.path,
        fileName: pngName,
        mimeType: 'image/png',
        sharePositionOrigin: sharePositionOrigin,
      );
    } finally {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  }

  /// 클라우드가 내려받은 이미지와 공연에서 생성한 PNG가 공유하는 저장 경로.
  static Future<PlatformImageSaveOutcome> saveImageFile({
    required String filePath,
    required String fileName,
    String? mimeType,
    Rect? sharePositionOrigin,
  }) async {
    if (Platform.isAndroid) {
      return _saveToAndroidGallery(filePath, mimeType);
    }

    if (Platform.isIOS) {
      final result = await SharePlus.instance.share(
        ShareParams(
          title: fileName,
          files: [XFile(filePath, mimeType: mimeType)],
          sharePositionOrigin: sharePositionOrigin ?? _defaultShareOrigin(),
        ),
      );
      if (result.status == ShareResultStatus.dismissed) {
        throw const PlatformMediaImageSaveException('이미지 공유를 취소했습니다.');
      }
      if (result.status == ShareResultStatus.unavailable) {
        throw const PlatformMediaImageSaveException('iOS 공유 메뉴를 사용할 수 없습니다.');
      }
      // 공유 시트 완료와 사진 앱 실제 저장은 다르므로 savedToGallery로 표시하지 않는다.
      return PlatformImageSaveOutcome.shared;
    }

    throw const PlatformMediaImageSaveException('지원되지 않는 기기입니다.');
  }

  static Future<PlatformImageSaveOutcome> _saveToAndroidGallery(
    String filePath,
    String? mimeType,
  ) async {
    final downloader = FileDownloader();
    String? result;
    Object? firstError;

    // Android 10+는 일반적으로 MediaStore에 별도 권한 없이 쓸 수 있으므로
    // 클라우드와 동일하게 우선 저장을 시도한다.
    try {
      result = await downloader.moveFileToSharedStorage(
        filePath,
        SharedStorage.images,
        mimeType: mimeType,
      );
    } catch (error) {
      firstError = error;
      debugPrint('[공통 이미지 저장] Android 1차 저장 실패: $error');
    }
    if (result != null) return PlatformImageSaveOutcome.savedToGallery;

    // 오래된 Android에서 권한이 필요한 경우에만 요청 후 한 번 더 시도한다.
    final permissions = downloader.permissions;
    var status = await permissions.status(PermissionType.androidSharedStorage);
    if (status != PermissionStatus.granted) {
      status = await permissions.request(PermissionType.androidSharedStorage);
    }
    if (status != PermissionStatus.granted) {
      throw PlatformMediaImageSaveException(
        firstError == null
            ? 'Android 사진 저장에 실패했습니다. 저장소 권한을 확인해주세요.'
            : 'Android 사진 저장에 실패했습니다: $firstError',
      );
    }

    try {
      result = await downloader.moveFileToSharedStorage(
        filePath,
        SharedStorage.images,
        mimeType: mimeType,
      );
    } catch (error) {
      throw PlatformMediaImageSaveException('Android 갤러리 저장 실패: $error');
    }
    if (result == null) {
      throw const PlatformMediaImageSaveException('Android 갤러리에 이미지를 저장하지 못했습니다.');
    }
    return PlatformImageSaveOutcome.savedToGallery;
  }

  static Rect _defaultShareOrigin() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return const Rect.fromLTWH(0, 0, 1, 1);
    final view = views.first;
    return Rect.fromLTWH(
      view.physicalSize.width / view.devicePixelRatio / 2,
      view.physicalSize.height / view.devicePixelRatio / 2,
      1,
      1,
    );
  }

  static String _safeFileName(String name) {
    final clean = name.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return clean.isEmpty ? 'beatit_setlist' : clean;
  }
}
