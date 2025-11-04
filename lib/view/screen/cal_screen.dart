import 'package:exchange_calculator/datasources/constants/api_constants.dart';
import 'package:exchange_calculator/view/component/cal_screen/bookmark_part.dart';
import 'package:exchange_calculator/view/component/cal_screen/button.dart';
import 'package:exchange_calculator/view/component/cal_screen/cal_field.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalScreen extends StatelessWidget {
  final ExchangeRateViewModel vm =ExchangeRateViewModel();
   CalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => vm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //애드몹
              Container(
                width: 320,
                height: 50,
                color: Colors.amber,
                child: const Center(child: Text('AD')),
              ),
              //최근업데이트날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(ApiConstants.getToday()),
                ],
              ),
              const Spacer(),
              //히스토리
              //계산
               CalField(vm: vm,),
              //즐겨찾는 국가 리스트
              BookmarkPart(vm: vm,),
              //버튼
              Column(
                children: [
                  Row(
                    children: [
                      Button(text: 'AC',vm: vm,),
                      Button(text: 'C',vm: vm,),
                      Button(text: '%',vm: vm,),
                      Button(text: '÷',vm: vm,)
                    ],
                  ),
                  Row(
                    children: [
                      Button(text: '7',vm: vm,),
                      Button(text: '8',vm: vm,),
                      Button(text: '9',vm: vm,),
                      Button(text: 'x',vm: vm,)
                    ],
                  ),
                  Row(
                    children: [
                      Button(text: '4',vm: vm,),
                      Button(text: '5',vm: vm,),
                      Button(text: '6',vm: vm,),
                      Button(text: '-',vm: vm,)
                    ],
                  ),
                  Row(
                    children: [
                      Button(text: '1',vm: vm,),
                      Button(text: '2',vm: vm,),
                      Button(text: '3',vm: vm,),
                      Button(text: '+',vm: vm,)
                    ],
                  ),
                  Row(
                    children: [
                      Button(text: '00',vm: vm,),
                      Button(text: '0',vm: vm,),
                      Button(text: '.',vm: vm,),
                      Button(text: '=',vm: vm,)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
