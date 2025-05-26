import 'dart:developer';

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

  //* loading caches
  await loadCaches();

  runApp(
    ChangeNotifierProvider(
      create: (context) => localeChanger,
      child: MyApp(localeChanger: localeChanger,)
    )
  );

}

//* initialization helper methods
Future<void> loadLocalizations(LocaleChanger localeChanger)async{
  await localeChanger.initializeLocale();
  await LocalizationService().init();
}
Future<void> loadCaches() async{
  AppConstants.isGuest = await CacheHelper.getData(key: KeysManager.isGuest)??false;
  AppConstants.isAuthenticated = await CacheHelper.getData(key: KeysManager.isAuthenticated)??false;
  AppConstants.finishedOnBoarding = await CacheHelper.getData(key: KeysManager.finishedOnBoarding)??false;
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.localeChanger
  });
  final LocaleChanger localeChanger;
  @override
  Widget build(BuildContext context) {
    log(localeChanger.getLanguage);
    return ListenableBuilder(
      listenable: localeChanger,
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => MainCubit()),
        ],
        child: Directionality(
          textDirection: localeChanger.getLanguage == 'ar'? TextDirection.rtl:TextDirection.ltr,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RoutesGenerator.getRoute,
            locale: Locale(localeChanger.getLanguage),
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: lightTheme(),
            initialRoute: Routes.splashScreen,
          ),
        ),
      ),
    );
  }
}

