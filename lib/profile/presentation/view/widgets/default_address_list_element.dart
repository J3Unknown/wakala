import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class DefaultAddressListElement extends StatelessWidget {
  const DefaultAddressListElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s10),
      width: double.infinity,
      height: AppSizesDouble.s50,
      decoration: BoxDecoration(
        color: ColorsManager.loginButtonBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizesDouble.s8),
        border: Border.all(color: ColorsManager.grey2)
      ),
      child: Row(
        children: [
          Text('Very Long Address That Never Exists'),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addAddress))),
            icon: SvgPicture.asset(
              AssetsManager.edit,
              colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),
            )
          )
        ],
      ),
    );
  }
}
