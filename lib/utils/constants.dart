class AppConstants {
  //chuẩn hóa
  static const Map<String, String> symbolReplacements = {
    '×': '*',
    '÷': '/',
    'Π': 'pi',
    'e': 'e',
    'sin(': 'sind(',
    'cos(': 'cosd(',
    'tan(': 'tand(',
  };

  // danh sách các toán tử Bitwise để kiểm tra
  static const List<String> programmerOperators = [
    'AND', 'OR', 'XOR', 'NOT', '<<', '>>'
  ];
}