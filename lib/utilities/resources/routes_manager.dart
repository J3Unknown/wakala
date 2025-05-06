import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/auth_layout.dart';
import 'package:wakala/auth/presentation/view/screens/login_screen.dart';
import 'package:wakala/home/presentation/view/home_layout.dart';
import 'package:wakala/search_screen/presentation/view/search_screen.dart';
import 'package:wakala/splash_screen/presentation/view/splash_screen.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

class Routes{
  static const String splashScreen = '/';
  static const String authLayout = '/authLayout';
  static const String login = '/login';
  static const String onBoarding = '/onBoarding';
  static const String home = '/home';
  static const String search = '/search';
}

class RoutesGenerator{
  static Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.splashScreen:
        return  MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.authLayout:
        return MaterialPageRoute(builder: (_) => AuthLayout());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      // case Routes.onBoarding:
      //   return unDefinedRoute();
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(StringsManager.noRouteFound),
        ),
        body: const Center(child: Text(StringsManager.noRouteFound)),
      )
    );
  }
}

