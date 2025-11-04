import 'package:intl/intl.dart';

class ApiConstants {
  static const String apiKey = 'i3n9KVItFfKlzP4LrOdcnGoeO0ALXwaf';
  static const String apiUrl =
      'https://oapi.koreaexim.go.kr/site/program/financial/exchangeJSON';
  static String searchDate = getToday();

  static String getToday() {
    late String strToday;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyyMMdd');
    strToday = formatter.format(now);

    return strToday;
  }

//최종 요청 주소
  static String requestUrl =
      '$apiUrl?authkey=$apiKey&searchdate=$searchDate&data=AP01';
}
