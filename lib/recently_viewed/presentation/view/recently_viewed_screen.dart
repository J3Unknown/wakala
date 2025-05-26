import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.recentlyViewed, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: VerticalProductsList(isRecentlyViewed: true),
    );
  }
}
