import 'package:flutter/material.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
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
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.search))),
      child: Hero(
        tag: KeysManager.searchBarHeroTag,
        child: SizedBox(
          width: double.infinity,
          height: AppSizesDouble.s60,
          child: Card(
            elevation: AppSizesDouble.s0,
            color: ColorsManager.grey1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                side: BorderSide(color: ColorsManager.grey)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s25),
              child: Row(
                children: [
                  Icon(IconsManager.searchIcon, color: ColorsManager.grey,),
                  SizedBox(width: AppSizesDouble.s20,),
                  Text(LocalizationService.translate(StringsManager.searchHint), style: TextStyle(color: ColorsManager.grey),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

