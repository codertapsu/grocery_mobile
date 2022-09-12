import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageController {
  final _storage = const FlutterSecureStorage();

  Future<void> write(String key, dynamic value) {
    return _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<Map<String, String>> readAll(String key, dynamic value) {
    return _storage.readAll();
  }
}
