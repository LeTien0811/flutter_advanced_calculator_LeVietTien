import 'package:advance_mobile_calculator/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  // constructor nhận themeMode
  ThemeProvider(this._themeMode);

  // Getter
  ThemeMode get themeMode => _themeMode;

  // kiểm tra xem hiện tại có phải dark mode không
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // lấy độ sáng của hệ thống
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Getter trả về ThemeData hiện tại
  ThemeData get currentTheme {
    if (_themeMode == ThemeMode.light) return lightTheme;
    if (_themeMode == ThemeMode.dark) return darkTheme;
    // nếu là system, kiểm tra hệ thống
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  // đổi theme
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    StorageService.saveThemeMode(mode);
    notifyListeners();
  }

  //  toggle nhanh
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  // Load ThemeMode từ Storage
  static Future<ThemeProvider> create() async {
    final themeMode = await StorageService.loadThemeMode();
    return ThemeProvider(themeMode);
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E1E1E),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1E1E1E),
      secondary: Color(0xFF424242),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      error: Color(0xFFFF6B6B),
      onSurface: Color(0xFF1E1E1E),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
    ),
  );

    static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF121212),
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xFF2C2C2C),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      surface: Color(0xFF2C2C2C),
      background: Color(0xFF121212),
      error: Color(0xFF4ECDC4),
      onSurface: Colors.white,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
    ),
  );
}