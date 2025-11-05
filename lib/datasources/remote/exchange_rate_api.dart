import 'dart:convert';

import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:http/http.dart' as http;

class ExchangeRateApi {
  Future<List<ExchangeRate>> fetchData() async {
    final res = await http.get(Uri.parse(ApiConstants.requestUrl));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      final List<ExchangeRate> rates =
          data.map((i) => ExchangeRate.fromJson(i)).toList();
      print('api : $rates');
      return rates;
    } else {
      throw Exception('failed');
    }
  }
}
