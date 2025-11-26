import 'package:advance_mobile_calculator/services/storage_service.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  int _maxHistoryLength = 50;
  List<String> _history = [];

  // Getter để các widget khác có thể đọc
  List<String> get history => _history;

  // Hàm khởi tạo để tải lịch sử đã lưu
  Future<void> init() async {
    _history = await StorageService.loadHistory();
    int? savedSize = await StorageService.loadInt('setting_history_size');
    if (savedSize != null) {
      _maxHistoryLength = savedSize;
    }
    notifyListeners();
  }

  void resizeHistory(int newSize) {
    _maxHistoryLength = newSize;

    // Nếu kích thước mới nhỏ hơn số lượng hiện tại, cần cắt bớt danh sách
    if (_history.length > newSize) {
      _history = _history.sublist(0, newSize);
      StorageService.saveHistory(_history); // Lưu lại danh sách mới đã cắt
    }

    notifyListeners();
  }

  // Thêm một mục mới vào lịch sử
  void add(String expression) {
    // Chèn vào đầu danh sách
    _history.insert(0, expression);

    // Giới hạn lịch sử ở 50 mục
    if (_history.length > _maxHistoryLength) {
      _history = _history.sublist(0, _maxHistoryLength);
    }

    // Lưu lại và thông báo cho UI
    StorageService.saveHistory(_history);
    notifyListeners();
  }

  // Xóa toàn bộ lịch sử
  void clear() {
    _history.clear();
    StorageService.saveHistory(_history); // Lưu lại danh sách rỗng
    notifyListeners();
  }
}
