import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/search_screen/presentation/view/widgets/filter_dialog.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: 'property0', child: Text('property1', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property1', child: Text('property2', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property2', child: Text('property3', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property3', child: Text('property4', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property4', child: Text('property5', style: TextStyle(color: ColorsManager.black))),
  ];
  @override
  void initState() {
    super.initState();
  }

  bool isSelected = false;
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoriesScroll(),
              if(isSelected)
              ElevatedButton.icon(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => FilterDialog(
                      firstDropdownItems: items,
                      secondDropdownItems: items,
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
              ),
              AdsBannerSection(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg'),
              Expanded(child: VerticalProductsList(isRecentlyViewed: true))
            ],
          ),
        ) 
      ),
    );
  }
}
