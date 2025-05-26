import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/icons_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultMoreTile extends StatelessWidget {
  const DefaultMoreTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.hasRightIcon = true,
  });
  final VoidCallback onTap;
  final String iconPath;
  final String title;
  final bool hasRightIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppPaddings.p5),
        width: double.infinity,
        height: AppSizesDouble.s50,
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: ColorsManager.loginButtonBackgroundColor,
          border: Border.all(color: ColorsManager.grey),
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: AppSizesDouble.s25, height: AppSizesDouble.s25,),
            SizedBox(width: AppSizesDouble.s5,),
            Text(title, style: Theme.of(context).textTheme.bodyLarge,),
            if(hasRightIcon)
              Spacer(),
            if(hasRightIcon)
              Icon(IconsManager.rightArrow, size: AppSizesDouble.s20,)
          ],
        ),
      ),
    );
  }
}