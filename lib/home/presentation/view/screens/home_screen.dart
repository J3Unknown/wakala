import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../../../cubit/main_cubit.dart';
import '../widgets/search_button.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return BlocBuilder<MainCubit, MainCubitStates>(
      builder: (context, state) => ConditionalBuilder(
        fallback: (context) => Center(child: CircularProgressIndicator(),),
        condition: cubit.homePageDataModel != null,
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
            child: Column(
              children: [
                CategoriesScroll(catList: cubit.homePageDataModel!.result!.categories, isList: true, instantSearch: true,),
                ConditionalBuilder(
                  condition: cubit.categoriesDataModel != null,
                  fallback: (context) => Center(child: CircularProgressIndicator(),),
                  builder: (context) => SearchButton()
                ),
                AdsBannerSection(slider: cubit.homePageDataModel!.result!.sliders!.first),
                ConditionalBuilder(
                  condition: cubit.homePageDataModel!.result!.homePageProducts != null &&  cubit.homePageDataModel!.result!.homePageProducts!.isNotEmpty,
                  fallback: (context) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal:  AppPaddings.p5),
                        child: FittedBox(child: Text(LocalizationService.translate(StringsManager.noSuggestions), style: Theme.of(context).textTheme.headlineMedium,)),
                      ),
                    );
                  },
                  builder: (context) => ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(cubit.homePageDataModel!.result!.homePageProducts!.length, (index) => TopSection(topSection: cubit.homePageDataModel!.result!.homePageProducts![index],)),
                  ),
                ),
                AdsBannerSection(slider: cubit.homePageDataModel!.result!.sliders!.last),
                ConditionalBuilder(
                  condition: cubit.homeScreenAdsDataModel != null && state is !MainGetCommercialAdLoadingState,
                  fallback: (context) => Center(child: CircularProgressIndicator(),),
                  builder: (context) => HorizontalProductList(products: cubit.homeScreenAdsDataModel!.result!.commercialAdsItems!,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
