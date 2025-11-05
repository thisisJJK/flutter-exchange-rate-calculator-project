// 기존 import 유지
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:exchange_calculator/repository/exchange_rate_repository.dart';
import 'package:flutter/material.dart';

class ExchangeRateViewModel extends ChangeNotifier {
  final TextEditingController textEditingController =
      TextEditingController(text: '0');
  final ExchangeRateRepository repository = ExchangeRateRepository();
  //환율 변수
  List<ExchangeRate> _rates = [];
  ExchangeRate? _baseCurrency; // 위 칸
  ExchangeRate? _targetCurrency; // 아래 칸
  double _inputAmount = 0;
  double _convertedAmount = 0;
  List<ExchangeRate> get rates => _rates;
  ExchangeRate? get baseCurrency => _baseCurrency;
  ExchangeRate? get targetCurrency => _targetCurrency;
  double get inputAmount => _inputAmount;
  double get convertedAmount => _convertedAmount;
  bool isSelected = false;
  int? selectedIndex;

  //계산기 로직 변수
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _shouldResetDisplay = false;
  bool _isNewCalculation = true;
  String get display => _display;
  String get firstOperand => _firstOperand;
  String get operator => _operator;

  //rate 문자열 파싱 (콤마 제거 등)
  double _parseRateString(String rateStr) {
    if (rateStr.isEmpty) return 0;
    final cleaned = rateStr.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  // display -> inputAmount 동기화 및 환율 재계산
  void _syncDisplayToAmountAndCalculate() {
    // _display가 숫자 형식이 아니라면 0으로 처리
    final parsed = double.tryParse(_display.replaceAll(',', '')) ?? 0;
    _inputAmount = parsed;
    // 화면의 텍스트 컨트롤러도 항상 _display와 동일하게 유지
    textEditingController.text = _display;
    // 환율 계산
    _rateCalculate();
  }

  //로드
  Future<void> loadRates() async {
    _rates = await repository.getRates();
    // 기본값 설정 (미국 ↔ 한국)
    _baseCurrency = _rates.firstWhere(
      (r) => r.baseCurrency == 'USD',
      orElse: () => _rates.first,
    );
    _targetCurrency = _rates.firstWhere(
      (r) => r.baseCurrency == 'KRW',
      orElse: () => _rates.last,
    );

    notifyListeners();
  }

  void onAmountChanged(String value) {
    _display = value;
    _syncDisplayToAmountAndCalculate();
    notifyListeners();
  }

  void _rateCalculate() {
    if (_baseCurrency == null || _targetCurrency == null) return;

    final baseRate = _parseRateString(_baseCurrency!.rate);
    final targetRate = _parseRateString(_targetCurrency!.rate);

    if (targetRate == 0) {
      _convertedAmount = 0;
    } else {
      _convertedAmount = _inputAmount * (baseRate / targetRate);
    }

    notifyListeners();
  }

  void onSelectTarget(ExchangeRate newTarget, int index) {
    if (_targetCurrency == null || _baseCurrency == null) return;

    //국가 선택
    selectedIndex = index;

    // base <-> target 교체
    _baseCurrency = _targetCurrency;
    _targetCurrency = newTarget;

    // 변환된 결과를 새 input으로 사용 (화면/내부 동기화)
    // convertedAmount가 이미 계산되어 있다면 그것을 새 입력으로 바꾼다
    _inputAmount = _convertedAmount;
    _display = _formatResult(_inputAmount);
    textEditingController.text = _display;

    // 그리고 새로 환산
    _rateCalculate();

    notifyListeners();
  }

  //북마크 기능
  Future<void> toggleBookmark(String currencyCode) async {
    try {
      final rate = rates.firstWhere((r) => r.baseCurrency == currencyCode);
      rate.toggleBookmark();
      await repository.updateBookmark(currencyCode, rate.isBookmark);

      notifyListeners();
    } catch (e) {
      print('북마크 업데이트 실패 : $e');
    }
  }

  //북마크 리스트
  List<ExchangeRate> getBookmarks() =>
      rates.where((r) => r.isBookmark).toList();

  //계산 화면
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
    // 모든 입력 처리 후에는 display -> input 동기화
    _syncDisplayToAmountAndCalculate();
    notifyListeners();
  }

  //전체 삭제
  void _clear() {
    _display = '0';
    textEditingController.text = _display;
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = false;
    _isNewCalculation = true;
    // 동기화
    _syncDisplayToAmountAndCalculate();
    notifyListeners();
  }

  //숫자 삭제
  void _clearEntry() {
    if (_display.length > 1 && _display != '0') {
      _display = _display.substring(0, _display.length - 1);
      textEditingController.text = _display;
    } else if (_display.length == 1) {
      _display = '0';
      textEditingController.text = _display;
    }

    _shouldResetDisplay = false;
    // 동기화
    _syncDisplayToAmountAndCalculate();
    notifyListeners();
  }

  //숫자 입력 제어
  void _handleNumber(String number) {
    if (_shouldResetDisplay || _display == '0') {
      if (number == '0' || number == '00') return;
      _display = number;
      textEditingController.text = _display;
      _shouldResetDisplay = false;
      _isNewCalculation = false;
    } else {
      // 추가 입력 시 '0'이면 대체 처리
      if (_display == '0' && number != '.') {
        _display = number;
      } else {
        _display += number;
      }
      textEditingController.text = _display;
    }
    // 동기화는 밖에서 한 번에 처리 (input()에서)
  }

  //소수 제어
  void _handleDecimal() {
    if (_shouldResetDisplay) {
      _display = '0.';
      textEditingController.text = _display;

      _shouldResetDisplay = false;
    } else if (!_display.contains('.')) {
      _display += '.';
      textEditingController.text = _display;
    }
    // 동기화는 밖에서 한 번에 처리
  }

  //연산자 제어
  void _handleOperator(String op) {
    if (_operator.isNotEmpty && !_shouldResetDisplay) {
      _calculate();
    }

    _firstOperand = _display;
    _operator = op;
    _shouldResetDisplay = true;
    _isNewCalculation = false;
  }

  //% 연산자 제어
  void _handlePercent() {
    double currentValue = double.tryParse(_display) ?? 0;

    if (_operator.isEmpty || _isNewCalculation) {
      // 단독으로 사용: 2% = 0.02
      double result = currentValue / 100;
      _display = _formatResult(result);
      textEditingController.text = _display;
      _isNewCalculation = true;
    } else {
      // 연산과 함께 사용: 200 + 20% = 240
      double firstValue = double.tryParse(_firstOperand) ?? 0;
      double percentValue = 0;

      switch (_operator) {
        case '+':
        case '-':
          percentValue = firstValue * (currentValue / 100);
          break;
        case 'x':
        case '÷':
          percentValue = currentValue / 100;
          break;
      }

      _display = _formatResult(percentValue);
      textEditingController.text = _display;
    }

    _shouldResetDisplay = true;
  }

  //계산 로직
  void _calculate() {
    if (_operator.isEmpty || _firstOperand.isEmpty) return;

    double first = double.tryParse(_firstOperand) ?? 0;
    double second = double.tryParse(_display) ?? 0;
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

    // 동기화는 밖에서 한 번에 처리 (input()에서 호출)
  }

  //결과
  String _formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0*$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
