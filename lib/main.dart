import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/local/locale_changer.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/observer.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/themes_manager.dart';
//import 'package:uni_links/uni_links.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //* bloc and dio init
  Bloc.observer = MainBlocObserver();
  DioHelper.init();

  //* cache Init
  await CacheHelper.init();

  //* Localization Init
  LocaleChanger localeChanger = LocaleChanger();
  await loadLocalizations(localeChanger);
  // CacheHelper.saveData(key: KeysManager.isGuest, value: false);
  //CacheHelper.saveData(key: KeysManager.userId, value: 76);
  // CacheHelper.saveData(key: KeysManager.isNotificationsActive, value: true);
  // CacheHelper.saveData(key: KeysManager.finishedOnBoarding, value: true);
  // CacheHelper.saveData(key: KeysManager.isAuthenticated, value: false);
  // CacheHelper.saveData(key: KeysManager.token, value: '');
  // AppConstants.isAuthenticated = false;
  // AppConstants.token = '';
  //* loading caches
  await loadCaches();

  runApp(
    ChangeNotifierProvider(
      create: (context) => localeChanger,
      child: MyApp(localeChanger: localeChanger,)
    )
  );

}

//* Caches and Localization Initialization helper methods
Future<void> loadLocalizations(LocaleChanger localeChanger)async{
  await localeChanger.initializeLocale();
  await LocalizationService().init();
}
Future<void> loadCaches() async{
  AppConstants.isGuest = await CacheHelper.getData(key: KeysManager.isGuest)??false;
  AppConstants.isAuthenticated = await CacheHelper.getData(key: KeysManager.isAuthenticated)??false;
  AppConstants.finishedOnBoarding = await CacheHelper.getData(key: KeysManager.finishedOnBoarding)??false;
  AppConstants.isNotificationsActive = await CacheHelper.getData(key: KeysManager.isNotificationsActive)??true;
  AppConstants.userId = await CacheHelper.getData(key: KeysManager.userId)??-1;
  AppConstants.token = await CacheHelper.getData(key: KeysManager.token)??'';
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.localeChanger
  });
  final LocaleChanger localeChanger;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // late final StreamSubscription _sub;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _handleIncomingLinks();
  // }
  //
  // void _handleIncomingLinks() {
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       log('Received deep link: $uri');
  //
  //       final pathSegments = uri.pathSegments;
  //       if (
  //         pathSegments.length == 4   &&
  //         pathSegments[0]== 'wikala' &&
  //         pathSegments[1]== 'api'    &&
  //         pathSegments[2]== 'profile'
  //       ) {
  //         final userId = pathSegments[4];
  //         Navigator.push(
  //           navigatorKey.currentContext!,
  //           RoutesGenerator.getRoute(RouteSettings(name: Routes.profile, arguments: ProfileScreenArguments(isOthers: true, id: int.parse(userId))))
  //         );
  //       }
  //
  //       // Add more cases if needed
  //     }
  //   }, onError: (err) {
  //     log('Deep link error: $err');
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _sub.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.localeChanger,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => MainCubit()
            ..getProfile()
            ..getHomeScreen()
            ..getCommercialAds()
            ..getCategories()
            ..getFollowing(AppConstants.userId)
            ..getChats()
            ..getSavedAds()
            ..getReports()
          ),
        ],
        child: Directionality(
          textDirection: widget.localeChanger.getLanguage == 'ar'? TextDirection.rtl:TextDirection.ltr,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RoutesGenerator.getRoute,
            navigatorKey: navigatorKey,
            locale: Locale(widget.localeChanger.getLanguage),
            supportedLocales: const [Locale('en'), Locale('ar'),],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: lightTheme(),
            initialRoute: Routes.splashScreen,
          ),
        ), //? To determine which interface direction to set based on the current locale
      ),
    ); //? To reflect the direction change and translation once language is changed
  }
}

