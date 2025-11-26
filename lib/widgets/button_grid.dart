import 'package:advance_mobile_calculator/providers/calculator_provider.dart';
import 'package:advance_mobile_calculator/utils/app_color.dart';
import 'package:advance_mobile_calculator/widgets/calculator_button.dart';
import 'package:advance_mobile_calculator/widgets/mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorGridButton extends StatelessWidget {
  const CalculatorGridButton({super.key});

  // tạo mảng chứa nút bấm phân loại layout theo từng chế độ

  static const List<List<String>> _basicLayout = [
    ['AC', '⌫', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['±', '0', '.', '=']
  ];

  static const List<List<String>> _scientificLayout = [
    ['Rad', 'sin', 'cos', 'tan', 'ln', 'log'],
    ['x²', '√', 'x^y', '(', ')', '÷'],
    ['MC', '7', '8', '9', 'AC', '×'],
    ['MR', '4', '5', '6', '⌫', '-'],
    ['M+', '1', '2', '3', '%', '+'],
    ['M-', '±', '0', '.', 'Π', '=']
  ];

  static const List<List<String>> _programmerLayout = [
    ['Hex', 'Dec', 'Oct', 'Bin', 'AC', ''],
    ['(', ')', '<<', '>>', '%', '⌫'],
    ['A', 'B', '7', '8', '9', 'AND'],
    ['C', 'D', '4', '5', '6', 'OR'],
    ['E', 'F', '1', '2', '3', 'XOR'],
    ['', '±', '0', '.', 'NOT', '=']
  ];

  // hiển thị layout theo mode nè
  List<List<String>> _getLayoutForMode(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.scientific:
        return _scientificLayout;
      case CalculatorMode.programmer:
        return _programmerLayout;
      case CalculatorMode.basic:
      default:
        return _basicLayout;
    }
  }

  // set màu sắc cho nút bấm đặt biệt
  Color _getButtonColor(String buttonText, BuildContext context) {
    final functionColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFa5a5a5)
        : const Color(0xFF3b3b3b);

    const operators = ['÷', '×', '-', '+', '='];
    if (operators.contains(buttonText)) {
      return AppColor.Green_Primary;
    }

    const controls = ['AC', '⌫'];
    if (controls.contains(buttonText)) {
      return AppColor.Red;
    }

    const functions = [
      '%', '+/-', 'Rad', '√', 'x²', 'x^y', '(', ')', 'sin', 'cos', 'tan', 'ln', 'log',
      'MC', 'MR', 'M+', 'M-', 'e', 'π',
      'Dec', 'Hex', 'Bin', 'Oct', 'A', 'B', 'C', 'D', 'E', 'F',
      'AND', 'OR', 'XOR', 'NOT', '<<', '>>'
    ];
    if (functions.contains(buttonText)) {
      return functionColor;
    }

    return AppColor.DarK_Secondary;
  }

  @override
  Widget build(BuildContext context) {
    final calcProvider = context.watch<CalculatorProvider>();
    final layout = _getLayoutForMode(calcProvider.mode);
    // tạo padding cho các nút bấm có khoản cách với bên ngoài
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // khởi tạo cột sài map hiển thị danh sách nút bấm theo hàng từ layout
      child: Column(
        children: layout.map((rowButtons) {
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowButtons.map((buttonText) {
                if (buttonText.isEmpty) {
                  return Expanded(child: Container());
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomCalculatorButton(
                      ValueButton: buttonText,
                      ButtonColor: _getButtonColor(buttonText, context),
                      onPressed: () {
                        calcProvider.onButtonPressed(buttonText);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
