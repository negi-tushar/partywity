import 'package:dio/dio.dart';

class DioClient {
  static const String baseUrl = "https://admin.partywitty.com/master/Api/";

  static Dio getInstance() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10), 
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Origin': 'https://www.partywity.com',
        },
      ),
    );

    // Logger for debugging API calls in the console
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print("API_LOG: $obj"),
    ));

    return dio;
  }
}