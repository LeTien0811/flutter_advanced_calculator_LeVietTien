class CalculatorLogic {
  static double calculateProgrammerMath(String expr) {
    try {
      // tách toán tử và toán hạng
      // xóa khoảng trắng thừa nếu có
      List<String> parts = expr.trim().split(' ');

      // trường hợp 2 ngôi
      if (parts.length >= 3) {
        int a = _parseSmart(parts[0]);
        String op = parts[1];
        int b = _parseSmart(parts[2]);

        switch (op) {
          case 'AND': return (a & b).toDouble();
          case 'OR': return (a | b).toDouble();
          case 'XOR': return (a ^ b).toDouble();
          case '<<': return (a << b).toDouble();
          case '>>': return (a >> b).toDouble();
        }
      }
      // trường hợp 1 ngôi
      else if (parts.length >= 2 && parts[0] == 'NOT') {
        int a = _parseSmart(parts[1]);
        return (~a).toDouble();
      }

      return double.nan;
    } catch (e) {
      print("Programmer Math Error: $e");
      return double.nan;
    }
  }

  static int _parseSmart(String text) {
    // 1. Nếu có tiền tố 0x -> Parse Hex
    if (text.startsWith('0x')) return int.parse(text);

    // 2. Nếu chứa ký tự A-F -> Parse Hex
    if (RegExp(r'[A-F]').hasMatch(text)) {
      return int.parse(text, radix: 16);
    }

    // 3. Mặc định thử Parse Decimal, nếu lỗi thử Parse Hex (cho trường hợp số '10' ở hệ Hex)
    try {
      return int.parse(text);
    } catch (_) {
      try {
        return int.parse(text, radix: 16);
      } catch (e) {
        return 0;
      }
    }
  }
}