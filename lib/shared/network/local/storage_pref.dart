import 'package:shared_preferences/shared_preferences.dart';

class StoragePref {
  static SharedPreferences _preferences;

  static getInstance() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static dynamic getValue(String key) {
    return _preferences.get(key);
  }

  static Future<bool> setValue(String key, var value) async {
    switch (value.runtimeType) {
      case String:
        return await _preferences.setString(key, value);
      case int:
        return await _preferences.setInt(key, value);
      case double:
        return await _preferences.setDouble(key, value);
      case bool:
        return await _preferences.setBool(key, value);
    }
    return false;
  }

  static Future<bool> removeValue(String key) async {
    return await _preferences.remove(key);
  }
}
