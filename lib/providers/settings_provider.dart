import 'package:advance_mobile_calculator/services/storage_service.dart';
import 'package:flutter/material.dart';

enum AngleMode { degrees, radians }

class SettingsProvider extends ChangeNotifier {
  AngleMode _angleMode = AngleMode.degrees;
  int _decimalPrecision = 2; // Mặc định 2 số thập phân
  bool _hapticFeedback = true;
  bool _soundEffects = false;
  int _historySize = 50;

  AngleMode get angleMode => _angleMode;
  int get decimalPrecision => _decimalPrecision;
  bool get hapticFeedback => _hapticFeedback;
  bool get soundEffects => _soundEffects;
  int get historySize => _historySize;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load Angle Mode
    final angleStr = await StorageService.loadString(StorageService.keyAngleMode);
    if (angleStr == 'rad') _angleMode = AngleMode.radians;

    // Load Precision
    _decimalPrecision = await StorageService.loadInt(StorageService.keyPrecision) ?? 2;

    // Load Haptic
    _hapticFeedback = await StorageService.loadBool(StorageService.keyHaptic) ?? true;

    // Load Sound
    _soundEffects = await StorageService.loadBool(StorageService.keySound) ?? false;

    // Load History Size
    _historySize = await StorageService.loadInt(StorageService.keyHistorySize) ?? 50;

    notifyListeners();
  }

  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    StorageService.saveString(StorageService.keyAngleMode, mode == AngleMode.degrees ? 'deg' : 'rad');
    notifyListeners();
  }

  void setPrecision(int value) {
    _decimalPrecision = value;
    StorageService.saveInt(StorageService.keyPrecision, value);
    notifyListeners();
  }

  void setHaptic(bool value) {
    _hapticFeedback = value;
    StorageService.saveBool(StorageService.keyHaptic, value);
    notifyListeners();
  }

  void setSound(bool value) {
    _soundEffects = value;
    StorageService.saveBool(StorageService.keySound, value);
    notifyListeners();
  }

  void setHistorySize(int value) {
    _historySize = value;
    StorageService.saveInt(StorageService.keyHistorySize, value);
    notifyListeners();
  }
}