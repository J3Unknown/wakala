import 'package:flutter/material.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/icons_manager.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      child: InkWell(
        onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search))),
        child: Hero(
          tag: 'Search-Bar',
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Card(
              color: ColorsManager.grey1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                  side: BorderSide(color: ColorsManager.grey)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Icon(IconsManager.searchIcon, color: ColorsManager.grey,),
                    SizedBox(width: AppSizesDouble.s20,),
                    Text('What are you looking for?', style: TextStyle(color: ColorsManager.grey),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

