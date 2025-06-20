import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../utilities/resources/components.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {

  @override
  void initState() {
    if(context.read<MainCubit>().userAdDataModel == null){
      context.read<MainCubit>().getMyAds();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
              child: Text(StringsManager.myAds, style: Theme.of(context).textTheme.titleLarge,),
            ),
          ],
        ),
        body: ConditionalBuilder(
          condition: MainCubit.get(context).userAdDataModel != null && state is !MainGetUserAdLoadingState,
          fallback: (context) {
            if(state is MainGetUserAdLoadingState){
              return Center(child: CircularProgressIndicator(),);
            }
            return Center(child: Text('No Items Yet'));
          },
          builder: (context) => VerticalProductsList(
            isRecentlyViewed: false,
            items: MainCubit.get(context).userAdDataModel!.result!.commercialAdsItems!,
          ),
        ),
      ),
    );
  }
}
