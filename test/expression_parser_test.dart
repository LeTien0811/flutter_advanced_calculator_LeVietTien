import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/utils/expression_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressionParser Tests', () {
    // Test 1: Biểu thức phức tạp với độ ưu tiên toán tử
    test('Complex expression with precedence', () {
      final expression = '(5 + 3) * 2 - 4 / 2';
      final result = ExpressionParser.evaluate(expression, AngleMode.degrees);
      expect(result, 14.0);
    });

    // Test 2: Dấu ngoặc lồng nhau
    test('Nested parentheses', () {
      final expression = '((2 + 3) * (4 - 1)) / 5';
      final result = ExpressionParser.evaluate(expression, AngleMode.degrees);
      expect(result, 3.0);
    });

    // Test 3: Hàm khoa học ở chế độ Degrees
    test('Scientific calculation in Degrees mode', () {
      final expression = 'sin(90) + cos(0)'; // sin(90) = 1, cos(0) = 1
      final result = ExpressionParser.evaluate(expression, AngleMode.degrees);
      expect(result, 2.0);
    });

    // Test 4: Hàm khoa học ở chế độ Radians
    test('Scientific calculation in Radians mode', () {
      final expression = 'sin(pi/2) + cos(0)'; // sin(pi/2) = 1, cos(0) = 1
      final result = ExpressionParser.evaluate(expression, AngleMode.radians);
      expect(result, 2.0);
    });

    // Test 5: Biểu thức hỗn hợp
    test('Mixed scientific expression', () {
      final expression = '2 * pi * sqrt(9)'; // 2 * 3.1415... * 3
      final result = ExpressionParser.evaluate(expression, AngleMode.radians);
      // Dùng closeTo để so sánh số thực
      expect(result, closeTo(18.849, 0.001));
    });

    // Test 6: Toán tử lũy thừa
    test('Power operator (x^y)', () {
      final expression = '2^3 + 5';
      final result = ExpressionParser.evaluate(expression, AngleMode.degrees);
      expect(result, 13.0);
    });

    // Test 7: Xử lý lỗi biểu thức không hợp lệ
    test('Invalid expression should return NaN', () {
      final expression = '5 + * 3';
      final result = ExpressionParser.evaluate(expression, AngleMode.degrees);
      expect(result.isNaN, isTrue);
    });
  });
}
