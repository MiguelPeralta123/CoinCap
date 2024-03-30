import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double deviceHeight, deviceWidth;
  late HttpService http;
  late String selectedCoin;

  @override
  void initState() {
    super.initState();
    http = GetIt.instance.get<HttpService>();
    selectedCoin = "Bitcoin";
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              coinDropDownButton(),
              coinData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget coinDropDownButton() {
    List<String> coins = [
      "Bitcoin",
      "Ethereum",
      "Tether",
      "Cardano",
      "Ripple",
    ];

    List<DropdownMenuItem<String>> items = coins.map((coin) {
      return DropdownMenuItem(
        value: coin,
        child: Text(
          coin,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    },).toList();

    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: DropdownButton(
        items: items,
        onChanged: (value) {
          setState(() {
            selectedCoin = value.toString();
          });
        },
        value: selectedCoin,
        dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
        icon: const Icon(
          Icons.arrow_drop_down_sharp,
          color: Colors.white,
        ),
        iconSize: 30,
        underline: Container(),
      ),
    );
  }

  Widget coinData() {
    return FutureBuilder(
      future: http.get("/coins/${selectedCoin.toLowerCase()}"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          String imageUrl = data["image"]["large"];
          num changePercentage = data["market_data"]["price_change_percentage_24h"];
          String description = data["description"]["en"] != "" ? data["description"]["en"] : "No description available";
          Map currentPrices = data["market_data"]["current_price"];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              coinImageWidget(imageUrl),
              currentPriceWidget(currentPrices["usd"]),
              changePercentageWidget(changePercentage),
              coinDescriptionWidget(description),
              seeDetailsButton(context, currentPrices),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget coinImageWidget(String url) {
    return Container(
      height: deviceHeight * 0.15,
      width: deviceWidth * 0.15,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
        ),
      ),
    );
  }

  Widget currentPriceWidget(num usdPrice) {
    return Center(
      child: Text(
        "${usdPrice.toStringAsFixed(2)} USD",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget changePercentageWidget(num changePercentage) {
    return Center(
      child: Text(
        "${changePercentage.toString()}%",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }

  Widget coinDescriptionWidget(String description) {
    return Container(
      height: deviceHeight * 0.45,
      width: deviceWidth * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.05,
        horizontal: 10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.02,
        horizontal: deviceHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(83, 88, 206, 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        description,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget seeDetailsButton(context, currentPrices) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsPage(coinName: selectedCoin, currentPrices: currentPrices);
              },
            ),
          );
        },
        child: const Text(
          "See Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}