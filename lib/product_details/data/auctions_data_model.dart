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
  int? id;
  User? user;
  int? adId;
  String? price;
  String? createdAt;
  String? updatedAt;

  Auction.fromJson(Map<String, dynamic> json){
    id = json['id'];
    user = User.fromJson(json['user_id']);
    adId = json['ad_id'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}