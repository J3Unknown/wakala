import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    var categories = MainCubit.get(context).categoriesDataModel!.result!.categories;
    return Column(
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
                    });
                  }
                },
                backgroundColor: ColorsManager.white,
                checkmarkColor: ColorsManager.white,
                selectedColor: ColorsManager.primaryColor,
                label: Text(StringsManager.all,),
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
                              selectedSubCategoryIndex = -1;
                            } else {
                              Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: categories[index])));
                            }
                          });
                        }
                      },
                      backgroundColor: ColorsManager.white,
                      checkmarkColor: ColorsManager.white,
                      selectedColor: ColorsManager.primaryColor,
                      label: Text(MainCubit.get(context).categoriesDataModel!.result!.categories[index].name,),
                      selected: selectedMainCategoryIndex == index,
                      labelStyle: TextStyle(color: selectedMainCategoryIndex == index ? ColorsManager.white : ColorsManager.black),
                    ),
                    separatorBuilder: (context, index) =>SizedBox(width: AppSizesDouble.s10,),
                    itemCount: MainCubit.get(context).categoriesDataModel!.result!.categories.length
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
                      title: Text(StringsManager.all),
                      onTap: (){
                        setState(() {
                          selectedSubCategoryIndex = -1;
                        });
                      },
                      selected: selectedSubCategoryIndex == -1,
                      selectedTileColor: ColorsManager.grey5,
                      selectedColor: ColorsManager.primaryColor,
                    ),
                    if(selectedMainCategoryIndex != -1 && categories[selectedMainCategoryIndex].endPoint != 1)
                    Expanded(
                      child: ListView.builder(
                        itemCount: categories[selectedMainCategoryIndex].subCategories!.length,
                        itemBuilder: (context, index) => ListTile(
                          selected: selectedSubCategoryIndex == index,
                          selectedTileColor: ColorsManager.grey5,
                          selectedColor: ColorsManager.primaryColor,
                          title: Text(categories[selectedMainCategoryIndex].subCategories![index].name),
                          onTap: (){
                            setState(() {
                              if(categories[selectedMainCategoryIndex].subCategories![index].endPoint != 1){
                                selectedSubCategoryIndex = index;
                              } else{
                                Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: categories[selectedMainCategoryIndex].subCategories![index])));
                              }
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if(selectedMainCategoryIndex != -1 && selectedSubCategoryIndex != -1 && categories[selectedMainCategoryIndex].subCategories![selectedSubCategoryIndex].endPoint != 1)
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSizes.s3,
                    mainAxisSpacing: AppSizesDouble.s5,
                    crossAxisSpacing: AppSizesDouble.s10,
                    childAspectRatio: AppSizesDouble.s0_7,
                  ),
                  itemCount: categories[selectedMainCategoryIndex].subCategories![selectedSubCategoryIndex != -1? selectedSubCategoryIndex:0].subCategories!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search, arguments: categories[selectedMainCategoryIndex].subCategories![selectedSubCategoryIndex].subCategories![index]))),
                    child: Padding(
                      padding: EdgeInsets.all(AppSizesDouble.s8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: AppSizesDouble.s30,
                            backgroundImage: Svg(AssetsManager.productPlaceHolder),
                          ),
                          Text(categories[selectedMainCategoryIndex].subCategories![selectedSubCategoryIndex].subCategories![index].name, textAlign: TextAlign.center,)
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
    );
  }
}


