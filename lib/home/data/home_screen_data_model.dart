class HomePageDataModel {
  bool? success;
  Result? result;
  String? msg;

  HomePageDataModel({this.success, this.result, this.msg});

  HomePageDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['success'] = success;
    if (result != null) {
      data['result'] =result!.toJson();
    }
    data['msg'] = msg;
    return data;
  }
}

class Result {
  List<Categories>? categories;
  List<Sliders>? sliders;
  List<Null>? homePageCategories;

  Result(
      {this.categories, this.sliders, this.homePageCategories});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }

    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add( Sliders.fromJson(v));
      });
    }
    // if (json['HomePageCategories'] != null) {
    //   homePageCategories = <dynamic>[];
    //   json['HomePageCategories'].forEach((v) {
    //     homePageCategories!.add( Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (sliders != null) {
      data['sliders'] = sliders!.map((v) => v.toJson()).toList();
    }
    // if (homePageCategories != null) {
    //   data['HomePageCategories'] =
    //       homePageCategories!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Categories {
  late int id;
  String? image;
  late String name;

  Categories({ required this.id, required this.image, required this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}

class Sliders {
  int? id;
  String? name;
  String? link;

  Sliders({this.id, this.name, this.link});

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
