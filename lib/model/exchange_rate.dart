import 'package:exchange_calculator/datasources/constants/api_constants.dart';

class ExchangeRate {
   String baseCurrency;
   String rate;
  final String date;
  bool isBookmark;

  ExchangeRate({
    required this.baseCurrency,
    required this.rate,
    required this.date,
    this.isBookmark = false,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      baseCurrency: json['cur_unit'],
      rate: json['deal_bas_r'],
      date: json['date'] ?? ApiConstants.searchDate,
      isBookmark: json['is_bookmark'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cur_unit': baseCurrency,
      'deal_bas_r': rate,
      'date': date,
      'is_bookmark': isBookmark,
    };
  }

  void toggleBookmark() {
    isBookmark = !isBookmark;
  }
}
