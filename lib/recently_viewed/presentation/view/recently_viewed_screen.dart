import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {

  @override
  void initState() {
    if(context.read<MainCubit>().recentlyViewedDataModel == null){
      context.read<MainCubit>().getRecentlyViewed();
    }
    super.initState();
  }

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
      body: VerticalProductsList(isRecentlyViewed: true, items: [],),
    );
  }
}
