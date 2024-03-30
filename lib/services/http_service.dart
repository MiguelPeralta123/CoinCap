import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/app_config.dart';

class HttpService {
  final Dio dio = Dio();
  late AppConfig appConfig;
  late String baseUrl;

  HttpService(){
    // Get the instance of AppConfig created with GetIt
    appConfig = GetIt.instance.get<AppConfig>();
    baseUrl = appConfig.coinApiBaseUrl;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$baseUrl$path";
      return await dio.get(url);
    } catch(e) {
      print("HttpService: Get request failed:\n$e");
    }
  }
}