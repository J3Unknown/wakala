import 'package:flutter/material.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
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
      selectedLabelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(size: AppSizesDouble.s30),
    ),

  );
}