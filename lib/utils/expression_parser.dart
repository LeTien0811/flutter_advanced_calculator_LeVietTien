import 'dart:math' as math;
import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/utils/calculator_logic.dart';
import 'package:advance_mobile_calculator/utils/constants.dart';
import 'package:math_expressions/math_expressions.dart';

class ExpressionParser {
  static double evaluate(String expression, AngleMode angleMode) {
    try {
      // kiểm tra nhanh xem có phải là Programmer Math không
      // dùng hằng số từ file constants để kiểm tra
      bool isProgrammerMath = AppConstants.programmerOperators.any((op) => expression.contains(op));

      if (isProgrammerMath) {
        // gọi hàm xử lý bên file logic
        return CalculatorLogic.calculateProgrammerMath(expression);
      }

      // chuẩn hóa biểu thức (Dùng Map từ constants)
      String finalExpression = expression;
      AppConstants.symbolReplacements.forEach((key, value) {
        if (angleMode != AngleMode.degrees && key.contains('(')) return;
        finalExpression = finalExpression.replaceAll(key, value);
      });

      Parser p = Parser();
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      //chế độ degrees
      if (angleMode == AngleMode.degrees) {
        p.addFunction('sind', (List<dynamic> args) => math.sin((args[0] as double) * (math.pi / 180)));
        p.addFunction('cosd', (List<dynamic> args) => math.cos((args[0] as double) * (math.pi / 180)));
        p.addFunction('tand', (List<dynamic> args) => math.tan((args[0] as double) * (math.pi / 180)));
      }

      //tính
      Expression exp = p.parse(finalExpression);
      return exp.evaluate(EvaluationType.REAL, cm);

    } catch (e) {
      print('Error evaluating expression: $e');
      return double.nan;
    }
  }
}