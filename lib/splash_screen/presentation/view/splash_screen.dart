import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

import '../../../utilities/resources/values_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: AppSizes.s2), () => _reNavigate());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox.expand(child: SvgPicture.asset(AssetsManager.splashScreen, fit: BoxFit.cover,)));
  }

  void _reNavigate(){
    if(AppConstants.finishedOnBoarding == true){
      if(AppConstants.isGuest == true){
        Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.home)));
      } else{
        if(AppConstants.isAuthenticated == true){
          Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.home)));
        }else{
          Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.authLayout)));
        }
      }
    } else{
        Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.onBoarding)));
    }
  }
}
