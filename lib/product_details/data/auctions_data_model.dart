import 'package:wakala/home/data/specific_ad_data_model.dart';

class AuctionsDataModel{
  late bool success;
  late List<Auction> result;
  String? message;

  AuctionsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    result = [];
    if(json['result'] != null){
      json['result'].forEach((e){
        result.add(Auction.fromJson(e));
      });
    }
    message = json['msg'];
  }
}

class Auction{
  late int id;
  late User user;
  late int adId;
  late String price;
  late String createdAt;
  late String updatedAt;

  Auction.fromJson(Map<String, dynamic> json){
    id = json['id'];
    user = User.fromJson(json['user_id']);
    adId = json['ad_id'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}