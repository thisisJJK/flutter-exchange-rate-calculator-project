import 'package:country_flags/country_flags.dart';
import 'package:exchange_calculator/model/exchange_rate.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';

class CountryCard extends StatefulWidget {
  final ExchangeRateViewModel vm;
  final ExchangeRate rate;
  const CountryCard({
    super.key,
    required this.rate,
    required this.vm,
  });

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          widget.vm.toggleBookmark(widget.rate.baseCurrency);
        },
        icon: Icon(
          widget.rate.isBookmark ? Icons.star : Icons.star_border,
          color: widget.rate.isBookmark ? Colors.amber : Colors.grey,
        ),
      ),
      title: Row(
        children: [
          CountryFlag.fromCurrencyCode(
            widget.rate.baseCurrency,
            theme: const ImageTheme(
              shape: Circle(),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            widget.rate.baseCurrency,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Text(
        widget.rate.rate,
        style: const TextStyle(
          fontSize: 21,
        ),
      ),
    );
  }
}
