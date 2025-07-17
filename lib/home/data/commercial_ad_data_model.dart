class CommercialAdDataModel {
  late bool success;
  Result? result;
  String? msg;

  CommercialAdDataModel({required success, result, msg});

  CommercialAdDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    msg = json['msg'];
  }

}

class Result {
  List<CommercialAdItem>? commercialAdsItems;
  late Pagination pagination;

  Result({items, required pagination});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      commercialAdsItems = <CommercialAdItem>[];
      json['items'].forEach((v) {
        commercialAdsItems!.add(CommercialAdItem.fromJson(v));
      });
    }
    pagination = Pagination.fromJson(json['pagination']);
  }

}

class CommercialAdItem {
  late int id;
  late int categoryId;
  late int userId;
  late int typeId;
  late int cityId;
  late int regionId;
  String? adNumber;
  int? price;
  late String title;
  String? description;
  String? contactMethod;
  late int negotiable;
  late int isCommercial;
  String? status;
  String? startDate;
  String? endDate;
  String? mainImage;
  String? createdAt;
  String? updatedAt;
  PairOfIdAndName? adsType;
  PairOfIdAndName? city;
  PairOfIdAndName? region;
  PairOfIdAndName? category;

  CommercialAdItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    typeId = json['type_id'];
    cityId = json['city_id'];
    regionId = json['region_id'];
    adNumber = json['ad_number'];
    title = json['title'];
    description = json['description'];
    contactMethod = json['contact_method'];
    negotiable = json['negotiable'];
    status = json['status'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    mainImage = json['main_image'];
    createdAt = json['created_at'];
    isCommercial= json['is_commercial']??0;
    updatedAt = json['updated_at'];
    if(json['ads_type'] != null) {
      adsType = PairOfIdAndName.fromJson(json['ads_type']);
    }
    if(json['city'] != null){
      city = PairOfIdAndName.fromJson(json['city']);
    }
    if(json['region'] != null){
      region = PairOfIdAndName.fromJson(json['region']);
    }
    if(json['category'] != null){
      category = PairOfIdAndName.fromJson(json['category']);
    }

  }

}

class PairOfIdAndName{
  int? id;
  String? name;

  PairOfIdAndName.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination({total, perPage, currentPage, lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }
}
