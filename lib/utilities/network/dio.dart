import 'package:dio/dio.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';

class DioHelper{
  static Dio dio = Dio();

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
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
  }) async{

    dio.options.headers = {
      'Content-Type':'application/json',
      'lang' : AppConstants.locale,
      'Authorization': 'Bearer ${AppConstants.token}'
    };

    return dio.put(url, queryParameters: query??{}, data: data,);
  }

  static Future<Response> postData(
    {
      required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic>? data,
    }) async
  {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':AppConstants.locale,
      'Authorization':'Bearer ${AppConstants.token}',
    };
    return dio.post(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':AppConstants.locale,
      'Authorization':'Bearer ${AppConstants.token}'
    };
    return dio.delete(url,queryParameters: query??{});
  }

}