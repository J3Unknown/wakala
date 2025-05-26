import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';

import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class CommercialDetails extends StatelessWidget {
  const CommercialDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(IconsManager.closeIcon)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.commercialAdDetails, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppMargins.m15),
              height: AppSizesDouble.s350,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(AppSizesDouble.s8),
              ),
            ),
            SizedBox(height: AppSizesDouble.s20,),
            Container(
              color: ColorsManager.grey4,
              width: double.infinity,
              height: AppSizesDouble.s70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DefaultCommercialIconButton(
                    title: StringsManager.report,
                    onPressed: (){},
                    imagePath: AssetsManager.report,
                  ),
                  DefaultCommercialIconButton(
                    title: StringsManager.hide,
                    onPressed: (){},
                    imagePath: AssetsManager.hide,
                  ),
                  DefaultCommercialIconButton(
                    title: StringsManager.save,
                    onPressed: (){},
                    imagePath: AssetsManager.saved,
                  ),
                  DefaultCommercialIconButton(
                    title: StringsManager.share,
                    onPressed: (){},
                    imagePath: AssetsManager.share,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DefaultCommercialIconButton extends StatelessWidget {
  DefaultCommercialIconButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed
  });
  final VoidCallback onPressed;
  final String title;
  String imagePath;
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
