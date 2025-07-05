import 'package:flutter/material.dart';
import 'package:wakala/home/cubit/main_cubit.dart';

import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.saved, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: SavedAdsList(savedAds: MainCubit.get(context).savedAdsDataModel!.result!,),
    );
  }
}
