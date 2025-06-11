import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

ThemeData lightTheme(){
  return ThemeData(
    scaffoldBackgroundColor: ColorsManager.white,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.white
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.white,
      selectedItemColor: ColorsManager.primaryColor,
      unselectedItemColor: ColorsManager.black,
      selectedLabelStyle: TextStyle(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(color: ColorsManager.black),
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(size: AppSizesDouble.s30),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      circularTrackColor: ColorsManager.primaryColor,
      color: ColorsManager.white
    )
  );
}