import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.selectedCategory});
  final Categories selectedCategory;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  final DeBouncer _deBouncer = DeBouncer();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: KeysManager.searchBarHeroTag,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: AppSizesDouble.s30,
          title: CustomSearchBar(searchController: _searchController, onChange: () => _deBouncer.run((){})),
        ),
        body: BlocBuilder<MainCubit, MainCubitStates>(
          builder: (context, state) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.selectedCategory.subCategories != null)
                CategoriesScroll(categories: widget.selectedCategory,),
                if(MainCubit.get(context).isCategorySelected)
                DefaultFilterButton(categories: widget.selectedCategory),
                AdsBannerSection(slider: MainCubit.get(context).homePageDataModel!.result!.sliders!.first),
                Expanded(child: VerticalProductsList(isRecentlyViewed: true, items: [],))
              ],
            ),
          ),
        ) 
      ),
    );
  }
}
