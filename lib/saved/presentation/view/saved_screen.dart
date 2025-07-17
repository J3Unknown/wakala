import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';

import '../../../home/cubit/main_cubit_states.dart';
import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {

  @override
  void initState() {
    context.read<MainCubit>().getSavedAds();
    super.initState();
  }

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
      body: BlocBuilder(
        bloc: MainCubit.get(context),
        builder: (context, state) => ConditionalBuilder(
          condition:  MainCubit.get(context).savedAdsDataModel != null && state is !MainUnSaveAdLoadingState && state is !MainGetSavedAdsLoadingState,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) =>SavedAdsList(savedAds: MainCubit.get(context).savedAdsDataModel!.result!,)
        )
      ),
    );
  }
}
