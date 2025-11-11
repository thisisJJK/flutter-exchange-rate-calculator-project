import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/view/component/cal_screen/bookmark_part.dart';
import 'package:exchange_calculator/view/component/cal_screen/button.dart';
import 'package:exchange_calculator/view/component/cal_screen/cal_field.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalScreen extends StatelessWidget {
  const CalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //애드몹
            _adMob(),
            //최근업데이트날짜
            _todayAndUpdated(vm, context),
            const SizedBox(),
            //계산
            const CalField(),
            const SizedBox(),
            // BookmarkPart
            const BookmarkPart(),
            //버튼
            _buildBtn(vm)
          ],
        ),
      ),
    );
  }

  Widget _adMob() {
    return Column(
      children: [
        Container(
          width: 320,
          height: 50,
          color: Colors.amber,
          child: const Center(child: Text('AD')),
        ),
        const Divider(
          height: 8,
          thickness: 0.3,
        ),
      ],
    );
  }

  Widget _todayAndUpdated(ExchangeRateViewModel vm, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today    : ${ApiConstants.getToday()}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              'Updated: ${vm.rates.isNotEmpty ? vm.rates.first.date : "-"}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            //selectSheet
            _showBaseCurrencyPicker(vm, context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green,
              ),
              color: Colors.grey.shade900,
            ),
            child: const Center(
              child: Text(
                'Select base',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showBaseCurrencyPicker(
      ExchangeRateViewModel vm, BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: vm.rates.length,
            itemBuilder: (BuildContext context, int index) {
              final rate = vm.rates[index];
              final isSelected =
                  rate.baseCurrency == vm.baseCurrency?.baseCurrency;
              return GestureDetector(
                onTap: () async {
                  await vm.changeBaseCurrency(rate);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.withValues(alpha: 0.5)
                        : Colors.grey.shade900,
                    border: isSelected
                        ? Border.all(
                            color: Colors.green,
                            width: 3,
                          )
                        : Border.all(
                            color: Colors.green,
                            width: 1,
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CountryFlag.fromCurrencyCode(rate.baseCurrency),
                      Text(
                        rate.baseCurrency,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildBtn(ExchangeRateViewModel vm) {
    return Column(
      children: [
        Row(
          children: [
            Button(
              text: 'AC',
              vm: vm,
            ),
            Button(
              text: 'C',
              vm: vm,
            ),
            Button(
              text: '%',
              vm: vm,
            ),
            Button(
              text: '÷',
              vm: vm,
            )
          ],
        ),
        Row(
          children: [
            Button(
              text: '7',
              vm: vm,
            ),
            Button(
              text: '8',
              vm: vm,
            ),
            Button(
              text: '9',
              vm: vm,
            ),
            Button(
              text: 'x',
              vm: vm,
            )
          ],
        ),
        Row(
          children: [
            Button(
              text: '4',
              vm: vm,
            ),
            Button(
              text: '5',
              vm: vm,
            ),
            Button(
              text: '6',
              vm: vm,
            ),
            Button(
              text: '-',
              vm: vm,
            )
          ],
        ),
        Row(
          children: [
            Button(
              text: '1',
              vm: vm,
            ),
            Button(
              text: '2',
              vm: vm,
            ),
            Button(
              text: '3',
              vm: vm,
            ),
            Button(
              text: '+',
              vm: vm,
            )
          ],
        ),
        Row(
          children: [
            Button(
              text: '00',
              vm: vm,
            ),
            Button(
              text: '0',
              vm: vm,
            ),
            Button(
              text: '.',
              vm: vm,
            ),
            Button(
              text: '=',
              vm: vm,
            )
          ],
        ),
      ],
    );
  }
}
