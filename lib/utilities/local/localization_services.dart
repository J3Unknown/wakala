import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();
  static String translate(String key) => _instance.translateKey(key);
  Map<String, dynamic> _enStrings = {};
  Map<String, dynamic> _arStrings = {};
  String _currentLanguage = 'en';

  Future<void> init() async {
    _enStrings = await _loadJson('en');
    _arStrings = await _loadJson('ar');
  }

  Future<Map<String, dynamic>> _loadJson(String languageCode) async {
    final jsonStr = await rootBundle.loadString('assets/lang/$languageCode.json');
    return json.decode(jsonStr);
  }

  String translateKey(String key) {
    switch (_currentLanguage) {
      case 'en':
        return _enStrings[key] ?? key;
      case 'ar':
        return _arStrings[key] ?? key;
      default:
        return key;
    }
  }

  void changeLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }
}