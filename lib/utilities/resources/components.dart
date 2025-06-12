import 'dart:async';
import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/home_screen_data_model.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home/data/categories_data_model.dart';
import '../../home/data/commercial_ad_data_model.dart';
import '../../search_screen/presentation/view/widgets/filter_dialog.dart';
import '../local/shared_preferences.dart';
import 'constants_manager.dart';
import 'strings_manager.dart';
import 'values_manager.dart';
import 'assets_manager.dart';
import 'colors_manager.dart';
import 'icons_manager.dart';

//* Categories Scroll
class CategoriesScroll extends StatelessWidget {
  const CategoriesScroll({super.key,});

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return BlocBuilder<MainCubit, MainCubitStates>(
      builder: (context, state) => Padding(
      padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: AppSizesDouble.s120,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.homePageDataModel!.result!.categories!.length,
            itemBuilder: (context, index) => CategoryButton(
              category: cubit.homePageDataModel!.result!.categories![index],
              onPress: () => cubit.changeCategorySelection(index),
              index: index,
              selectedCategory: cubit.categoryIndex,
            )
          )
        ),
      ),
    );
  }
}

//* Categories Button
class CategoryButton extends StatefulWidget {

  final HomeCategories category;
  final VoidCallback onPress;
  final int index;
  final int selectedCategory;

  const CategoryButton({
    super.key,
    required this.category,
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
                child: Image.network(AppConstants.baseImageUrl +  widget.category.image!, fit: BoxFit.cover, width: AppSizesDouble.s60, height: AppSizesDouble.s60,),
              ),
              Text(
                widget.category.name,
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
  const ItemsDropDownMenu({super.key, this.isExpanded = true, required this.title, required this.items, required this.selectedItem, required this.onChange});
  final List<SubCategories> items;
  final int? selectedItem;
  final ValueChanged onChange;
  final String title;
  final bool isExpanded;
  @override
  State<ItemsDropDownMenu> createState() => _ItemsDropDownMenuState();
}
class _ItemsDropDownMenuState extends State<ItemsDropDownMenu> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      width: widget.isExpanded? double.infinity:null,
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
        items: List.generate(
          widget.items.length,
          (index) => DropdownMenuItem(
            value: widget.items[index].id,
            child: Text(widget.items[index].name),
          )
        ),
        isExpanded: widget.isExpanded,
        hint: Text(widget.title, style: Theme.of(context).textTheme.bodyLarge,),
        dropdownColor: ColorsManager.white,
        selectedItemBuilder: (value) => widget.items.map((element) => DropdownMenuItem(value: element.id,child: Text(element.name),)).toList(),
        onChanged: (value) => widget.onChange(value)
      ),
    );
  }
}

//*Ads Banner Section
class AdsBannerSection extends StatelessWidget {
  const AdsBannerSection({
    super.key,
    required HomePageSliders slider,
  }) : _sliders = slider;

  final HomePageSliders _sliders;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrlHelper(_sliders.link!),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppMargins.m15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s15)
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: double.infinity,
        height: AppSizesDouble.s110,
        child: Image.network(AppConstants.baseImageUrl +  _sliders.name!, fit: BoxFit.fitWidth,),
      ),
    );
  }
}

//* Top Section
//? This Section is made for the top elements section
class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required TopSectionDataModel topSection,
  }) : _topSection = topSection;

  final TopSectionDataModel _topSection;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(_topSection.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),),
            Spacer(),
            TextButton(onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search))), child: Text(StringsManager.showAll, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),))
          ],
        ),
        SizedBox(
          height: AppSizesDouble.s200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _topSection.categoryInfo.ads!.length,
            separatorBuilder: (context, index) => SizedBox(width: AppSizesDouble.s10,),
            itemBuilder: (context, index) => TopSectionsElement(ad: _topSection.categoryInfo.ads![index],)
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
    required CommercialAdItem ad,
  }) : _ad = ad;
  final CommercialAdItem _ad;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizesDouble.s15)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: AppSizesDouble.s200,
        height: AppSizesDouble.s200,
        child: Image.network(AppConstants.baseImageUrl + _ad.mainImage!, fit: BoxFit.cover,),
      ),
    );
  }
}

//* Horizontal Product List
class HorizontalProductList extends StatelessWidget {
  const HorizontalProductList({
    super.key,
    required this.products
  });

  final List<CommercialAdItem> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizesDouble.s370,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) => VerticalProductCard(
          commercialAdType: products[index],
        ),
        separatorBuilder: (context, index) => SizedBox(width: AppSizesDouble.s10,),
      ),
    );
  }
}

//* Vertical Product Card
//? This is used in the Horizontal Product List
class VerticalProductCard extends StatefulWidget {
  const VerticalProductCard({
    super.key,
    required this.commercialAdType
  });
  final CommercialAdItem commercialAdType;

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}
class _VerticalProductCardState extends State<VerticalProductCard> {

  late ProductTypeData _typeData;
  @override
  void initState() {
    _typeData = getProductType(widget.commercialAdType.adsType?.name??'Sale');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.productDetails, arguments: widget.commercialAdType.id))),
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
            Stack(
              children: [
                SizedBox(
                  height: AppSizesDouble.s180,
                  width: double.infinity,
                  child: Image.network(AppConstants.baseImageUrl + widget.commercialAdType.mainImage!, fit: BoxFit.cover,),
                ),
                IntrinsicWidth(
                  child: Container(
                    margin: EdgeInsets.all(AppPaddings.p10),
                    padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s15, vertical: AppSizesDouble.s5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizesDouble.s8),
                      color: _typeData.color
                    ),
                    child: Text(_typeData.type),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(AppPaddings.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.commercialAdType.title, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text(widget.commercialAdType.description??'', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('${widget.commercialAdType.price} ${LocalizationService.translate(StringsManager.egp)}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.w600), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text('${widget.commercialAdType.city!.name}, ${widget.commercialAdType.region!.name}', style: Theme.of(context).textTheme.titleMedium, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                  SizedBox(height: AppSizesDouble.s5,),
                  Text(DateFormat('dd - MM - yyyy').format(DateTime.parse(widget.commercialAdType.createdAt!)), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
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
        log(typeData.toString());
        Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.productDetails, arguments: typeData)));
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
const VerticalProductsList({super.key, required this.isRecentlyViewed, this.isSaved = false, this.scrollable = true});
  final bool isRecentlyViewed;
  final bool isSaved;
  final bool scrollable;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: !scrollable,
      physics: !scrollable?NeverScrollableScrollPhysics():null,
      itemCount: 10,
      itemBuilder: (context, index) =>  HorizontalProductCard(type: 'Sale', isRecentlyViewing: isRecentlyViewed, isSaved: isSaved)
    );
  }
}

//* go to login screen
void navigateToAuthLayout(context) async{
  AppConstants.isGuest = false;
  AppConstants.isAuthenticated = false;
  AppConstants.token = '';
  await CacheHelper.saveData(key: KeysManager.isGuest, value: false);
  await CacheHelper.saveData(key: KeysManager.isAuthenticated, value: false);
  await CacheHelper.saveData(key: KeysManager.token, value: '');
  await MainCubit.get(context).logOut();
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
  const DefaultSwitch({
    super.key,
    required this.isActivated,
    required this.onChanged,
    required this.title,
    this.isOutlined = true,
    this.backgroundColor = ColorsManager.loginButtonBackgroundColor

  });
  final bool isOutlined;
  final bool isActivated;
  final ValueChanged<bool> onChanged;
  final Color backgroundColor;
  final String title;

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
              color: widget.backgroundColor,
              border: Border.all(color: widget.isOutlined?ColorsManager.grey:ColorsManager.transparent),
              borderRadius: BorderRadius.circular(AppSizesDouble.s8),
            ),
            child: Row(
              children: [
                FittedBox(child: Text(LocalizationService.translate(widget.title))),
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


class ExpandableList extends StatefulWidget {
  const ExpandableList({super.key, required this.title, required this.previewObject, required this.fullContent, this.isExpandable = true, this.padding = 15, this.titleHasHeader = true});

  final String title;
  final List<Widget> previewObject;
  final List<Widget> fullContent;
  final bool isExpandable;
  final double padding;
  final bool titleHasHeader;
  @override
  State<ExpandableList> createState() => _ExpandableListState();
}
class _ExpandableListState extends State<ExpandableList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: widget.padding, vertical: AppPaddings.p5),
          width: double.infinity,
          color: widget.titleHasHeader? ColorsManager.grey4:ColorsManager.transparent,
          child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
        ),
        ConditionalBuilder(
          condition: isExpanded,
          builder: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15, vertical: AppPaddings.p10),
            child: Column(
              children: widget.fullContent,
            ),
          ),
          fallback: (context) => Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15, vertical: AppPaddings.p10),
            child: Column(
              children: widget.previewObject,
            ),
          ),
        ),
        if(widget.isExpandable)
        Center(
          child: IconButton(
            onPressed: (){
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            icon: Icon(!isExpanded?IconsManager.downIcon:IconsManager.upIcon, color: ColorsManager.primaryColor,)
          ),
        )
      ],
    );
  }
}


class DefaultActionsRow extends StatelessWidget {
  const DefaultActionsRow({
    super.key,
    required this.children
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.grey4,
      width: double.infinity,
      height: AppSizesDouble.s70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children
      ),
    );
  }
}
class DefaultTitledIconButton extends StatelessWidget {
  const DefaultTitledIconButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed
  });
  final VoidCallback onPressed;
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: ColorsManager.transparent,
      onPressed: (){},
      alignment: Alignment.center,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(imagePath,),
          Text(title),
        ],
      ),
    );
  }
}


class DefaultTextInputField extends StatelessWidget {
   const DefaultTextInputField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isOutlined = false,
    this.obscured = true,
    this.hintText,
    this.onSuffixPressed,
    this.suffixIcon = '',
    this.borderColor = ColorsManager.grey2
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool isOutlined;
  final bool obscured;
  final String? hintText;
  final VoidCallback? onSuffixPressed;
  final String suffixIcon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      obscureText: obscured,
      maxLength: keyboardType == TextInputType.phone? AppSizes.s11:null,
      inputFormatters: keyboardType == TextInputType.number?[FilteringTextInputFormatter.digitsOnly]:null,
      cursorColor: ColorsManager.primaryColor,
      decoration: InputDecoration(
        fillColor: ColorsManager.loginButtonBackgroundColor,
        filled: true,
        hintText: LocalizationService.translate(hintText??''),
        suffixIcon: IconButton(
          onPressed: onSuffixPressed,
          icon: SvgPicture.asset(suffixIcon)
        ),
        prefixIcon: keyboardType == TextInputType.phone?Padding(
          padding: EdgeInsets.only(left: AppPaddings.p15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(LocalizationService.translate(StringsManager.egy), style: TextStyle(fontSize: AppSizesDouble.s17, fontWeight: FontWeight.bold),),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppMargins.m20),
                color: ColorsManager.grey3,
                width: AppSizesDouble.s1_5,
                height: AppSizesDouble.s40,
              )
            ],
          ),
        ):null,
        hintStyle: TextStyle(color: ColorsManager.grey3),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s8),
            borderSide: BorderSide(color: isOutlined?borderColor:ColorsManager.transparent)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s8),
            borderSide: BorderSide(color: ColorsManager.primaryColor)
        )
      ),
    );
  }
}


class DefaultFilterButton extends StatelessWidget {
  const DefaultFilterButton({
    super.key,
    required this.categories,
  });

  final CategoriesDataModel categories;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: (){
        showDialog(
          context: context,
          builder: (context) => FilterDialog(
            categories: categories,
          )
        );
      },
      label: Text(StringsManager.filter, style: Theme.of(context).textTheme.titleMedium,),
      icon: SvgPicture.asset(AssetsManager.filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s8),
            side: BorderSide(color: ColorsManager.grey)
        ),
        padding: EdgeInsets.all(AppPaddings.p10)
      ),
    );
  }
}

enum ToastState{
  info,
  success,
  warning,
  error
}

Color _getToastStateColor(ToastState state){
  switch(state){
    case ToastState.info:
      return ColorsManager.grey;
    case ToastState.warning:
      return ColorsManager.amber;
    case ToastState.success:
      return ColorsManager.green;
    case ToastState.error:
      return ColorsManager.deepRed;
  }
}

showToastMessage({
  required msg,
  ToastState toastState = ToastState.info
}){
  return Fluttertoast.showToast(
    msg: LocalizationService.translate(msg),
    backgroundColor: _getToastStateColor(toastState),
    gravity: ToastGravity.BOTTOM,
    fontSize: 18,
    textColor: toastState == ToastState.error || toastState == ToastState.success?ColorsManager.white:ColorsManager.black,
    toastLength: Toast.LENGTH_LONG,
  );
}


class DefaultCheckBox extends StatefulWidget {
  const DefaultCheckBox({super.key, required this.value, required this.title, required this.onChanged});
  final bool value;
  final ValueChanged onChanged;
  final String title;
  @override
  State<DefaultCheckBox> createState() => _DefaultCheckBoxState();
}
class _DefaultCheckBoxState extends State<DefaultCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget.value,
            fillColor: WidgetStatePropertyAll(ColorsManager.white),
            checkColor: ColorsManager.primaryColor,
            side: BorderSide(color: ColorsManager.primaryColor, width: 2),
            onChanged: widget.onChanged
        ),
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium,)
      ],
    );
  }
}

class DefaultCommercialGridItem extends StatelessWidget {
  const DefaultCommercialGridItem({
    super.key,
    required this.item
  });
  final CommercialAdItem item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.commercialDetails, arguments: item.id))),
      child: Container(
        margin: EdgeInsets.all(AppSizesDouble.s5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
          image: DecorationImage(image: NetworkImage(AppConstants.baseImageUrl + item.mainImage!,), fit: BoxFit.cover,)
        )
      ),
    );
  }
}

Future<void> launchUrlHelper(String url) async {
  final trimmedUrl = url.trim();
  final parsedUri = Uri.tryParse(trimmedUrl);

  if (parsedUri != null && parsedUri.isAbsolute) {
    try {
      await launchUrl(
        parsedUri,
        mode: LaunchMode.externalApplication
      );
    } on PlatformException catch (e) {
      showToastMessage(
        msg: 'Platform error: ${e.message}',
        toastState: ToastState.error,
      );
    } catch (e) {
      showToastMessage(
        msg: 'Failed to launch URL',
        toastState: ToastState.error,
      );
    }
  } else {
    showToastMessage(
      msg: 'Invalid URL: $trimmedUrl',
      toastState: ToastState.error,
    );
  }
}