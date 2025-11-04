import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';

class BookmarkPart extends StatelessWidget {
  final ExchangeRateViewModel vm;

  const BookmarkPart({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final bookmarkList = vm.getBookmarks();
    final countBookmark = bookmarkList.length;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        children: [
          //북마크 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: countBookmark,
              separatorBuilder: (context, index) => const SizedBox(
                width: 12,
              ),
              itemBuilder: (context, index) {
                final base = bookmarkList[index].baseCurrency;
                return GestureDetector(
                  onTap: () {
                    //TODO 계산
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(6),
                    child: CountryFlag.fromCurrencyCode(base),
                  ),
                );
              },
            ),
          ),
          //추가버튼
          GestureDetector(
            onTap: () {
              //TODO 전체 국가 리스트
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 1.5),
              ),
              child: const Icon(
                Icons.public,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
