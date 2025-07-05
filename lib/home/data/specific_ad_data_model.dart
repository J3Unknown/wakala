import 'package:wakala/home/data/commercial_ad_data_model.dart';

class SpecificAdDataModel {
  late bool success;
  Result? result;
  String? msg;

  SpecificAdDataModel({required success, result, msg});

  SpecificAdDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
    msg = json['msg'];
  }
}

class Result {
  Ad? ad;
  List<CommercialAdItem>? relatedAds;

  Result.fromJson(Map<String, dynamic> json) {
    ad = json['ad'] != null ? Ad.fromJson(json['ad']) : null;
    if (json['related_ads'] != null) {
      relatedAds = <CommercialAdItem>[];
      json['related_ads'].forEach((v) {
        relatedAds!.add(CommercialAdItem.fromJson(v));
      });
    }
  }
}

class Ad {
  int? id;
  int? categoryId;
  int? userId;
  int? typeId;
  int? cityId;
  int? regionId;
  String? adNumber;
  int? price;
  String? title;
  String? description;
  String? contactMethod;
  int? negotiable;
  String? status;
  String? startDate;
  String? endDate;
  String? mainImage;
  String? createdAt;
  String? updatedAt;
  List<AdImage>? images;
  User? user;

  Ad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    typeId = json['type_id'];
    cityId = json['city_id'];
    regionId = json['region_id'];
    adNumber = json['ad_number'];
    price = json['price'];
    title = json['title'];
    description = json['description'];
    contactMethod = json['contact_method'];
    negotiable = json['negotiable'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    mainImage = json['main_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['images'] != null) {
      images = <AdImage>[];
      json['images'].forEach((v) {
        images!.add(AdImage.fromJson(v));
      });
    }
    if(json['user'] != null){
      user = json['user'] != null ? User.fromJson(json['user']) : null;
    }
  }
}

class AdImage{
  late int id;
  late int adId;
  late String image;
  late String createdAt;
  late String updatedAt;

  AdImage.fromJson(Map<String, dynamic> json){
    id = json['id'];
    adId = json['ad_id'];
    image = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class User {
  late int id;
  late String name;
  String? image;
  String? phone;

  User({required this.id, required this.name, this.image, this.phone});
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    phone = json['phone'];
  }

}
