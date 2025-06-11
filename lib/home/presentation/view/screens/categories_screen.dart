import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  int selectedMainCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                label: Text('All Categories',),
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
                            selectedMainCategoryIndex = index;
                          });
                        }
                      },
                      backgroundColor: ColorsManager.white,
                      checkmarkColor: ColorsManager.white,
                      selectedColor: ColorsManager.primaryColor,
                      label: Text('data',),
                      selected: selectedMainCategoryIndex == index,
                      labelStyle: TextStyle(color: selectedMainCategoryIndex == index ? ColorsManager.white : ColorsManager.black),
                    ),
                    separatorBuilder: (context, index) =>SizedBox(width: AppSizesDouble.s10,),
                    itemCount: 10
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
                width: MediaQuery.of(context).size.width / 3 - 20,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('All'),
                      onTap: (){},
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 9,
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Choice${index + 1}'),
                          onTap: (){},
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: Svg(AssetsManager.productPlaceHolder),
                        ),
                        Text('Category Name', textAlign: TextAlign.center,)
                      ],
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


