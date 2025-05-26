import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async{
              AppConstants.finishedOnBoarding = true;
              await CacheHelper.saveData(key: KeysManager.finishedOnBoarding, value: true).then((value){
                Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.authLayout)));
              });
            },
            child: Text(StringsManager.skip)
          )
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
