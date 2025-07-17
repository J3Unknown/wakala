import 'package:flutter/material.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

class AppConstants{
  static const String imagePath = 'assets/images/';
  static const String iconsImagePath = 'assets/images/icons/';
  static const String baseUrl = 'https://wikala.org/wikala/api/';
  static const String baseImageUrl = 'https://wikala.org/wikala/';

  //!caches
  //*Authentication
  static bool isGuest = false;
  static bool isAuthenticated = false;
  static int userId = -1;

  //*system
  static String locale = 'en';
  static bool isNotificationsActive = true;

  //*UX
  static bool finishedOnBoarding = false;
  static String token = '';

  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static List<PairOfIdAndName> paymentOptions = [PairOfIdAndName.fromJson({'id':1,'name':LocalizationService.translate(StringsManager.cash)})];

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
  PairOfIdAndName.fromJson({'id':1, 'name': StringsManager.exchange}),
  PairOfIdAndName.fromJson({'id':2, 'name': StringsManager.auction}),
  PairOfIdAndName.fromJson({'id':3, 'name': StringsManager.sale}),
];

class ProductTypeData{
  String type = StringsManager.sale;
  Color color = ColorsManager.amber;
  ProductTypeData(this.type, this.color);
}

List<ProductTypeData> _productTypesList = [
  ProductTypeData(StringsManager.sale, ColorsManager.amber),
  ProductTypeData(StringsManager.exchange, ColorsManager.cyan),
  ProductTypeData(StringsManager.auction, ColorsManager.red)
];

ProductTypeData getProductType(String? type){
  switch(type){
    case StringsManager.sale:
      return _productTypesList[0];
    case StringsManager.exchange:
      return _productTypesList[1];
    case StringsManager.auction:
      return _productTypesList[2];
    default:
      return _productTypesList[0];
  }
}