import 'package:exchange_calculator/view/component/country_screen/country_card.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    final rates = vm.rates;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Column(
          children: [
            // 전체 국가 리스트
            Expanded(
              child: ListView.builder(
                itemCount: rates.length,
                itemBuilder: (BuildContext context, int index) {
                  final rate = rates[index];
                  return CountryCard(rate: rate, vm: vm);
                },
              ),
            ),

            //애드몹
            Container(
              width: 320,
              height: 50,
              color: Colors.amber,
              child: const Center(child: Text('AD')),
            ),
          ],
        ),
      ),
    );
  }
}
