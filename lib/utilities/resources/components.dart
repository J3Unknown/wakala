import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import 'assets_manager.dart';
import 'colors_manager.dart';
import 'icons_manager.dart';

PreferredSizeWidget appBar({String title = StringsManager.wikala, Widget? titleSectionList, List<IconButton> actions = const [], bool autoImplyLeading = true}) => AppBar(
  leadingWidth: AppSizesDouble.s40,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
      child: SizedBox(
        height: AppSizesDouble.s120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(10, (index) => CategoryButton(
            title: StringsManager.category,
            image: AssetsManager.productPlaceHolder,
            onPress: (){},
          ))
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      child: InkWell(
        onTap: onPress,
        child: SizedBox(
          height: AppSizesDouble.s80,
          width: AppSizesDouble.s80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: AppMargins.m10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                  side: BorderSide(color: ColorsManager.black, width: AppSizesDouble.s2)
                ),
                child: SvgPicture.asset(AssetsManager.productPlaceHolder, fit: BoxFit.cover, width: AppSizesDouble.s80, height: AppSizesDouble.s80,),
              ),
              Text(
                title,
                style: TextStyle(color: ColorsManager.grey2, fontSize: 18),
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
  final _debouncer =  Debouncer(milliseconds: AppSizes.s500);
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _debouncer.run(onChange),
      decoration: InputDecoration(
        hintText: StringsManager.searchHint,
        hintStyle: TextStyle(color: ColorsManager.grey2),
        prefixIcon: Icon(IconsManager.searchIcon, color: ColorsManager.grey2,),
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

class FilterList extends StatelessWidget{

  const FilterList({
    super.key,
    required List<FilterDropDown> filterItems,
  }) : _filterItems = filterItems;

  final List<FilterDropDown> _filterItems;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: AppSizesDouble.s35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filterItems,
      ),
    );
  }
}
class FilterDropDown extends StatefulWidget {
  const FilterDropDown({
    super.key,
    required String? selectedItem,
    required List<DropdownMenuItem<String>> items,
    required String title,
    required this.onChange,
    this.icon
  }) : _selectedItem = selectedItem, _items = items, _title = title;

  final String? _selectedItem;
  final IconData? icon;
  final ValueChanged onChange;
  final String _title;
  final List<DropdownMenuItem<String>> _items;
  @override
  State<FilterDropDown> createState() => _FilterDropDownState();
}

class _FilterDropDownState extends State<FilterDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizesDouble.s5),
      padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s5),
      height: AppSizesDouble.s35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizesDouble.s10),
        border: Border.all(color: ColorsManager.grey)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(widget.icon != null)Icon(widget.icon),
          SizedBox(width: AppSizesDouble.s5,),
          DropdownButton(
            underline: SizedBox(),
            dropdownColor: ColorsManager.white,
            value: widget._selectedItem,
            items: widget._items,
            hint: Text(widget._title, style: Theme.of(context).textTheme.headlineSmall,),
            onChanged: (value) => widget.onChange(value),
            selectedItemBuilder: (context) => widget._items.map((element) {
              return DropdownMenuItem(
                child: Text(
                  (element.child as Text).data!,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AdsBannerSection extends StatelessWidget {
  const AdsBannerSection({
    super.key,
    required String imgSrc,
  }) : _imgSrc = imgSrc;

  final String _imgSrc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppMargins.m15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s15)
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: double.infinity,
      height: AppSizesDouble.s130,
      child: Image.network(_imgSrc, fit: BoxFit.fitWidth,),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required String title,
  }) : _title = title;

  final String _title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(_title, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),),
            Spacer(),
            TextButton(onPressed: (){}, child: Text(StringsManager.showAll, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.grey),))
          ],
        ),
        SizedBox(
          height: AppSizesDouble.s200,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10, //!Keep it 10 for now till adjusting the real item count
              separatorBuilder: (context, index) => SizedBox(width: AppSizesDouble.s10,),
              itemBuilder: (context, index) => TopSectionsElement(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',)
          ),
        ),
      ],
    );
  }
}

class TopSectionsElement extends StatelessWidget {
  const TopSectionsElement({
    super.key,
    required String imgSrc,
  }) : _imgSrc = imgSrc;
  final String _imgSrc;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: AppSizesDouble.s200,
        height: AppSizesDouble.s200,
        child: Image.network(_imgSrc, fit: BoxFit.cover,),
      ),
    );
  }
}


class HorizontalProductList extends StatelessWidget {
  const HorizontalProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizesDouble.s370,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10, //!Keep it 10 for now till adjusting the real item count
        itemBuilder: (context, index) => ProductCard(),
        separatorBuilder: (context, index) => SizedBox(width: AppSizesDouble.s10,),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: AppSizesDouble.s370,
        width: AppSizesDouble.s230,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s15),
          border: Border.all(color: ColorsManager.grey)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSizesDouble.s200,
              child: Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
            ),
            Padding(
              padding: EdgeInsets.all(AppPaddings.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Title', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('Product Description', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('200 KWD', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.grey2, fontWeight: FontWeight.w600), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('Egypt, Cairo', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('1 day', maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}