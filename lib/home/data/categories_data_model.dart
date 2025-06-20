class CategoriesDataModel {
  bool? success;
  Result? result;
  String? msg;

  CategoriesDataModel({this.success, this.result, this.msg});

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
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
  late List<Categories> categories;
  late List<Sliders> sliders;

  Result({required this.categories, required this.sliders});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['categories'].isNotEmpty) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(Categories.fromJson(v));
      });
    }
    if (json['sliders'].isNotEmpty) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders.add(Sliders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories.isNotEmpty) {
      data['categories'] = categories.map((v) => v.toJson()).toList();
    }
    if (sliders.isNotEmpty) {
      data['sliders'] = sliders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  late int id;
  late String name;
  late String image;
  int? endPoint;
  int? parentId;
  int? order;
  List<Categories>? subCategories;

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    endPoint = json['end_point'];
    if(parentId != null){
      parentId = json['parent_id'];
    }
    if(order != null){
      order = json['order'];
    }
    if (json['end_point'] != null && json['end_point'] != 1) {
      subCategories = <Categories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['end_point'] = endPoint;
    if (endPoint != null && endPoint != 1) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sliders {
  late int id;
  late String name;
  late String link;

  Sliders({required this.id, required this.name, required this.link});

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link'] = link;
    return data;
  }
}
