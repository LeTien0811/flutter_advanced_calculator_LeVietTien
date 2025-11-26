import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyHistory = 'calc_history';
  static const String keyTheme = 'app_theme';
  static const String keyMode = 'calc_mode';
  static const String keyAngleMode = 'angle_mode';

  static const String keyPrecision = 'setting_precision';
  static const String keyHaptic = 'setting_haptic';
  static const String keySound = 'setting_sound';
  static const String keyHistorySize = 'setting_history_size';

  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> loadString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> loadBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<int?> loadInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // history
  static Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keyHistory, history);
  }

  static Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyHistory) ?? [];
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    // chuyển enum thành chuỗi
    await saveString(keyTheme, mode.toString());
  }

  static Future<ThemeMode> loadThemeMode() async {
    final String? themeStr = await loadString(keyTheme);

    if (themeStr == ThemeMode.light.toString()) {
      return ThemeMode.light;
    } else if (themeStr == ThemeMode.dark.toString()) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }
}