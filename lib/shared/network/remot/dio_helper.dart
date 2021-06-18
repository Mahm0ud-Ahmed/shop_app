import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/component/constants.dart';

class SallaDioHelper {
  static Dio _dio;

  static void initialDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    @required String endPointUrl,
    Map<String, dynamic> query,
    String token,
    // String lang = 'en',
  }) async {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await _dio.get(
      endPointUrl,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    @required String endPointUrl,
    @required Map<String, dynamic> data,
    Map<String, dynamic> query,
    String token,
    // String lang = 'en',
  }) async {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await _dio.post(
      endPointUrl,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    @required String endPointUrl,
    @required Map<String, dynamic> data,
    String token,
    // String lang = 'en',
  }) async {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await _dio.put(
      endPointUrl,
      data: data,
    );
  }
}
