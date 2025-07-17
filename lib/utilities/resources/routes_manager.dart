import 'package:flutter/material.dart';
import 'package:wakala/about_us/presentation/view/about_us.dart';
import 'package:wakala/about_us/presentation/view/support_screen.dart';
import 'package:wakala/about_us/presentation/view/terms_and_conditions_screen.dart';
import 'package:wakala/auth/data/otp_screen_arguments.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/auth/presentation/view/auth_layout.dart';
import 'package:wakala/auth/presentation/view/screens/forgot_password.dart';
import 'package:wakala/auth/presentation/view/screens/login_screen.dart';
import 'package:wakala/auth/presentation/view/screens/otp_screen.dart';
import 'package:wakala/auth/presentation/view/screens/sign_up_screen.dart';
import 'package:wakala/chat/presentation/view/screens/chat_screen.dart';
import 'package:wakala/chat/presentation/view/screens/chats_list_screen.dart';
import 'package:wakala/commercial_details/presentation/view/commercial_details.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/home/presentation/view/home_layout.dart';
import 'package:wakala/home/presentation/view/screens/full_post_screen.dart';
import 'package:wakala/my_ads/presentation/view/my_ads_screen.dart';
import 'package:wakala/notifications/presentation/view/notifications_screen.dart';
import 'package:wakala/on_boarding/presentation/view/on_boarding.dart';
import 'package:wakala/product_details/presentation/view/product_details_screen.dart';
import 'package:wakala/profile/data/add_address_arguments.dart';
import 'package:wakala/profile/presentation/view/add_address_screen.dart';
import 'package:wakala/profile/presentation/view/addresses_list_screen.dart';
import 'package:wakala/profile/presentation/view/create_password_screen.dart';
import 'package:wakala/profile/presentation/view/edit_profile_screen.dart';
import 'package:wakala/profile/presentation/view/profile_screen.dart';
import 'package:wakala/recently_viewed/presentation/view/recently_viewed_screen.dart';
import 'package:wakala/saved/presentation/view/saved_screen.dart';
import 'package:wakala/search_screen/presentation/view/search_screen.dart';
import 'package:wakala/splash_screen/presentation/view/splash_screen.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
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
  static const String editProfile = '/profile/edit';
  static const String createPassword = '/profile/edit/createPassword';
  static const String addressesList = '/profile/edit/addressesList';
  static const String addAddress = '/profile/edit/addressesList/addAddress';
  static const String commercialDetails = '/commercialDetails';
  static const String fullPost = '/fullPost';
  static const String productDetails = '/productDetails';
  static const String aboutUs = '/aboutUs';
  static const String termsAndConditions = '/termsAndConditions';
  static const String support = '/support';
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
        return MaterialPageRoute(builder: (_) => OtpScreen(), settings: settings);
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeLayout());
      case Routes.fullPost:
        return MaterialPageRoute(builder: (_) => FullPostScreen(ad: settings.arguments! as CommercialAdItem,));
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen(), settings: settings);
      case Routes.chatsList:
        return MaterialPageRoute(builder: (_) => ChatsListScreen());
      case Routes.chat:
        return MaterialPageRoute(builder: (_) => ChatScreen(), settings: settings);
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case Routes.myAds:
        return MaterialPageRoute(builder: (_) => MyAdsScreen());
      case Routes.recentlyViewing:
        return MaterialPageRoute(builder: (_) => RecentlyViewedScreen());
      case Routes.saved:
        return MaterialPageRoute(builder: (_) => SavedScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen(), settings: settings);
      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen(), settings: settings);
      case Routes.createPassword:
        return MaterialPageRoute(builder: (_) => CreatePasswordScreen());
      case Routes.addressesList:
        return MaterialPageRoute(builder: (_) => AddressesListScreen());
      case Routes.addAddress:
        return MaterialPageRoute(builder: (_) => AddAddressScreen(), settings: settings);
      case Routes.commercialDetails:
        return MaterialPageRoute(builder: (_) => CommercialDetails(id: settings.arguments! as int,));
      case Routes.productDetails:
        return MaterialPageRoute(builder: (_) => ProductDetailsScreen(id: settings.arguments! as int,));
      case Routes.support:
        return MaterialPageRoute(builder: (_) => SupportScreen());
      case Routes.aboutUs:
        return MaterialPageRoute(builder: (_) => AboutUs());
      case Routes.termsAndConditions:
        return MaterialPageRoute(builder: (_) => TermsAndConditionsScreen());
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

