// 1. AdMob Service 클래스 (비즈니스 로직 분리)
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdMobService {

  static const String androidSmall = 'ca-app-pub-3940256099942544/6300978111';
  static const String androidLarge = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosSmall = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosLarge = 'ca-app-pub-3940256099942544/2934735716';

  // 광고 ID 반환 (static 메서드)
  static String getAdUnitId({required bool isLarge}) {
    if (Platform.isAndroid) {
      return isLarge ? androidLarge : androidSmall;
    } else if (Platform.isIOS) {
      return isLarge ? iosLarge : iosSmall;
    }
    return androidSmall;
  }

  // 광고 로드 (static 메서드)
  static Future<BannerAd> loadBannerAd({
    required bool isLarge,
    AdSize? customSize,
  }) async {
    final adUnitId = getAdUnitId(isLarge: isLarge);
    final adSize = customSize ?? (isLarge ? AdSize.largeBanner : AdSize.banner);

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('광고 로드 성공: ${isLarge ? "Large" : "Small"}');
        },
        onAdFailedToLoad: (ad, error) {
          print('광고 로드 실패: $error');
          ad.dispose();
        },
        onAdOpened: (ad) {
          print('광고 열림');
        },
        onAdClosed: (ad) {
          print('광고 닫힘');
        },
      ),
    );

    await bannerAd.load();
    return bannerAd;
  }
}
