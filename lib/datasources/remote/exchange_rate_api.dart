import 'dart:convert';

import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:http/http.dart' as http;

class ExchangeRateApi {
  // 통화 코드 매핑
  static const Map<String, String> _currencyMapping = {
    'CNH': 'CNY',
    'IDR(100)': 'IDR',
    'JPY(100)': 'JPY',
  };

  Future<List<ExchangeRate>> fetchData() async {
    final res = await http.get(Uri.parse(ApiConstants.requestUrl));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      final List<ExchangeRate> rates =
          data.map((i) => ExchangeRate.fromJson(i)).toList();

      for (var rate in rates) {
        final originalCode = rate.baseCurrency;

        // (100) 표시가 있는지 확인
        final hasHundred = originalCode.contains('(100)');

        // 통화 코드 정리
        if (originalCode == 'CNH') {
          rate.baseCurrency = 'CNY';
        } else {
          rate.baseCurrency =
              originalCode.replaceAll(RegExp(r'\(\d+\)'), '').trim();
        }

        if (hasHundred) {
          final currentRate = double.parse(rate.rate.replaceAll(',', ''));
          rate.rate = (currentRate * 0.01).toStringAsFixed(2);
        }
      }

      return rates;
    } else {
      throw Exception('failed');
    }
  }
}
