import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class HorizontalCategoryButton extends StatelessWidget {

  final String title;
  final String image;

  const HorizontalCategoryButton({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: EdgeInsets.only(bottom: AppMargins.m5),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                side: BorderSide(color: ColorsManager.black, width: AppSizesDouble.s2)
              ),
              child: SvgPicture.asset(AssetsManager.productPlaceHolder, fit: BoxFit.cover, width: AppSizesDouble.s60, height: AppSizesDouble.s60,),
            ),
            SizedBox(width: AppSizesDouble.s5,),
            Text(
              title,
              style: TextStyle(
                color: ColorsManager.primaryColor,
                fontSize: AppSizesDouble.s18
              ),
              maxLines: AppSizes.s2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}