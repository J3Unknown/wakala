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
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };

    return await dio.get(path, queryParameters: query ?? {});
  }

  static Future<Response> putData({
   required String url,
   Map<String, dynamic>? query,
   required Map<String, dynamic> data,
   String lang = 'en',
   String? token,
  }) async{

    dio.options.headers = {
      'Content-Type':'application/json',
      'lang' : lang,
      'Authorization':token??''
    };

    return dio.put(url, queryParameters: query??{}, data: data,);
  }

  static Future<Response> postData(
    {
      required String url,
      Map<String, dynamic>? query,
      required Map<String, dynamic>? data,
      String lang = 'en',
      String? token,
    }) async
  {
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return dio.post(url, queryParameters: query, data: data);
  }

}