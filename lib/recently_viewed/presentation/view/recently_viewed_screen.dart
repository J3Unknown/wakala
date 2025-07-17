import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
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
    context.read<MainCubit>().getRecentlyViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.recentlyViewed), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: MainCubit.get(context),
        builder: (context, state) => ConditionalBuilder(
          condition: MainCubit.get(context).recentlyViewedDataModel != null && state is !MainGetRecentlyViewedLoadingState,
          fallback: (context) {
            if(state is MainGetRecentlyViewedLoadingState){
              return Center(child: CircularProgressIndicator(),);
            }
            return Center(child: Text(LocalizationService.translate(StringsManager.noItemsYet)),);
          },
          builder: (context) => ListView.builder(
            itemCount: MainCubit.get(context).recentlyViewedDataModel!.result.length,
            itemBuilder: (context, index) => HorizontalProductCard(commercialItem: MainCubit.get(context).recentlyViewedDataModel!.result[index].ad, isRecentlyViewing: true,),
          ),
        ),
      ),
    );
  }
}
