import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';

class CalField extends StatelessWidget {
  final ExchangeRateViewModel vm;

   CalField({
    super.key, required this.vm
  });



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //TODO 국기
        //TODO 숫자 입력 필드
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          child: TextField(
            controller: vm.textEditingController,
            textAlign: TextAlign.right,
            readOnly: false,
            showCursor: false,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
