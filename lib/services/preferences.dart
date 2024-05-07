import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _getKey(String key) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'default';
    return '$userId-$key';
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final userKey = _getKey(key);
    return _prefs?.getBool(userKey) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    final userKey = _getKey(key);
    return await _prefs?.setBool(userKey, value) ?? false;
  }

  int getInt(String key, {int defaultValue = 0}) {
    final userKey = _getKey(key);
    return _prefs?.getInt(userKey) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    final userKey = _getKey(key);
    return await _prefs?.setInt(userKey, value) ?? false;
  }

  String getString(String key, {String defaultValue = ''}) {
    final userKey = _getKey(key);
    return _prefs?.getString(userKey) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    final userKey = _getKey(key);
    return await _prefs?.setString(userKey, value) ?? false;
  }
}
