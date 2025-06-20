import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';

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

}

class Result {
  List<Categories>? categories;
  List<HomePageSliders>? sliders;
  List<TopSectionDataModel>? homePageProducts;

  Result({this.categories, this.sliders, this.homePageProducts});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }

    if (json['sliders'] != null) {
      sliders = <HomePageSliders>[];
      json['sliders'].forEach((v) {
        sliders!.add( HomePageSliders.fromJson(v));
      });
    }

    if (json['HomePageCategories'] != null) {
      homePageProducts = <TopSectionDataModel>[];
      json['HomePageCategories'].forEach((v) {
        homePageProducts!.add(TopSectionDataModel.fromJson(v));
      });
    }
  }

}

class TopSectionDataModel{
  late int id;
  late int categoryId;
  late String name;
  late CategoryInfo categoryInfo;

  TopSectionDataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    categoryInfo = CategoryInfo.fromJson(json['category']);
  }

}

class CategoryInfo{
  late int id;
  int? rank;
  int? parentId;
  late String nameInAr;
  late String nameInEn;
  late String image;
  late int endPoint;
  late int orders;
  List<CommercialAdItem>? ads;

  CategoryInfo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    rank = json['rank'];
    parentId = json['parent_id'];
    nameInAr = json['name_ar'];
    nameInEn = json['name_en'];
    image = json['image'];
    endPoint = json['end_point'];
    orders = json['order'];
    if(json['ads'] != null){
      ads = [];
      json['ads'].forEach((v) => ads?.add(CommercialAdItem.fromJson(v)));
    }
  }
}

class HomePageSliders {
  int? id;
  String? name;
  String? link;

  HomePageSliders({this.id, this.name, this.link});

  HomePageSliders.fromJson(Map<String, dynamic> json) {
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
