import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';

class AppConstants{
  static const String imagePath = 'assets/images/';
  static const String iconsImagePath = 'assets/images/icons/';
  static const String baseUrl = 'https://wikala.org/api/';

  //!caches
  static bool isGuest = false;
  static bool finishedOnBoarding = false;
  static bool isAuthenticated = false;
  static String locale = 'en';
}

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

ProductTypeData getProductType(String type){
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