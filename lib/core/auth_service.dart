import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'authToken', value: token);
  }
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'authToken');
  }
}