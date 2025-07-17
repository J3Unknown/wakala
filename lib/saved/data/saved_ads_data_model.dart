class SavedAdsDataModel{
  bool? status;
  List<SavedAd>? result;
  String? message;

  SavedAdsDataModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['msg'];
    result = [];
    if(json['result'] != null && json['result'].isNotEmpty){
      json['result'].forEach((e){
        result!.add(SavedAd.fromJson(e));
      });
    }
  }
}

class SavedAd{
  int? id;
  int? userId;
  int? adId;
  String? createdAt;
  String? updatedAt;
  Ad? ad;
  SavedAd.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    adId = json['ad_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ad = json['ad'] != null?Ad.fromJson(json['ad']):null;
  }
}

class Ad{
  late int isCommercial;
  int? id;
  int? userId;
  int? categoryId;
  int? typeId;
  int? cityId;
  int? regionId;
  int? rejectedId;
  int? price;
  int? negotiable;
  String? adNumber;
  String? title;
  String? description;
  String? contactMethod;
  String? status;
  String? startDate;
  String? endDate;
  String? mainImage;
  String? createdAt;
  String? updatedAt;

  Ad.fromJson(Map<String, dynamic> json){
    id = json['id'];
    isCommercial = json['is_commercial']??0;
    userId = json['user_id'];
    categoryId = json['category_id'];
    typeId = json['type_id'];
    cityId = json['city_id'];
    regionId = json['region_id'];
    rejectedId = json['rejected_id'];
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
  }
}