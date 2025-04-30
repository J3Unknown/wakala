import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';

ThemeData lightTheme(){
  return ThemeData(
    scaffoldBackgroundColor: ColorsManager.white,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.white
    )
  );
}