import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/auth_layout.dart';
import 'package:wakala/auth/presentation/view/screens/forgot_password.dart';
import 'package:wakala/auth/presentation/view/screens/login_screen.dart';
import 'package:wakala/auth/presentation/view/screens/otp_screen.dart';
import 'package:wakala/auth/presentation/view/screens/sign_up_screen.dart';
import 'package:wakala/home/presentation/view/home_layout.dart';
import 'package:wakala/search_screen/presentation/view/search_screen.dart';
import 'package:wakala/splash_screen/presentation/view/splash_screen.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

class Routes{
  static const String splashScreen = '/';
  static const String onBoarding = '/onBoarding';
  static const String authLayout = '/authLayout';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String search = '/search';
}

class RoutesGenerator{
  static Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.splashScreen:
        return  MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.onBoarding:
        return unDefinedRoute();
      case Routes.authLayout:
        return MaterialPageRoute(builder: (_) => AuthLayout());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen(), settings: settings);
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen(), settings: settings);
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case Routes.otp:
        return MaterialPageRoute(builder: (_) => OtpScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
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

