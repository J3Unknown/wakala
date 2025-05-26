import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/auth_layout.dart';
import 'package:wakala/auth/presentation/view/screens/forgot_password.dart';
import 'package:wakala/auth/presentation/view/screens/login_screen.dart';
import 'package:wakala/auth/presentation/view/screens/otp_screen.dart';
import 'package:wakala/auth/presentation/view/screens/sign_up_screen.dart';
import 'package:wakala/chat/presentation/view/screens/chat_screen.dart';
import 'package:wakala/chat/presentation/view/screens/chats_list_screen.dart';
import 'package:wakala/commercial_details/presentation/view/commercial_details.dart';
import 'package:wakala/home/presentation/view/home_layout.dart';
import 'package:wakala/home/presentation/view/screens/full_post_screen.dart';
import 'package:wakala/my_ads/presentation/view/my_ads_screen.dart';
import 'package:wakala/notifications/presentation/view/notifications_screen.dart';
import 'package:wakala/on_boarding/presentation/view/on_boarding.dart';
import 'package:wakala/product_details/presentation/view/product_details_screen.dart';
import 'package:wakala/profile/presentation/view/profile_screen.dart';
import 'package:wakala/recently_viewed/presentation/view/recently_viewed_screen.dart';
import 'package:wakala/saved/presentation/view/saved_screen.dart';
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
  static const String notifications = '/notifications';
  static const String chatsList = '/chatsList';
  static const String chat = '/chatsList/chat';
  static const String myAds = '/myAds';
  static const String recentlyViewing = '/recentlyViewing';
  static const String saved = '/saved';
  static const String profile = '/profile';
  static const String commercialDetails = '/commercialDetails';
  static const String fullPost = '/fullPost';
  static const String productDetails = '/productDetails';
}

class RoutesGenerator{
  static Route<dynamic> getRoute(RouteSettings settings){
    switch(settings.name){
      case Routes.splashScreen:
        return  MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnBoarding());
      case Routes.authLayout:
        return MaterialPageRoute(builder: (_) => AuthLayout());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen(), settings: settings);
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen(), settings: settings);
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case Routes.otp:
        return MaterialPageRoute(builder: (_) => OtpScreen(phone: settings.arguments! as String));
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      case Routes.fullPost:
        return MaterialPageRoute(builder: (_) => FullPostScreen());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case Routes.chatsList:
        return MaterialPageRoute(builder: (_) => ChatsListScreen());
      case Routes.chat:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case Routes.myAds:
        return MaterialPageRoute(builder: (_) => MyAdsScreen());
      case Routes.recentlyViewing:
        return MaterialPageRoute(builder: (_) => RecentlyViewedScreen());
      case Routes.saved:
        return MaterialPageRoute(builder: (_) => SavedScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case Routes.commercialDetails:
        return MaterialPageRoute(builder: (_) => CommercialDetails());
      case Routes.productDetails:
        return MaterialPageRoute(builder: (_) => ProductDetailsScreen());
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

