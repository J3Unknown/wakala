import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wakala/home/presentation/view/home_layout.dart';
import 'package:wakala/utilities/network/observer.dart';

void main() {
  Bloc.observer = MainBlocObserver(); // observer to detect changes on cubit states
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

