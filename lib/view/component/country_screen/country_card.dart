import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';

class CountryCard extends StatefulWidget {
  final ExchangeRateViewModel vm;
  final ExchangeRate rate;

  const CountryCard({
    super.key,
    required this.vm,
    required this.rate,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.vm.toggleBookmark(widget.rate.baseCurrency);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.rate.isBookmark
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.black,
          border: widget.rate.isBookmark
              ? Border.all(
                  color: Colors.blue,
                  width: 3,
                )
              : Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //북마크 아이콘
            Icon(
              widget.rate.isBookmark ? Icons.star : Icons.star_border,
              color: widget.rate.isBookmark ? Colors.amber : Colors.grey,
            ),
            const SizedBox(
              width: 8,
            ),
            //국기 및 통화코드
            _flagAndCode(),
          ],
        ),
      ),
    );
  }

  Row _flagAndCode() {
    return Row(
            children: [
              CountryFlag.fromCurrencyCode(
                widget.rate.baseCurrency,
                theme: const ImageTheme(
                  shape: Circle(),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                widget.rate.baseCurrency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          );
  }
}
