import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 1), () => Navigator.pushAndRemoveUntil(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.authLayout)), (route) => false),);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: ColorsManager.transparent, body: SizedBox.expand(child: Image.asset(AssetsManager.splashScreen, fit: BoxFit.cover,)));
  }
}
