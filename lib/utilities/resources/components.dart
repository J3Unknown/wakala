import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

import '../local/shared_preferences.dart';
import 'constants_manager.dart';
import 'strings_manager.dart';
import 'values_manager.dart';
import 'assets_manager.dart';
import 'colors_manager.dart';
import 'icons_manager.dart';

//* Categories Scroll
class CategoriesScroll extends StatefulWidget {
  const CategoriesScroll({
    super.key,

  });

  @override
  State<CategoriesScroll> createState() => _CategoriesScrollState();
}
class _CategoriesScrollState extends State<CategoriesScroll> {
  int _selectedCategory = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
      child: SizedBox(
        height: AppSizesDouble.s100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(10, (index) => CategoryButton(
            title: StringsManager.category,
            image: AssetsManager.productPlaceHolder,
            onPress: (){
              setState(() {
                if(_selectedCategory == index){
                  _selectedCategory = -1;
                } else{
                  _selectedCategory = index;
                }
              });
            },
            index: index,
            selectedCategory: _selectedCategory,
          ))
        ),
      ),
    );
  }
}

//* Categories Button
class CategoryButton extends StatefulWidget {

  final String title;
  final String image;
  final VoidCallback onPress;
  final int index;
  final int selectedCategory;

  const CategoryButton({
    super.key,
    required this.title,
    required this.image,
    required this.onPress,
    required this.index,
    required this.selectedCategory
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}
class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      child: InkWell(
        onTap: widget.onPress,
        child: SizedBox(
          height: AppSizesDouble.s60,
          width: AppSizesDouble.s80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: AppMargins.m5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                  side: BorderSide(color: widget.selectedCategory == widget.index? ColorsManager.grey:ColorsManager.black, width: AppSizesDouble.s2)
                ),
                child: SvgPicture.asset(AssetsManager.productPlaceHolder, fit: BoxFit.cover, width: AppSizesDouble.s60, height: AppSizesDouble.s60,),
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.selectedCategory == widget.index? ColorsManager.grey:ColorsManager.primaryColor,
                  fontSize: AppSizesDouble.s18
                ),
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

//* DeBouncer
class DeBouncer {
  final int milliseconds;
  Timer? _timer;

  DeBouncer({this.milliseconds = AppSizes.s500});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

//* Back Until Button
//? This button is used when U can navigate 2 screens from each other and you don't wanna create multiple layers
class BackButtonUntil extends StatelessWidget {
  const BackButtonUntil({
    super.key,
    required this.rootLayout,
  });

  final String rootLayout;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        bool authLayoutFound = false;
        Navigator.popUntil(context, (route) {
          if (route.settings.name == rootLayout) {
            authLayoutFound = true;
            return true;
          }
          return false;
        });
        if (!authLayoutFound) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            rootLayout, (route) => false,
          );
        }
      },
      icon: Icon(IconsManager.backButton)
    );
  }
}

//*Custom Search Bar
class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({
    super.key,
    required TextEditingController searchController,
    required this.onChange
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final _deBouncer =  DeBouncer(milliseconds: AppSizes.s500);
  final VoidCallback onChange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _deBouncer.run(onChange),
      decoration: InputDecoration(
        hintText: LocalizationService.translate(StringsManager.searchHint),
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

//* Dropdowns
//? This Dropdown is a full extended dropdown menu
class ItemsDropDownMenu extends StatefulWidget {
  const ItemsDropDownMenu({super.key, required this.title, required this.items, required this.selectedItem, required this.onChange});
  final List<DropdownMenuItem<String>> items;
  final String? selectedItem;
  final ValueChanged onChange;
  final String title;
  @override
  State<ItemsDropDownMenu> createState() => _ItemsDropDownMenuState();
}
class _ItemsDropDownMenuState extends State<ItemsDropDownMenu> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      width: double.infinity,
      height: AppSizesDouble.s50,
      decoration: BoxDecoration(
        color: ColorsManager.loginButtonBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizesDouble.s8),
        border: Border.all(
          color: ColorsManager.grey5
        ),
      ),
      child: DropdownButton(
        underline: SizedBox(),
        value: widget.selectedItem,
        items: widget.items,
        isExpanded: true,
        hint: Text(widget.title, style: Theme.of(context).textTheme.bodyLarge,),
        dropdownColor: ColorsManager.white,
        selectedItemBuilder: (value) => widget.items.map((element) => DropdownMenuItem(value: element.value,child: element.child,)).toList(),
        onChanged: (value) => widget.onChange(value)
      ),
    );
  }
}

//*Ads Banner Section
class AdsBannerSection extends StatelessWidget {
  const AdsBannerSection({
    super.key,
    required String imgSrc,
  }) : _imgSrc = imgSrc;

  final String _imgSrc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppMargins.m15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s15)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: double.infinity,
        height: AppSizesDouble.s110,
        child: Image.network(_imgSrc, fit: BoxFit.fitWidth,),
      ),
    );
  }
}

//* Top Section
//? This Section is made for the top elements section
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
            TextButton(onPressed: (){}, child: Text(StringsManager.showAll, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),))
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

//* Top Sections Element
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

//* Horizontal Product List
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
        itemBuilder: (context, index) => VerticalProductCard(),
        separatorBuilder: (context, index) => SizedBox(width: AppSizesDouble.s10,),
      ),
    );
  }
}

//* Vertical Product Card
//? This is used in the Horizontal Product List
class VerticalProductCard extends StatelessWidget {
  const VerticalProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.productDetails))),
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
                  Text('200 EGP', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.w600), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
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

class HorizontalProductCard extends StatefulWidget {
  const HorizontalProductCard({
    super.key,
    required this.type,
    required this.isRecentlyViewing,
    this.isSaved = false
  });
  final String type;
  final bool isRecentlyViewing;
  final bool isSaved;

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}
class _HorizontalProductCardState extends State<HorizontalProductCard> {
  late ProductTypeData typeData;
  @override
  void initState() {
    typeData = getProductType(widget.type);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.productDetails)));
      },
      child: Container(
        margin: EdgeInsets.all(AppSizesDouble.s10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: double.infinity,
        height: AppSizesDouble.s200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
          border: Border.all(color: ColorsManager.grey)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', width: MediaQuery.of(context).size.width/2.5, height: 200, fit: BoxFit.cover,),
                IntrinsicWidth(
                  child: Container(
                    margin: EdgeInsets.all(AppPaddings.p10),
                    padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s15, vertical: AppSizesDouble.s5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizesDouble.s8),
                      color: typeData.color
                    ),
                    child: Text(typeData.type),
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSizesDouble.s10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product Title', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text('Product Description', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text('200 EGP', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.w600), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text('Egypt, Cairo', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('1 day', maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            if(!widget.isRecentlyViewing)
            IconButton(
              onPressed: () {
                Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.fullPost)));
              },
              icon: SvgPicture.asset(AssetsManager.edit)
            ),
            if(widget.isRecentlyViewing)
            IconButton(onPressed: (){}, icon: SvgPicture.asset(widget.isSaved? AssetsManager.savedFilled:AssetsManager.saved))
          ],
        ),
      ),
    );
  }
}

class VerticalProductsList extends StatelessWidget {
const VerticalProductsList({super.key, required this.isRecentlyViewed, this.isSaved = false});
  final bool isRecentlyViewed;
  final bool isSaved;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) =>  HorizontalProductCard(type: 'Sale', isRecentlyViewing: isRecentlyViewed, isSaved: isSaved)
    );
  }
}

//* go to login screen
void navigateToAuthLayout(context) async{
  AppConstants.isGuest = false;
  AppConstants.isAuthenticated = false;
  await CacheHelper.saveData(key: KeysManager.isGuest, value: false);
  await CacheHelper.saveData(key: KeysManager.isAuthenticated, value: false);
  Navigator.pushAndRemoveUntil(context,RoutesGenerator.getRoute(RouteSettings(name: Routes.authLayout)), (root) => false);
}

class DefaultFilterInputField extends StatelessWidget {
  const DefaultFilterInputField({
    super.key,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) : _controller = controller, _keyboardType = keyboardType, _maxLines = maxLines, _hint = hint;

  final TextEditingController _controller;
  final TextInputType _keyboardType;
  final int _maxLines;
  final String? _hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: _keyboardType == TextInputType.number?[FilteringTextInputFormatter.digitsOnly]:[],
      controller: _controller,
      keyboardType: _keyboardType,
      maxLines: _maxLines,
      minLines: AppSizes.s1,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsManager.loginButtonBackgroundColor,
        hintText: _hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizesDouble.s10),
          borderSide: BorderSide(color: ColorsManager.grey3, width: AppSizesDouble.s2)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizesDouble.s10),
          borderSide: BorderSide(color: ColorsManager.primaryColor)
        ),
      ),
    );
  }
}


class DefaultSwitch extends StatefulWidget {
  const DefaultSwitch({super.key, required this.isActivated, required this.onChanged});
  final bool isActivated;
  final ValueChanged<bool> onChanged;
  @override
  State<DefaultSwitch> createState() => _DefaultSwitchState();
}
class _DefaultSwitchState extends State<DefaultSwitch> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: AppSizesDouble.s50,
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
            decoration: BoxDecoration(
              color: ColorsManager.loginButtonBackgroundColor,
              border: Border.all(color: ColorsManager.grey),
              borderRadius: BorderRadius.circular(AppSizesDouble.s8),
            ),
            child: Row(
              children: [
                Text(StringsManager.notifications),
                Spacer(),
                Switch(
                  value: widget.isActivated,
                  onChanged: (bool value) => widget.onChanged(value),
                  activeColor: ColorsManager.primaryColor,
                  activeTrackColor: ColorsManager.primaryColor,
                  thumbColor: WidgetStatePropertyAll(ColorsManager.white),
                  inactiveTrackColor: ColorsManager.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}