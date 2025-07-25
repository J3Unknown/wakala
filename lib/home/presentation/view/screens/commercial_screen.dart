import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/components.dart';

class CommercialScreen extends StatefulWidget {
  const CommercialScreen({super.key});

  @override
  State<CommercialScreen> createState() => _CommercialScreenState();
}

class _CommercialScreenState extends State<CommercialScreen> with AutomaticKeepAliveClientMixin{
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if(context.read<MainCubit>().commercialAdDataModel == null){
      context.read<MainCubit>().getCommercialAds();
    }
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<MainCubit>().getCommercialAds(loadMore: true);
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      bloc: MainCubit.get(context),
      builder: (context, state) {
        return ConditionalBuilder(
          condition: MainCubit.get(context).commercialAdDataModel != null && state is !MainGetCommercialAdLoadingState,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: MainCubit.get(context).commercialAdDataModel!.result!.commercialAdsItems!.length,
                    padding: EdgeInsets.all(AppPaddings.p10),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: AppSizes.s2),
                    itemBuilder: (context, index) => DefaultCommercialGridItem(item: MainCubit.get(context).commercialAdDataModel!.result!.commercialAdsItems![index]),
                    controller: _scrollController,
                  ),
                ),
                if(MainCubit.get(context).commercialAdsIsLoadingMore)
                  Padding(
                    padding: const EdgeInsets.all(AppPaddings.p10),
                    child: Center(child: CircularProgressIndicator(),),
                  )
              ],
            );
          },
        );
      },
    );
  }
}
