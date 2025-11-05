import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/view/screen/country_screen.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkPart extends StatelessWidget {
  const BookmarkPart({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    final rates = vm.rates;
    final bookmarks = vm.getBookmarks();
    return Container(
      padding: const EdgeInsets.all(6),
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        children: [
          //TODO 북마크 리스트
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 10,
              ),
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                final bookmark = bookmarks[index];
                return GestureDetector(
                  onTap: () {
                    //선택된 국가 화폐로 계산
                    vm.onSelectTarget(bookmark);
                    print('select');
                  },
                  child: CountryFlag.fromCurrencyCode(
                    bookmark.baseCurrency,
                    theme: const ImageTheme(
                      shape: Circle(),
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          //add 버튼
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountryScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
