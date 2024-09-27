import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'authToken', value: token); // No encryption
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'authToken'); // No decryption
  }



  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: 'authToken');
    } catch (e) {
      throw Exception('Failed to delete token');
    }
  }
}