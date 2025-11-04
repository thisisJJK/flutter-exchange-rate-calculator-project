import 'dart:convert';

import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/datasources/remote/exchange_rate_api.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateRepository {
  late final SharedPreferences prefs;
  late final String? jsonString;
  final ExchangeRateApi api = ExchangeRateApi();

  static const _cacheKey = 'exchange_rates';

  //로컬에 저장
  Future<List<ExchangeRate>> _fetchAndCacheRates() async {
    final List<ExchangeRate> rates = await api.fetchData();

    //로컬 캐시 저장 (모델리스트 => json 문자열)
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(rates.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
    return rates;
  }

  //불러오기
  Future<List<ExchangeRate>> _loadCachedRates() async {
    prefs = await SharedPreferences.getInstance();
    jsonString = prefs.getString(_cacheKey);

    if (jsonString == null) return await _fetchAndCacheRates();

    //json 문자열 => 모델리스트
    final List<dynamic> jsonList = jsonDecode(jsonString!);
    final rates = jsonList.map((e) => ExchangeRate.fromJson(e)).toList();
    return rates;
  }

  //최종 환율 데이터
  Future<List<ExchangeRate>> getRates() async {
    final List<ExchangeRate> cachedRates = await _loadCachedRates();

    //날짜 비교
    final cachedDate = cachedRates.first.date;
    final today = ApiConstants.getToday();
    if (cachedDate == today) {
      return cachedRates;
    } else {
      return await _fetchAndCacheRates();
    }
  }

  Future<void> updateBookmark(String currencyCode, bool isBookmark) async {
    final List<ExchangeRate> cachedRates = await _loadCachedRates();

    for (var rate in cachedRates) {
      if (rate.baseCurrency == currencyCode) {
        rate.isBookmark = isBookmark;
        break;
      }
    }

    final updatedJson = jsonEncode(cachedRates.map((e) => e.toJson()).toList());

    await prefs.setString(_cacheKey, updatedJson);
  }
}
