import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:exchange_calculator/view/screen/country_screen.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkPart extends StatefulWidget {
  const BookmarkPart({super.key});

  @override
  State<BookmarkPart> createState() => _BookmarkPartState();
}

class _BookmarkPartState extends State<BookmarkPart> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExchangeRateViewModel>();
    final bookmarks = vm.getBookmarks();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        children: [
          //북마크 리스트
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: 10,
              ),
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                final bookmark = bookmarks[index];
                final isSelected = vm.selectedIndex == index;

                return _bookmarkBtn(vm, bookmark, index, isSelected);
              },
            ),
          ),
          //add 버튼
          _addBtn(context),
        ],
      ),
    );
  }

  GestureDetector _bookmarkBtn(ExchangeRateViewModel vm, ExchangeRate bookmark,
      int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        //선택된 국가 화폐로 계산
        vm.onSelectTarget(bookmark, index);
//
      },
      child: AnimatedContainer(
        width: 56,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Colors.blue,
                  width: 4,
                )
              : Border.all(
                  color: Colors.grey.shade600,
                  width: 3,
                ),
        ),
        child: CountryFlag.fromCurrencyCode(
          bookmark.baseCurrency,
          theme: const ImageTheme(
            shape: Circle(),
          ),
        ),
      ),
    );
  }

  Widget _addBtn(BuildContext context) {
    return IconButton(
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
        color: Colors.blue,
      ),
    );
  }
}
