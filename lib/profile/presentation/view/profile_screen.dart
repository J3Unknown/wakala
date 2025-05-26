import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.profile, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            children: [
              ImageHeaderSection(),
              Padding(
                padding: EdgeInsets.all(AppPaddings.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name Very long', style: Theme.of(context).textTheme.titleLarge,),
                    Text('Very Big And Long Address', style: Theme.of(context).textTheme.bodyLarge,),
                    Text('Member Since the Development of This App', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(),
                    SizedBox(
                      height: constraints.maxHeight ,
                      child: VerticalProductsList(isRecentlyViewed: false)
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageHeaderSection extends StatelessWidget {
  const ImageHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.network(
            height: 230,
            width: double.infinity,
            'https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg',
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: EdgeInsets.all(AppPaddings.p10),
            child: Column(
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: ColorsManager.white,
                  ),
                  onPressed: (){},
                  icon: SvgPicture.asset(AssetsManager.edit, colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),)
                ),
                SizedBox(height: 10,),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: ColorsManager.white,
                  ),
                  onPressed: (){},
                  icon: SvgPicture.asset(AssetsManager.share, colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
