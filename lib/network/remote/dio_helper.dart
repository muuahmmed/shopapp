import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic> query = const {},
    String lang = 'en',
    String? token,
  }) async {
    if (dio == null) {
      throw Exception("Dio is not initialized. Call DioHelper.init() first.");
    }

    dio!.options.headers = {
      'Content-Type':'application/json',
      'lang': lang,
      'Authorization': token,
    };

    try {
      Response response = await dio!.get(url, queryParameters: query);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    if (dio == null) {
      throw Exception("Dio is not initialized. Call DioHelper.init() first.");
    }

    dio!.options.headers = {
      'Content-Type':'application/json',
      'lang': lang,
      'Authorization': token,
    };

    try {
      Response response = await dio!.post(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    if (dio == null) {
      throw Exception("Dio is not initialized. Call DioHelper.init() first.");
    }

    dio!.options.headers = {
      'Content-Type':'application/json',
      'lang': lang,
      'Authorization': token,
    };

    try {
      Response response = await dio!.put(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
