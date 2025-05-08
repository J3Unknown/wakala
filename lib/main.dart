import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/observer.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/themes_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MainBlocObserver();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => MainCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RoutesGenerator.getRoute,
        theme: lightTheme(),
        initialRoute: Routes.splashScreen,
      ),
    );
  }
}

