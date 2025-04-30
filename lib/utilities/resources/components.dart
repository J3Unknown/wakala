import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import 'assets_manager.dart';
import 'colors_manager.dart';
import 'icons_manager.dart';

PreferredSizeWidget appBar({String title = StringsManager.wikala, Widget? titleSectionList, List<IconButton> actions = const [], bool autoImplyLeading = true}) => AppBar(
  leadingWidth: 40,
  automaticallyImplyLeading: autoImplyLeading,
  title: titleSectionList??Text(title),
  actions: actions
);

class CategoriesScroll extends StatelessWidget {
  const CategoriesScroll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizesDouble.s100,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(10, (index) => CategoryButton(
            title: 'Category',
            image: AssetsManager.productPlaceHolder,
            onPress: (){},
          ))
      ),
    );
  }
}


class CategoryButton extends StatelessWidget {
  
  late final String title;
  late final String image;
  late final VoidCallback onPress;

  CategoryButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p3),
      child: InkWell(
        onTap: onPress,
        child: SizedBox(
          height: AppSizesDouble.s100,
          width: AppSizesDouble.s70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: AppMargins.m10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                  side: BorderSide(color: Colors.black)
                ),
                child: SvgPicture.asset(AssetsManager.productPlaceHolder, fit: BoxFit.cover, width: AppSizesDouble.s70, height: AppSizesDouble.s50,),
              ),
              Text(
                title,
                maxLines: AppSizes.s2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({
    super.key,
    required TextEditingController searchController,
    required this.onChange
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final _debouncer =  Debouncer(milliseconds: 500);
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _debouncer.run(onChange),
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(IconsManager.searchIcon),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
            borderSide: BorderSide(color: ColorsManager.grey)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
            borderSide: BorderSide(color: ColorsManager.primaryColor)
        ),
      ),
      cursorColor: ColorsManager.primaryColor,
    );
  }
}