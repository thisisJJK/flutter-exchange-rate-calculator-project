import 'dart:convert';

import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/datasources/remote/exchange_rate_api.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeRateRepository {
  final ExchangeRateApi api = ExchangeRateApi();

  static const _cacheKey = 'exchange_rates';

  //로컬에 저장
  Future<List<ExchangeRate>> _fetchAndCacheRates() async {
    try {
      final List<ExchangeRate> rates = await api.fetchData();

      if (rates.isEmpty) {
        throw Exception('환율 데이터가 비어있습니다');
      }

      print('API에서 가져온 데이터: ${rates.length}개');

      // 로컬 캐시 저장
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(rates.map((e) => e.toJson()).toList());
      await prefs.setString(_cacheKey, jsonString);

      return rates;
    } catch (e) {
      print('환율 데이터 가져오기 실패: $e');
      rethrow;
    }
  }

  //불러오기
  Future<List<ExchangeRate>> _loadCachedRates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);

      if (jsonString == null) return [];

      // json 문자열 => 모델 리스트
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final rates = jsonList.map((e) => ExchangeRate.fromJson(e)).toList();

      print('캐시에서 불러온 데이터: ${rates.length}개');
      return rates;
    } catch (e) {
      print('캐시 로드 실패: $e');
      return [];
    }
  }

  //최종 환율 데이터
  Future<List<ExchangeRate>> getRates() async {
    final List<ExchangeRate> cachedRates = await _loadCachedRates();

    // 캐시가 없으면 새로 가져오기
    if (cachedRates.isEmpty) {
      print('캐시 없음 - API 호출');
      return await _fetchAndCacheRates();
    }

    // 날짜 비교
    final cachedDate = cachedRates.first.date;
    final today = ApiConstants.getToday();

    print('캐시 날짜: $cachedDate, 오늘: $today');

    if (cachedDate == today) {
      print('최신 캐시 사용');
      return cachedRates;
    } else {
      print('캐시 만료 - API 호출');
      return await _fetchAndCacheRates();
    }
  }

  Future<void> updateBookmark(String currencyCode, bool isBookmark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<ExchangeRate> cachedRates = await _loadCachedRates();

      if (cachedRates.isEmpty) {
        print('업데이트할 캐시 데이터가 없습니다');
        return;
      }

      // 해당 통화 찾아서 북마크 상태 변경
      bool found = false;
      for (var rate in cachedRates) {
        if (rate.baseCurrency == currencyCode) {
          rate.isBookmark = isBookmark;
          found = true;
          break;
        }
      }

      if (!found) {
        print('통화 코드를 찾을 수 없습니다: $currencyCode');
        return;
      }

      // 업데이트된 데이터 저장
      final updatedJson = jsonEncode(
        cachedRates.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_cacheKey, updatedJson);

      print('북마크 업데이트 완료: $currencyCode = $isBookmark');
    } catch (e) {
      print('북마크 업데이트 실패: $e');
      rethrow;
    }
  }
}
