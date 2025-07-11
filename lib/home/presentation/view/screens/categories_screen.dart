import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/search_screen_arguments.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  int selectedMainCategoryIndex = -1;
  int selectedSubCategoryIndex = -1;
  List<Categories> allSubCategories = [];
  List<Categories> allSecondSubCategories = [];
  late List<Categories> categories;

  @override
  void initState() {
    if(MainCubit.get(context).categoriesDataModel != null){
      categories = MainCubit.get(context).categoriesDataModel!.result!.categories;
      for (var e in categories) {
        allSubCategories.addAll(e.subCategories??[]);
      }
      for (var e in allSubCategories) {
        allSecondSubCategories.addAll(e.subCategories??[]);
      }
    } else {
      MainCubit.get(context).getCategories();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){
        if(state is MainGetCategoriesSuccessState && MainCubit.get(context).categoriesDataModel == null){
          categories = MainCubit.get(context).categoriesDataModel!.result!.categories;
          for (var e in categories) {
            allSubCategories.addAll(e.subCategories??[]);
          }
          for (var e in allSubCategories) {
            allSecondSubCategories.addAll(e.subCategories??[]);
          }
        }
      },
      builder: (context, state) => ConditionalBuilder(
        condition: MainCubit.get(context).categoriesDataModel != null,
        fallback: (context) => Center(child: CircularProgressIndicator(),),
        builder: (context) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
              child: Row(
                children: [
                  ChoiceChip(
                    onSelected: (bool selected) {
                      if(selected){
                        setState(() {
                          selectedMainCategoryIndex = -1;
                          selectedSubCategoryIndex = -1;
                          allSecondSubCategories.clear();
                          for(var i in allSubCategories){
                            allSecondSubCategories.addAll(i.subCategories??[]);
                          }
                        });
                      }
                    },
                    backgroundColor: ColorsManager.white,
                    checkmarkColor: ColorsManager.white,
                    selectedColor: ColorsManager.primaryColor,
                    label: Text(LocalizationService.translate(StringsManager.all),),
                    selected: selectedMainCategoryIndex == -1,
                    labelStyle: TextStyle(color: selectedMainCategoryIndex == -1 ? ColorsManager.white : ColorsManager.black),
                  ),
                  SizedBox(width: AppSizesDouble.s10,),
                  Expanded(
                    child: SizedBox(
                      height: AppSizesDouble.s50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ChoiceChip(
                          onSelected: (bool selected) {
                            if(selected){
                              setState(() {
                                if(categories[index].endPoint != 1) {
                                  selectedMainCategoryIndex = index;
                                  allSecondSubCategories.clear();
                                  for(var i in categories[selectedMainCategoryIndex].subCategories!){
                                    allSecondSubCategories.addAll(i.subCategories??[]);
                                  }
                                  selectedSubCategoryIndex = -1;
                                } else {
                                  Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: SearchScreenArguments(categories[index].id!, categories: categories[index]))));
                                }
                              });
                            }
                          },
                          backgroundColor: ColorsManager.white,
                          checkmarkColor: ColorsManager.white,
                          selectedColor: ColorsManager.primaryColor,
                          label: Text(MainCubit.get(context).categoriesDataModel!.result!.categories[index].name!,),
                          selected: selectedMainCategoryIndex == index,
                          labelStyle: TextStyle(color: selectedMainCategoryIndex == index ? ColorsManager.white : ColorsManager.black),
                        ),
                        separatorBuilder: (context, index) =>SizedBox(width: AppSizesDouble.s10,),
                        itemCount: categories.length
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: ColorsManager.grey4,
                    width: MediaQuery.of(context).size.width / AppSizes.s3 - AppSizes.s20,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(LocalizationService.translate(StringsManager.all)),
                          onTap: (){
                            setState(() {
                              selectedSubCategoryIndex = -1;
                              allSecondSubCategories.clear();
                              if(selectedMainCategoryIndex != -1){
                                for(var i in categories[selectedMainCategoryIndex].subCategories!){
                                  allSecondSubCategories.addAll(i.subCategories??[]);
                                }
                              } else {
                                allSecondSubCategories.clear();
                                for(var i in allSubCategories){
                                  allSecondSubCategories.addAll(i.subCategories??[]);
                                }
                              }
                            });
                          },
                          selected: selectedSubCategoryIndex == -1,
                          selectedTileColor: ColorsManager.grey5,
                          selectedColor: ColorsManager.primaryColor,
                        ),
                        if(selectedMainCategoryIndex != -1?categories[selectedMainCategoryIndex].endPoint != 1:true)
                        Expanded(
                          child: ListView.builder(
                            itemCount: selectedMainCategoryIndex == -1? allSubCategories.length:categories[selectedMainCategoryIndex].subCategories!.length,
                            itemBuilder: (context, index) => ListTile(
                              selected: selectedSubCategoryIndex == index,
                              selectedTileColor: ColorsManager.grey5,
                              selectedColor: ColorsManager.primaryColor,
                              title: Text(selectedMainCategoryIndex == -1?allSubCategories[index].name!:categories[selectedMainCategoryIndex].subCategories![index].name!),
                              onTap: (){
                                setState(() {
                                  if(selectedMainCategoryIndex != -1){
                                    if(categories[selectedMainCategoryIndex].subCategories![index].endPoint != 1){
                                      selectedSubCategoryIndex = index;
                                      allSecondSubCategories.clear();
                                      for(var i in categories[selectedMainCategoryIndex].subCategories!){
                                        allSecondSubCategories.addAll(i.subCategories??[]);
                                      }
                                    } else{
                                      Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments:SearchScreenArguments(categories[selectedMainCategoryIndex].subCategories![index].id!, categories: categories[selectedMainCategoryIndex].subCategories![index]) )));
                                    }
                                  } else {
                                    if(allSubCategories[index].endPoint != 1){
                                      selectedSubCategoryIndex = index;
                                      allSecondSubCategories.clear();
                                      for(var i in allSubCategories[selectedSubCategoryIndex].subCategories!){
                                        allSecondSubCategories.add(i);
                                      }
                                    } else{
                                      Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: SearchScreenArguments(categories[index].id!, categories: categories[index]))));
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if(selectedSubCategoryIndex != -1?(selectedMainCategoryIndex != -1?categories[selectedMainCategoryIndex].subCategories![selectedSubCategoryIndex].endPoint != 1:allSubCategories[selectedSubCategoryIndex].endPoint!=1):true)
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: AppSizes.s3,
                        mainAxisSpacing: AppSizesDouble.s5,
                        crossAxisSpacing: AppSizesDouble.s10,
                        childAspectRatio: AppSizesDouble.s0_6,
                      ),
                      itemCount: allSecondSubCategories.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: SearchScreenArguments(allSecondSubCategories[index].id!, categories: allSecondSubCategories[index])))),
                        child: Padding(
                          padding: EdgeInsets.all(AppSizesDouble.s8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: AppSizesDouble.s30,
                                backgroundImage: NetworkImage(AppConstants.baseImageUrl + allSecondSubCategories[index].image!),
                              ),
                              Text(allSecondSubCategories[index].name!, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


