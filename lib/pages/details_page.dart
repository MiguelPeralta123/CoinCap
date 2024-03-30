import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String coinName;
  final Map currentPrices;

  const DetailsPage({super.key, required this.coinName, required this.currentPrices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            coinNameWidget(),
            pricesListView(),
            goBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget coinNameWidget() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        coinName,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget pricesListView() {
    List<dynamic> currencies = currentPrices.keys.toList();
    List<dynamic> prices = currentPrices.values.toList();

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(83, 88, 206, 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
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
                  fontSize: 18,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget goBackButton(context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "Back",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}