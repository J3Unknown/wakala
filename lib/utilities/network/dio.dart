import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';

class DioHelper{
  static Dio dio = Dio();

  static void init() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
      },
      receiveDataWhenStatusError: true,
      followRedirects: false,
      validateStatus: (status) => status! < 500,
    );

    dio = Dio(options)..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'Accept':'application/json',
      'lang':AppConstants.locale,
      'Authorization': 'Bearer ${AppConstants.token}',
    };
    return await dio.get(path, queryParameters: query ?? {}, data: data??{});
  }

  static Future<Response> putData({
   required String url,
   Map<String, dynamic>? query,
   required Map<String, dynamic> data,
  Options? options,
  }) async{

    dio.options.headers = {
      'Content-Type':'application/json',
      'lang' : AppConstants.locale,
      'Authorization': 'Bearer ${AppConstants.token}'
    };

    return dio.put(url, queryParameters: query??{}, data: data, options: options);
  }

  static Future<Response> postData(
    {
      required String url,
      Map<String, dynamic>? query,
      Map<String, dynamic>? data,
      Options? options,
    }) async
  {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':AppConstants.locale,
      'Authorization':'Bearer ${AppConstants.token}',
    };
    var response = dio.post(url, queryParameters: query, data: data??{}, options: options);
    return response;
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':AppConstants.locale,
      'Authorization':'Bearer ${AppConstants.token}'
    };
    return dio.delete(url,queryParameters: query??{}, data: data??{});
  }

}