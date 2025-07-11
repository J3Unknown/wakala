import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/presentation/data/search_screen_arguments.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Categories? selectedCategory;
  late int selectedCategoryId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SearchScreenArguments? args = ModalRoute.of(context)!.settings.arguments as SearchScreenArguments?;
    if(args != null){
      selectedCategory = args.categories;
      selectedCategoryId = args.categoryId;
      if(selectedCategory == null){
        context.read<MainCubit>().getSubCategories(selectedCategoryId);
      } else {
        context.read<MainCubit>().getSearchCommercialAds(categoryId: selectedCategoryId,);
      }
    }
    super.didChangeDependencies();
  }
  final DeBouncer _deBouncer = DeBouncer();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: KeysManager.searchBarHeroTag,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AppSizesDouble.s30,
          title: CustomSearchBar(searchController: _searchController, onChange: () => _deBouncer.run((){
            MainCubit.get(context).getSearchCommercialAds(
              search: _searchController.text,
              categoryId: selectedCategoryId,
            );
          })),
        ),
        body: BlocConsumer<MainCubit, MainCubitStates>(
          listener: (context, state){
            if(state is MainGetSubCategoriesSuccessState && selectedCategory == null){
              MainCubit.get(context).getSearchCommercialAds(categoryId: selectedCategoryId,);
            }
          },
          builder: (context, state) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(selectedCategory != null && selectedCategory!.subCategories != null)
                CategoriesScroll(categories: selectedCategory,),
                if(MainCubit.get(context).isCategorySelected || (selectedCategory != null && selectedCategory!.subCategories == null))
                DefaultFilterButton(categories: selectedCategory!),
                AdsBannerSection(slider: MainCubit.get(context).homePageDataModel!.result!.sliders!.first),
                Expanded(
                  child: ConditionalBuilder(
                    condition: MainCubit.get(context).searchScreenAdsDataModel != null,
                    fallback: (context) => Center(child: CircularProgressIndicator(),),
                    builder: (context) => VerticalProductsList(
                      isRecentlyViewed: true,
                      items: MainCubit.get(context).searchScreenAdsDataModel!.result!.commercialAdsItems!,
                    ),
                  )
                )
              ],
            ),
          ),
        ) 
      ),
    );
  }
}
