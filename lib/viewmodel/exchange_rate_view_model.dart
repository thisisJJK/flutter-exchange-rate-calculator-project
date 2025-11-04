import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:exchange_calculator/repository/exchange_rate_repository.dart';
import 'package:flutter/material.dart';

class ExchangeRateViewModel extends ChangeNotifier {
  final TextEditingController textEditingController =
      TextEditingController(text: '0');
  final ExchangeRateRepository repository = ExchangeRateRepository();
  //환율 변수
  List<ExchangeRate> rates = [];
  double result = 0.0;
  String base = 'USD';
  //계산기 로직 변수
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _shouldResetDisplay = false;
  bool _isNewCalculation = true;

  String get display => _display;

  //로드
  Future<void> loadRates() async {
    rates = await repository.getRates();
    _initBase();
    notifyListeners();
  }

  void _initBase() {
    //북마크 리스트 중 첫번째 기준
    if (getBookmarks().isNotEmpty) {
      base = getBookmarks().first.baseCurrency;
    } else {
      base = 'USD';
    }
    notifyListeners();
  }

  //환율계산
  void calculateResult(String targetCurrency, double inputAmount) {
    final rate = rates.firstWhere(
      (r) => r.baseCurrency == targetCurrency,
    );
    result = inputAmount * double.parse(rate.rate); // 기준 통화 × 선택 통화 환율
    base = targetCurrency; // 계산 후 선택한 버튼 기준 통화로 변경
    notifyListeners();
  }

  //북마크 기능
  Future<void> toggleBookmark(String currencyCode) async {
    final rate = rates.firstWhere((r) => r.baseCurrency == currencyCode);
    rate.toggleBookmark();
    await repository.updateBookmark(currencyCode, rate.isBookmark);
    notifyListeners();
  }

  //북마크 리스트
  List<ExchangeRate> getBookmarks() =>
      rates.where((r) => r.isBookmark).toList();

  //TODO 계산 화면
  void input(String button) {
    switch (button) {
      case 'AC':
        _clear();
        break;
      case 'C':
        _clearEntry();
        break;
      case '%':
        _handlePercent();
        break;
      case '+':
      case '-':
      case 'x':
      case '÷':
        _handleOperator(button);
        break;
      case '=':
        _calculate();
        break;
      case '.':
        _handleDecimal();
        break;
      default:
        _handleNumber(button);
    }
    notifyListeners();
  }

  void _clear() {
    _display = '0';
    textEditingController.text = _display;
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = false;
    _isNewCalculation = true;
    notifyListeners();
  }

  void _clearEntry() {
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
      textEditingController.text = _display;
    } else if (_display.length == 1) {
      _display = '0';
      textEditingController.text = _display;
    }

    _shouldResetDisplay = false;
    notifyListeners();
  }

  void _handleNumber(String number) {
    if (_shouldResetDisplay || _display == '0') {
      if (number == '0' || number == '00') return;
      _display = number;
      textEditingController.text = _display;
      _shouldResetDisplay = false;
      _isNewCalculation = false;
      notifyListeners();
    } else {
      _display += number;
      textEditingController.text = _display;

      notifyListeners();
    }
  }

  void _handleDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      textEditingController.text = _display;

      _shouldResetDisplay = false;
      notifyListeners();
    } else if (!_display.contains('.')) {
      _display += '.';
      textEditingController.text = _display;
      notifyListeners();
    }
  }

  void _handleOperator(String op) {
    if (_operator.isNotEmpty && !_shouldResetDisplay) {
      _calculate();
    }

    _firstOperand = _display;
    // textEditingController.text = _display;
    _operator = op;
    _shouldResetDisplay = true;
    _isNewCalculation = false;
  }

  void _handlePercent() {
    double currentValue = double.parse(_display);

    if (_operator.isEmpty || _isNewCalculation) {
      // 단독으로 사용: 2% = 0.02
      double result = currentValue / 100;
      _display = _formatResult(result);
      textEditingController.text = _display;
      _isNewCalculation = true;
    } else {
      // 연산과 함께 사용: 200 + 20% = 240
      double firstValue = double.parse(_firstOperand);
      double percentValue = 0;

      switch (_operator) {
        case '+':
        case '-':
          // 200 + 20% = 200 + (200 * 0.2) = 240
          percentValue = firstValue * (currentValue / 100);
          break;
        case 'x':
        case '÷':
          // 200 x 20% = 200 * 0.2 = 40
          percentValue = currentValue / 100;
          break;
      }

      _display = _formatResult(percentValue);
      textEditingController.text = _display;
    }

    _shouldResetDisplay = true;
  }

  void _calculate() {
    if (_operator.isEmpty || _firstOperand.isEmpty) return;

    double first = double.parse(_firstOperand);
    double second = double.parse(_display);
    double result = 0;

    switch (_operator) {
      case '+':
        result = first + second;
        break;
      case '-':
        result = first - second;
        break;
      case 'x':
        result = first * second;
        break;
      case '÷':
        if (second == 0) {
          _display = 'Error';
          textEditingController.text = _display;
          _clear();
          return;
        }
        result = first / second;

        break;
    }

    _display = _formatResult(result);
    textEditingController.text = _display;
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = true;
    _isNewCalculation = true;
    notifyListeners();
  }

  String _formatResult(double value) {
    // 정수인 경우 소수점 제거
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    // 소수점 이하가 있는 경우 불필요한 0 제거
    return value
        .toStringAsFixed(10)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
