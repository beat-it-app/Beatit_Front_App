import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authTokenStorageProvider = Provider<AuthTokenStorage>((ref) {
  return AuthTokenStorage(FlutterSecureStorage());
});

class AuthTokenStorage {
  AuthTokenStorage(this._storage);

  static const String _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) {
    return _storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  Future<String?> readAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<void> deleteAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }
}
