// 광고 전용 ViewModel
import 'package:exchange_calculator/service/ad_mob_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdViewModel extends ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isDisposed = false;

  BannerAd? get bannerAd => _bannerAd;
  bool get isAdLoaded => _isAdLoaded;

  Future<void> loadAd({required bool isLarge}) async {
    if (_isDisposed) return;

    try {
      // 기존 광고가 있으면 정리
      _bannerAd?.dispose();
      _isAdLoaded = false;

      _bannerAd = await AdMobService.loadBannerAd(isLarge: isLarge);
      
      if (!_isDisposed) {
        _isAdLoaded = true;
        notifyListeners();
      }
    } catch (e) {
      print('광고 로드 중 에러: $e');
      _isAdLoaded = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }
}