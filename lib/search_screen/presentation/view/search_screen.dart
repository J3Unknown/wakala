import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/search_screen_arguments.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin{
  final TextEditingController _searchController = TextEditingController();
  Categories? selectedCategory;
  List<Categories>? categories;
  late int selectedCategoryId;

  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    context.read<MainCubit>().categoryIndex = -1;
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
      context.read<MainCubit>().getSearchCommercialAds(
        loadMore: true,
        search: _searchController.text,
        categoryId: selectedCategoryId != -1?selectedCategoryId:null,
      );
    }
  }

  @override
  void didChangeDependencies() {
    SearchScreenArguments? args = ModalRoute.of(context)!.settings.arguments as SearchScreenArguments?;
    if(args != null){
      selectedCategory = args.categories;
      selectedCategoryId = args.categoryId;
      if(selectedCategory == null){
        categories = context.read<MainCubit>().categoriesDataModel!.result!.categories;
      }
      if(selectedCategory == null && selectedCategoryId != -1){
        context.read<MainCubit>().getSubCategories(selectedCategoryId);
      } else {
        if(selectedCategoryId == -1){
          context.read<MainCubit>().getSearchCommercialAds();
        } else {
          context.read<MainCubit>().getSearchCommercialAds(categoryId: selectedCategoryId,);
        }
      }
    }
    super.didChangeDependencies();
  }
  final DeBouncer _deBouncer = DeBouncer();

  @override
  Widget build(BuildContext context) {
    super.build;
    return Hero(
      tag: KeysManager.searchBarHeroTag,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AppSizesDouble.s30,
          title: CustomSearchBar(searchController: _searchController, onChange: () => _deBouncer.run((){
            MainCubit.get(context).getSearchCommercialAds(
              search: _searchController.text,
              categoryId: selectedCategoryId != -1? selectedCategoryId:null,
            );
          })),
        ),
        body: BlocConsumer<MainCubit, MainCubitStates>(
          listener: (context, state){
            if(state is MainGetSubCategoriesSuccessState && selectedCategory == null){
              MainCubit.get(context).getSearchCommercialAds(categoryId: selectedCategoryId != -1? selectedCategoryId:null,);
            }
          },
          builder: (context, state) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if((selectedCategory != null && selectedCategory!.subCategories != null) || categories != null)
                CategoriesScroll(categories: selectedCategory, catList: categories, isList: categories != null,),
                if(MainCubit.get(context).isCategorySelected || (categories != null && selectedCategory != null && selectedCategory!.subCategories == null))
                DefaultFilterButton(categories: selectedCategory??categories![MainCubit.get(context).categoryIndex == -1?0:MainCubit.get(context).categoryIndex]),
                AdsBannerSection(slider: MainCubit.get(context).homePageDataModel!.result!.sliders!.first),
                Expanded(
                  child: ConditionalBuilder(
                    condition: MainCubit.get(context).searchScreenAdsDataModel != null && state is !MainGetCommercialAdLoadingState && AppConstants.isAuthenticated,
                    fallback: (context) {
                      if(state is MainGetCommercialAdLoadingState){
                        return Center(child: CircularProgressIndicator(),);
                      } else if(!AppConstants.isAuthenticated){
                        return Center(child: Text(LocalizationService.translate(StringsManager.loginMessage)),);
                      }
                        return Center(child: Text(LocalizationService.translate(StringsManager.cantLoadProducts)),);
                    },
                    builder: (context) => VerticalProductsList(
                      scrollController: _scrollController,
                      isRecentlyViewed: true,
                      items: MainCubit.get(context).searchScreenAdsDataModel!.result!.commercialAdsItems!,
                    ),
                  )
                ),
                if(MainCubit.get(context).searchCommercialAdsIsLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(AppPaddings.p10),
                  child: Center(child: CircularProgressIndicator(),),
                )
              ],
            ),
          ),
        ) 
      ),
    );
  }
}
