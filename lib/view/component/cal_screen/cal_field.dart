import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalField extends StatelessWidget {
  const CalField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //상단
        _inputField(context, vm),
        const SizedBox(
          height: 10,
        ),
        //하단
        _outputField(context, vm)
      ],
    );
  }

  Widget _inputField(BuildContext context, ExchangeRateViewModel vm) {
    FocusNode focusNode = FocusNode();
    final currencyCode = vm.baseCurrency!.baseCurrency;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.115,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade900,
      ),
      child: Row(
        children: [
          CountryFlag.fromCurrencyCode(currencyCode),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: AbsorbPointer(
              child: TextField(
                controller: vm.textEditingController,
                focusNode: focusNode,
                onTap: () => focusNode.unfocus(),
                onChanged: (value) => vm.onAmountChanged(value),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                readOnly: true,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Center(
            child: Text(
              currencyCode,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _outputField(BuildContext context, ExchangeRateViewModel vm) {
    final currencyCode = vm.targetCurrency!.baseCurrency;
    final value = vm.convertedAmount.toStringAsFixed(2);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.115,
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.blue),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade900,
      ),
      child: Row(
        children: [
          CountryFlag.fromCurrencyCode(currencyCode),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Center(
            child: Text(
              currencyCode,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
