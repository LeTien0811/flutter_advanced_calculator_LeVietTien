import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/widgets/mode_selector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CalculatorProvider calculator;
  late SettingsProvider settings;
  late HistoryProvider history;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = SettingsProvider();
    history = HistoryProvider();
    calculator = CalculatorProvider(settings: settings, historyProvider: history);
    await Future.delayed(Duration.zero);
  });

  group('Complex Calculator Scenarios', () {

    test('Test 1 Complex expressions', () {
      final inputs = ['(', '5', '+', '3', ')', '×', '2', '-', '4', '÷', '2', '='];
      for (var btn in inputs) {
        calculator.onButtonPressed(btn);
      }
      expect(calculator.expression, '14');
    });

    test('Test 2 Scientific sin45 plus cos45', () {
      settings.setAngleMode(AngleMode.degrees);

      final inputs = ['sin', '4', '5', ')', '+', 'cos', '4', '5', ')', '='];
      for (var btn in inputs) calculator.onButtonPressed(btn);

      double result = double.parse(calculator.expression);
      expect(result, closeTo(1.4142, 0.0001));
    });

    test('Test 3 Memory operations', () {
      calculator.memoryClear();
      calculator.onButtonPressed('5');
      calculator.onButtonPressed('M+');
      calculator.onButtonPressed('AC');
      calculator.onButtonPressed('3');
      calculator.onButtonPressed('M+');
      calculator.onButtonPressed('AC');
      calculator.onButtonPressed('MR');
      expect(calculator.expression, '8');
    });

    test('Test 4 Chain calculations', () {
      calculator.onButtonPressed('5');
      calculator.onButtonPressed('+');
      calculator.onButtonPressed('3');
      calculator.onButtonPressed('=');
      calculator.onButtonPressed('+');
      calculator.onButtonPressed('2');
      calculator.onButtonPressed('=');
      calculator.onButtonPressed('+');
      calculator.onButtonPressed('1');
      calculator.onButtonPressed('=');
      expect(calculator.expression, '11');
    });

    test('Test 5 Parentheses nesting', () {
      final inputs = ['(', '(', '2', '+', '3', ')', '×', '(', '4', '-', '1', ')', ')', '÷', '5', '='];
      for (var btn in inputs) calculator.onButtonPressed(btn);
      expect(calculator.expression, '3');
    });

    test('Test 6 Mixed scientific', () {
      calculator.toggleMode(CalculatorMode.scientific);

      calculator.onButtonPressed('2');
      calculator.onButtonPressed('×');
      calculator.onButtonPressed('Π');
      calculator.onButtonPressed('×');
      calculator.onButtonPressed('√');
      calculator.onButtonPressed('9');
      calculator.onButtonPressed(')');
      calculator.onButtonPressed('=');

      double result = double.parse(calculator.expression);
      expect(result, closeTo(18.85, 0.01));
    });

    test('Test 7 Programmer mode', () {
      calculator.toggleMode(CalculatorMode.programmer);
      calculator.onButtonPressed('Hex');
      calculator.onButtonPressed('F');
      calculator.onButtonPressed('F');
      calculator.onButtonPressed('AND');
      calculator.onButtonPressed('0');
      calculator.onButtonPressed('F');
      calculator.onButtonPressed('=');

      expect(calculator.expression, 'F');
    });
  });
}