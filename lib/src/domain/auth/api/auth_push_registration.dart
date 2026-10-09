import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 로그인과 세션 복구 시 서버에 전달할 기기 정보를 관리한다.
/// 푸시 기능 사용 불가/권한 거부/설정 오류는 로그인 실패로 이어지지 않는다.
class AuthPushRegistration {
  AuthPushRegistration();

  static const _deviceIdKey = 'beatit_push_device_id';
  static const _storage = FlutterSecureStorage();

  StreamSubscription<String>? _tokenRefreshSubscription;
  int _listenerGeneration = 0;
  Future<void>? _firebaseInitialization;
  Future<String?>? _deviceIdFuture;

  bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  String get _platformType => Platform.isIOS ? 'IOS' : 'ANDROID';

  /// 가능한 필드는 전송하며, FCM 미지원 환경이라도 인증 필드는 유지한다.
  Future<Map<String, dynamic>> collectLoginFields() async {
    if (!_isSupportedPlatform) return const {};

    final fields = <String, dynamic>{'platformType': _platformType};
    final results = await Future.wait<String?>([
      _getDeviceIdSafely(),
      _getAppVersionSafely(),
      _getFcmTokenSafely(),
    ]);

    if (results[0] != null) fields['deviceId'] = results[0];
    if (results[1] != null) fields['appVersion'] = results[1];
    if (results[2] != null) fields['pushToken'] = results[2];

    return fields;
  }

  /// FCM 토큰이 갱신될 때 로그인된 사용자의 토큰 등록 API에 전달한다.
  Future<Map<String, dynamic>?> registrationForRefreshedToken(
    String token,
  ) async {
    if (!_isSupportedPlatform || token.trim().isEmpty) return null;

    final deviceId = await _getDeviceIdSafely();
    if (deviceId == null) return null;

    final appVersion = await _getAppVersionSafely();
    return {
      'deviceId': deviceId,
      'platformType': _platformType,
      'pushToken': token,
      if (appVersion != null) 'appVersion': appVersion,
    };
  }

  void startTokenRefreshListener(
    Future<void> Function(String token) registerToken,
  ) {
    if (!_isSupportedPlatform || _tokenRefreshSubscription != null) return;
    final generation = ++_listenerGeneration;
    unawaited(_attachTokenRefreshListener(generation, registerToken));
  }

  Future<void> _attachTokenRefreshListener(
    int generation,
    Future<void> Function(String token) registerToken,
  ) async {
    try {
      await _initializeFirebase();
      if (generation != _listenerGeneration ||
          _tokenRefreshSubscription != null) {
        return;
      }

      _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
          .listen(
            (token) {
              unawaited(_tryRegisterRefreshedToken(token, registerToken));
            },
            onError: (Object error) {
              debugPrint('[AuthPush] FCM token refresh unavailable: $error');
            },
          );
    } catch (error) {
      debugPrint('[AuthPush] FCM token listener unavailable: $error');
    }
  }

  Future<void> _tryRegisterRefreshedToken(
    String token,
    Future<void> Function(String token) registerToken,
  ) async {
    try {
      await registerToken(token);
    } catch (error) {
      // 푸시 등록 실패가 로그인 상태에 영향을 주면 안 된다.
      debugPrint('[AuthPush] FCM token update skipped: $error');
    }
  }

  Future<void> stopTokenRefreshListener() async {
    ++_listenerGeneration;
    final subscription = _tokenRefreshSubscription;
    _tokenRefreshSubscription = null;
    await subscription?.cancel();
  }

  void dispose() {
    unawaited(stopTokenRefreshListener());
  }

  Future<String?> _getDeviceIdSafely() async {
    try {
      return await (_deviceIdFuture ??= _readOrCreateDeviceId())
          .timeout(const Duration(seconds: 4));
    } catch (error) {
      _deviceIdFuture = null;
      debugPrint('[AuthPush] device ID unavailable: $error');
      return null;
    }
  }

  Future<String> _readOrCreateDeviceId() async {
    final previous = await _storage.read(key: _deviceIdKey);
    if (previous != null && previous.isNotEmpty) return previous;

    // 하드웨어 ID/광고 ID 대신 설치별로 유지되는 난수 UUID v4 사용.
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    final deviceId =
        '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';

    await _storage.write(key: _deviceIdKey, value: deviceId);
    return deviceId;
  }

  Future<String?> _getAppVersionSafely() async {
    try {
      final version = (await PackageInfo.fromPlatform()
              .timeout(const Duration(seconds: 4)))
          .version
          .trim();
      return version.isEmpty ? null : version;
    } catch (error) {
      debugPrint('[AuthPush] app version unavailable: $error');
      return null;
    }
  }

  Future<void> _initializeFirebase() {
    return _firebaseInitialization ??= _initializeFirebaseOnce();
  }

  Future<void> _initializeFirebaseOnce() async {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    } catch (_) {
      // 설정이 나중에 복구되는 경우 재시도를 허용한다.
      _firebaseInitialization = null;
      rethrow;
    }
  }

  Future<String?> _getFcmTokenSafely() async {
    try {
      await _initializeFirebase().timeout(const Duration(seconds: 8));
      final messaging = FirebaseMessaging.instance;
      // 권한 다이얼로그에서는 사용자가 직접 결정할 시간을 충분히 준다.
      final settings = await messaging.requestPermission()
          .timeout(const Duration(seconds: 30));

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[AuthPush] notification permission denied');
        return null;
      }

      if (Platform.isIOS) {
        // iOS에서는 APNs 토큰 생성 전에 FCM API를 호출하면 실패할 수 있다.
        String? apnsToken;
        for (var attempt = 0; attempt < 6; attempt++) {
          apnsToken = await messaging.getAPNSToken()
              .timeout(const Duration(seconds: 4));
          if (apnsToken != null) break;
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
        if (apnsToken == null) {
          debugPrint('[AuthPush] APNs token not available yet');
          return null;
        }
      }

      final token = (await messaging.getToken()
              .timeout(const Duration(seconds: 8)))
          ?.trim();
      return token == null || token.isEmpty ? null : token;
    } catch (error) {
      if (error is TimeoutException) _firebaseInitialization = null;
      debugPrint('[AuthPush] FCM token unavailable: $error');
      return null;
    }
  }
}
