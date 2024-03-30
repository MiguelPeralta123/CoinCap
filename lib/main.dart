import 'dart:convert';

import 'package:coincap/models/app_config.dart';
import 'package:coincap/pages/home_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  // Make sure the app has initialized before loading the config file
  WidgetsFlutterBinding.ensureInitialized();
  // Load config files before running the app
  await loadConfig();
  // HttpService constructor requires the instance of AppConfig
  registerHttpService();
  await GetIt.instance.get<HttpService>().get("/coins/bitcoin");
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  // Load config file content as a string
  String configContent = await rootBundle.loadString("assets/config/main.json");
  // Convert it to a map
  Map configData = jsonDecode(configContent);
  // Create a GetIt service to access an instance of AppConfig from any file in the project
  GetIt.instance.registerSingleton<AppConfig>(
    // Create the AppConfig instance
    AppConfig(coinApiBaseUrl: configData["COIN_API_BASE_URL"]),
  );
}

void registerHttpService() {
  GetIt.instance.registerSingleton<HttpService>(
    HttpService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}