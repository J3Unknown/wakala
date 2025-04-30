import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/observer.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.getRoute,
      initialRoute: Routes.home,
    );
  }
}

