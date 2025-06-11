import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../../../cubit/main_cubit.dart';
import '../widgets/search_button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitStates>(
      builder: (context, state) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
          child: Column(
            children: [
              ConditionalBuilder(
                condition: MainCubit.get(context).categoriesDataModel != null,
                fallback: (context) => Center(child: CircularProgressIndicator(),),
                builder: (context) => CategoriesScroll()
              ),
              if(MainCubit.get(context).isCategorySelected)
              Align(alignment: Alignment.centerLeft, child: DefaultFilterButton(categories: MainCubit.get(context).categoriesDataModel!)),
              SizedBox(height: AppSizesDouble.s10,),
              SearchButton(),
              AdsBannerSection(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), //TODO: Get the Image from the Back End
              TopSection(title: 'Top Commercials',),
              TopSection(title: 'Top Automotive',),
              TopSection(title: 'Top Real-Estate',),
              AdsBannerSection(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), //TODO: Get the Image from the Back End
              HorizontalProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
