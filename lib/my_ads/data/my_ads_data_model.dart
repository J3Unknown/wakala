import 'package:wakala/home/data/commercial_ad_data_model.dart';

class MyAdsDataModel{
  late bool success;
  late List<CommercialAdItem> result;
  String? message;

  MyAdsDataModel.fromJson(Map<String, dynamic> json){
    result = [];
    success = json['success'];
    json['result'].forEach((e) => result.add(CommercialAdItem.fromJson(e)));
    message = json['msg'];
  }
}