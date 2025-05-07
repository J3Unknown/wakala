import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 2), () => Navigator.pushAndRemoveUntil(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.authLayout)), (route) => false),);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox.expand(child: SvgPicture.asset(AssetsManager.splashScreen, fit: BoxFit.cover,)));
  }
}
