import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map currentPrices;

  const DetailsPage({super.key, required this.currentPrices});

  @override
  Widget build(BuildContext context) {
    List<dynamic> currencies = currentPrices.keys.toList();
    List<dynamic> prices = currentPrices.values.toList();

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            String currency = currencies[index].toString().toUpperCase();
            String price = prices[index].toString();
            return ListTile(
              title: Text(
                "$currency: $price",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          },
        )
      ),
    );
  }
}