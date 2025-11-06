import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';

enum TextType {
  num,
  oper,
  etc,
}

class Button extends StatelessWidget {
  final String text;
  final ExchangeRateViewModel vm;
  const Button({super.key, required this.text, required this.vm});

  TextType get textType {
    const numTexts = [
      '0',
      '00',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.'
    ];
    const operTexts = ['x', '-', '+', '÷', '='];
    if (numTexts.contains(text)) return TextType.num;
    if (operTexts.contains(text)) return TextType.oper;
    return TextType.etc;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    final height = width * 0.75;
    final color = switch (textType) {
      TextType.num => Colors.white,
      TextType.oper => Colors.orange,
      TextType.etc => Colors.red,
    };

    return InkWell(
      onTap: () {
        vm.input(text);
      },
      radius: 33,
      child: Ink(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(width: 0.05),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
