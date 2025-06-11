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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class Result {
  Ad? ad;
  List<RelatedAds>? relatedAds;

  Result({ad, relatedAds});

  Result.fromJson(Map<String, dynamic> json) {
    ad = json['ad'] != null ? Ad.fromJson(json['ad']) : null;
    if (json['related_ads'] != null) {
      relatedAds = <RelatedAds>[];
      json['related_ads'].forEach((v) {
        relatedAds!.add(RelatedAds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ad != null) {
      data['ad'] = ad!.toJson();
    }
    if (relatedAds != null) {
      data['related_ads'] = relatedAds!.map((v) => v.toJson()).toList();
    }
    return data;
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
  List<String>? images;
  User? user;

  Ad(
      {id,
        categoryId,
        userId,
        typeId,
        cityId,
        regionId,
        adNumber,
        title,
        description,
        contactMethod,
        negotiable,
        status,
        startDate,
        endDate,
        mainImage,
        createdAt,
        updatedAt,
        images,
        user});

  Ad.fromJson(Map<String, dynamic> json) {
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
    startDate = json['start_date'];
    endDate = json['end_date'];
    mainImage = json['main_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['type_id'] = typeId;
    data['city_id'] = cityId;
    data['region_id'] = regionId;
    data['ad_number'] = adNumber;
    data['title'] = title;
    data['description'] = description;
    data['contact_method'] = contactMethod;
    data['negotiable'] = negotiable;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['main_image'] = mainImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // if (images != null) {
    //   data['images'] = images!.map((v) => v.toJson()).toList();
    // }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  late int id;
  late String name;
  String? image;

  User({required this.id, required this.name, image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class RelatedAds {
  int? id;
  int? categoryId;
  int? userId;
  int? typeId;
  int? cityId;
  int? regionId;
  String? adNumber;
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

  RelatedAds(
      {id,
        categoryId,
        userId,
        typeId,
        cityId,
        regionId,
        adNumber,
        title,
        description,
        contactMethod,
        negotiable,
        status,
        startDate,
        endDate,
        mainImage,
        createdAt,
        updatedAt});

  RelatedAds.fromJson(Map<String, dynamic> json) {
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
    startDate = json['start_date'];
    endDate = json['end_date'];
    mainImage = json['main_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['type_id'] = typeId;
    data['city_id'] = cityId;
    data['region_id'] = regionId;
    data['ad_number'] = adNumber;
    data['title'] = title;
    data['description'] = description;
    data['contact_method'] = contactMethod;
    data['negotiable'] = negotiable;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['main_image'] = mainImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
