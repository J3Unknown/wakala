import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../utilities/resources/components.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.myAds, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: VerticalProductsList(
        isRecentlyViewed: false,
      ),
    );
  }
}
