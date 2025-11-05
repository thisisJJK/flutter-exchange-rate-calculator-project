import 'package:exchange_calculator/view/screen/cal_screen.dart';
import 'package:exchange_calculator/viewmodel/exchange_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final vm = context.read<ExchangeRateViewModel>();
    await Future.wait([
      vm.loadRates(),
      Future.delayed(
        const Duration(seconds: 2),
      )
    ]);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CalScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          child: const Center(
            child: Text('logo'),
          ),
        ),
      ),
    );
  }
}
