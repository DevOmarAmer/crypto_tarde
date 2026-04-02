import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String binanceBaseUrl = 'https://api.binance.com/api/v3';

  late final Dio coinGeckoDio;
  late final Dio binanceDio;

  DioClient() {
    coinGeckoDio = Dio(
      BaseOptions(
        baseUrl: coinGeckoBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    binanceDio = Dio(
      BaseOptions(
        baseUrl: binanceBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add logging and custom interceptors
    _addInterceptors(coinGeckoDio);
    _addInterceptors(binanceDio);
  }

  void _addInterceptors(Dio dio) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    // TODO: Add caching interceptor or other standard interceptors
  }
}
