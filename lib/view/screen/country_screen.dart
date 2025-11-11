import 'package:exchange_calculator/view/component/country_screen/country_card.dart';
import 'package:exchange_calculator/viewmodel/ad_view_model.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 페이지 열릴 때마다 새로운 AdViewModel 생성
      create: (_) => AdViewModel()..loadAd(isLarge: true),
      child: const _CountryScreenContent(),
    );
  }
}

class _CountryScreenContent extends StatelessWidget {
  const _CountryScreenContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    final ad = context.watch<AdViewModel>();
    final rates = vm.rates;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Country list'),
        ),
        body: Column(
          children: [
            // 전체 국가 리스트
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: rates.length,
                itemBuilder: (BuildContext context, int index) {
                  final rate = rates[index];
                  return CountryCard(rate: rate, vm: vm);
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            //애드몹
            if (ad.isAdLoaded && ad.bannerAd != null)
              SizedBox(
                width: 320,
                height: 100,
                child: AdWidget(ad: ad.bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
