import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';

class RecentlyViewedDataModel{
  late bool success;
  List<RecentlyViewedItem> result = [];
  String? message;

  RecentlyViewedDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    json['result'].forEach((e) => result.add(RecentlyViewedItem.fromJson(e)));
    message = json['msg'];
  }
}

class RecentlyViewedItem{
  late int id;
  late int userId;
  late int adId;
  late String createdAd;
  late String updatedAt;
  late CommercialAdItem ad;
  late ProfileDataModel user;
  RecentlyViewedItem.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    adId = json['ad_id'];
    createdAd = json['created_at'];
    updatedAt = json['updated_at'];
    ad = CommercialAdItem.fromJson(json['ad']);
    user = ProfileDataModel.fromJson(json['user']);
  }

}

