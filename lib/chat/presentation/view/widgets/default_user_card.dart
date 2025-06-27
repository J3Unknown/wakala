import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/profile/presentation/view/widgets/profile_screen_arguments.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultUserCard extends StatelessWidget {
  DefaultUserCard({
    super.key,
    this.hasMargin = true,
    this.hasUnderline = true,
    this.user
  });

  final bool hasMargin;
  final bool hasUnderline;
  User? user;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.profile, arguments: ProfileScreenArguments(id: user!.id, isOthers: true)))),
      child: Container(
        margin: hasMargin?EdgeInsets.only(bottom: AppMargins.m15):null,
        padding: hasMargin?EdgeInsets.symmetric(horizontal: AppPaddings.p10):null,
        width: double.infinity,
        height: AppSizesDouble.s60,
        decoration: hasUnderline?BoxDecoration(border: Border(bottom: BorderSide(color: ColorsManager.grey))):null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: user?.image != null? NetworkImage(AppConstants.baseImageUrl + user!.image!):Svg(AssetsManager.defaultAvatar),
            ),
            SizedBox(width: 5,),
            Text(user!.name, style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ),
    );
  }
}