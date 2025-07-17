import 'package:flutter/cupertino.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

class LocaleChanger extends ChangeNotifier{
  static String _language = 'en';

  String get getLanguage => _language;

  void changeLocale(String newLanguage) async{
    _language = newLanguage;
    AppConstants.locale = _language;
    await CacheHelper.saveData(key: KeysManager.locale, value: _language);
    notifyListeners();
    LocalizationService().changeLanguage(newLanguage);
  }

  Future<void> initializeLocale() async{
    _language = await CacheHelper.getData(key: KeysManager.locale)??'en';
    AppConstants.locale = _language;
    notifyListeners();
    LocalizationService().changeLanguage(_language);
  }
}