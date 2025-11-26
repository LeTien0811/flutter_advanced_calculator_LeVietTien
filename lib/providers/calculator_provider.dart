import 'package:advance_mobile_calculator/providers/history_provider.dart';
import 'package:advance_mobile_calculator/providers/settings_provider.dart';
import 'package:advance_mobile_calculator/widgets/mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:advance_mobile_calculator/utils/expression_parser.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _history = '';
  CalculatorMode _mode = CalculatorMode.basic;

  // chế độ hiển thị số cho Programmer (DEC, HEX, BIN, OCT)
  String _programmerBase = 'Dec';

  double _memory = 0.0;
  bool _hasMemory = false;

  final SettingsProvider settings;
  final HistoryProvider historyProvider;

  CalculatorProvider({required this.settings, required this.historyProvider});

  // Getters
  String get expression => _expression;
  String get history => _history;
  CalculatorMode get mode => _mode;
  bool get hasMemory => _hasMemory;
  String get programmerBase => _programmerBase;

  // thay đổi chế độ
  void toggleMode(CalculatorMode newMode) {
    _mode = newMode;
    _clearAll();
    _programmerBase = 'Dec'; 
    notifyListeners();
  }
  
  // hàm nhận sự kiện click
  void onButtonPressed(String buttonText) {

    switch (buttonText) {
      case 'AC': _clearAll(); break;
      case '⌫': _deleteLast(); break;
      case '=': _calculate(); break;

      case 'MC': memoryClear(); break;
      case 'MR': memoryRecall(); break;
      case 'MS': memoryStore(); break;
      case 'M+': memoryAdd(); break;
      case 'M-': memorySubtract(); break;

      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
      case 'log':
        _handleScientificFunction(buttonText);
        break;
      case '√':
        _handleScientificFunction('sqrt');
        break;
      case 'x²':
        _appendToExpression('^2');
        break;
      case 'x^y':
        _appendToExpression('^');
        break;
      case 'π':
        _appendToExpression('pi');
        break;
      case 'e':
        _appendToExpression('e');
        break;
      case '( )':
        _handleParentheses();
        break;
      case '±':
        _handleNegate();
        break;

      case 'Hex': _changeBase('Hex'); break;
      case 'Dec': _changeBase('Dec'); break;
      case 'Oct': _changeBase('Oct'); break;
      case 'Bin': _changeBase('Bin'); break;

      case 'AND':
      case 'OR':
      case 'XOR':
      case '<<':
      case '>>':
        _appendToExpression(' $buttonText ');
        break;
      case 'NOT':
        _appendToExpression('NOT ');
        break;
      case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
      if (_programmerBase == 'Hex') {
        _appendToExpression(buttonText);
      }
      break;

      default:
        _appendToExpression(buttonText);
    }
    notifyListeners();
  }

  void _changeBase(String newBase) {
    if (_expression.isEmpty || _expression == 'Error') {
      _programmerBase = newBase;
      notifyListeners();
      return;
    }

    try {
      // lấy giá trị hiện tại convert sang int
      int value;
      if (_programmerBase == 'Hex') value = int.parse(_expression, radix: 16);
      else if (_programmerBase == 'Bin') value = int.parse(_expression, radix: 2);
      else if (_programmerBase == 'Oct') value = int.parse(_expression, radix: 8);
      else value = int.parse(_expression); // Dec

      _programmerBase = newBase;
      if (newBase == 'Hex') _expression = value.toRadixString(16).toUpperCase();
      else if (newBase == 'Bin') _expression = value.toRadixString(2);
      else if (newBase == 'Oct') _expression = value.toRadixString(8);
      else _expression = value.toString(); // Dec

    } catch (e) {
      _expression = 'Error';
    }
    notifyListeners();
  }

  // đổi dấu
  void _handleNegate() {
    if (_expression.isEmpty) return;
    if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);
    } else {
      _expression = '-$_expression';
    }
  }
  
  // xử lý hàm Scientific
  void _handleScientificFunction(String functionName) {
    if (_history.endsWith('=')) {
      _history = '';
    }
    if (_expression.isNotEmpty) {
      String lastChar = _expression.substring(_expression.length - 1);
      if (_isNumeric(lastChar) || lastChar == ')') {
        _expression += '*';
      }
    }
    _expression += '$functionName(';
    notifyListeners();
  }

  void memoryClear() { _memory = 0.0; _hasMemory = false; }
  void memoryRecall() {
    if (_hasMemory) {
      String memValue = _formatNumber(_memory);
      if (_expression == '0' || _history.endsWith('=')) {
        _expression = memValue;
        if (_history.endsWith('=')) _history = '';
      } else {
        if (_expression.isNotEmpty && _isNumeric(_expression[_expression.length-1])) {
          _expression += '*';
        }
        _appendToExpression(memValue);
      }
    }
  }
  void memoryStore() { _performMemoryOperation((val) => _memory = val); }
  void memoryAdd() { _performMemoryOperation((val) => _memory += val); }
  void memorySubtract() { _performMemoryOperation((val) => _memory -= val); }

  void _performMemoryOperation(Function(double) operation) {
    _calculate();
    if (_expression == 'Error') return;
    double currentValue = double.tryParse(_expression) ?? 0.0;
    operation(currentValue);
    _hasMemory = _memory != 0.0;
  }
  
  // xử lý dấu ngoặc
  void _handleParentheses() {
    int open = '('.allMatches(_expression).length;
    int close = ')'.allMatches(_expression).length;
    String last = _expression.isEmpty ? '' : _expression.substring(_expression.length - 1);

    if (open > close && (_isNumeric(last) || last == ')')) {
      _appendToExpression(')');
    } else {
      if (_expression.isNotEmpty && (_isNumeric(last) || last == ')')) {
        _appendToExpression('*(');
      } else {
        _appendToExpression('(');
      }
    }
  }

  // truyền ký tự vào 
  void _appendToExpression(String text) {
    if (_history.endsWith('=')) {

      if (!_isOperator(text)) {
        _expression = text;
        _history = '';
        return;
      }
      else {
        _history = '';
      }
    }
    _expression += text;
  }

  void _clearAll() {
    _expression = '';
    _history = '';
  }

  void _deleteLast() {
    if (_expression.isNotEmpty) {
      List<String> functions = ['sin(', 'cos(', 'tan(', 'ln(', 'log(', 'sqrt(', 'NOT '];
      bool deleted = false;
      for (var func in functions) {
        if (_expression.endsWith(func)) {
          _expression = _expression.substring(0, _expression.length - func.length);
          deleted = true;
          break;
        }
      }
      if (!deleted) {
        _expression = _expression.substring(0, _expression.length - 1);
        if (_expression.endsWith(' ')) {
          _expression = _expression.trimRight();
        }
      }
    }
  }
  
  // tính toán
  void _calculate() {
    if (_expression.isEmpty) return;

    String tempExpr = _expression.trim();
    if (_isOperator(tempExpr[tempExpr.length - 1])) {
      tempExpr = tempExpr.substring(0, tempExpr.length - 1);
    }

    try {
      double evalResult = ExpressionParser.evaluate(tempExpr, settings.angleMode);

      if (evalResult.isNaN || evalResult.isInfinite) {
        _history = _expression + ' =';
        _expression = 'Error';
      } else {
        String resultString;

        if (_mode == CalculatorMode.programmer) {
          int intResult = evalResult.toInt();
          if (_programmerBase == 'Hex') resultString = intResult.toRadixString(16).toUpperCase();
          else if (_programmerBase == 'Bin') resultString = intResult.toRadixString(2);
          else if (_programmerBase == 'Oct') resultString = intResult.toRadixString(8);
          else resultString = intResult.toString();
        } else {
          resultString = _formatNumber(evalResult);
        }

        String historyEntry = '$_expression = $resultString';
        historyProvider.add(historyEntry);

        _history = '$_expression =';
        _expression = resultString;
      }
    } catch (e) {
      _history = _expression + ' =';
      _expression = 'Error';
    }
  }

  String _formatNumber(double value) {
    String result = value.toString();
    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2);
    }
    return result;
  }

  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    return double.tryParse(s) != null || s == '.';
  }

  bool _isHexChar(String s) {
    return ['A', 'B', 'C', 'D', 'E', 'F'].contains(s);
  }

  bool _isOperator(String s) {
    if (s.isEmpty) return false;
    String lastChar = s.length > 1 ? s.substring(s.length -1) : s;
    return ['+', '-', '×', '*', '÷', '/', '^', '%', 'AND', 'OR', 'XOR', 'NOT', '<<', '>>'].contains(lastChar.trim());
  }
}