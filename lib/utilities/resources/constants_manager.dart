import 'package:flutter/material.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';

class AppConstants{
  static const String imagePath = 'assets/images/';
  static const String iconsImagePath = 'assets/images/icons/';
  static const String baseUrl = 'https://wikala.org/wikala/api/';
  static const String baseImageUrl = 'https://wikala.org/wikala/';

  //!caches
  //*Authentication
  static bool isGuest = false;
  static bool isAuthenticated = false;

  //*system
  static String locale = 'en';
  static bool isNotificationsActive = true;

  //*UX
  static bool finishedOnBoarding = false;
  static String token = '';

}

PairOfIdAndName getTypeById(int id){
  switch(id){
    case 1:
      return productsTypes[0];
    case 2:
      return productsTypes[1];
    case 3:
      return productsTypes[2];
    default:
      return productsTypes[2];
  }
}
List<PairOfIdAndName> productsTypes = [
  PairOfIdAndName.fromJson({'id':1, 'name':'Exchange'}),
  PairOfIdAndName.fromJson({'id':2, 'name':'Auction'}),
  PairOfIdAndName.fromJson({'id':3, 'name':'Sale'}),
];
class ProductTypeData{
  String type = "sale";
  Color color = ColorsManager.amber;
  ProductTypeData(this.type, this.color);
}

List<ProductTypeData> _productTypesList = [
  ProductTypeData('Sale', ColorsManager.amber),
  ProductTypeData('Exchange', ColorsManager.cyan),
  ProductTypeData('Auction', ColorsManager.red)
];

ProductTypeData getProductType(String? type){
  switch(type){
    case 'Sale':
      return _productTypesList[0];
    case 'Exchange':
      return _productTypesList[1];
    case 'Auction':
      return _productTypesList[2];
    default:
      return _productTypesList[0];
  }
}