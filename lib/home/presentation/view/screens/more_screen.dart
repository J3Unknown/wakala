import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/local/locale_changer.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../auth/presentation/view/widgets/DefaultMoreTile.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  //TODO: Invert all the is Authorized Checkers, it set to be the opposite just for Feature Development
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
        child: Column(
          children: [
            SizedBox(
              width: AppSizesDouble.s100,
              height: AppSizesDouble.s100,
              child: InkWell(
                onTap: !AppConstants.isAuthenticated? () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.profile))):null ,
                child: ClipOval(
                  child: !AppConstants.isAuthenticated?
                  Image.network('https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg', fit: BoxFit.cover,):
                  SvgPicture.asset(AssetsManager.defaultAvatar, fit: BoxFit.cover,),
                ),
              ),
            ),
            Text(!AppConstants.isAuthenticated?'Welcome User':'Welcome, Guest', style: Theme.of(context).textTheme.titleLarge,),
            SizedBox(height: AppSizesDouble.s10,),
            if(AppConstants.isAuthenticated)
            SizedBox(
              width: deviceSize(context).width/AppSizes.s2,
              child: DefaultAuthButton(
                onPressed: () => navigateToAuthLayout(context),
                title: LocalizationService.translate(StringsManager.login),
                foregroundColor: ColorsManager.white,
                backgroundColor: ColorsManager.primaryColor,
                hasBorder: false,
              ),
            ),
            if(AppConstants.isAuthenticated)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(LocalizationService.translate(StringsManager.dontHaveAccount), style: Theme.of(context).textTheme.titleMedium,),
                TextButton(
                  onPressed: () => navigateToAuthLayout(context),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorsManager.primaryColor,
                  ),
                  child: Text(StringsManager.signUp, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
                )
              ],
            ),
            if(!AppConstants.isAuthenticated)
            DefaultMoreTile(
              onTap: () => showDialog(context: context, builder: (context) => NotificationsAlert()),
              iconPath: AssetsManager.notificationsIcon,
              title: LocalizationService.translate(StringsManager.notificationsSettings),
              hasRightIcon: false,
            ),
            if(!AppConstants.isAuthenticated)
            DefaultMoreTile(
              onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.myAds))),
              iconPath: AssetsManager.libraryAdd,
              title: LocalizationService.translate(StringsManager.myAds),
            ),
            DefaultMoreTile(
              onTap: (){
                if(!AppConstants.isAuthenticated){
                  Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.recentlyViewing)));
                } else{
                  showDialog(
                    context: context,
                    builder: (context) => LoginAlert()
                  );
                }
              },
              iconPath: AssetsManager.eyeVisibilityOff,
              title: LocalizationService.translate(StringsManager.recentlyViewed),
            ),
            if(!AppConstants.isAuthenticated)
            DefaultMoreTile(
              onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.saved))),
              iconPath: AssetsManager.saved,
              title: LocalizationService.translate(StringsManager.saved),
            ),
            DefaultMoreTile(
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => LanguageAlert()
                );
              },
              iconPath: AssetsManager.language,
              title: LocalizationService.translate(StringsManager.language),
              hasRightIcon: false,
            ),
            DefaultMoreTile(
              onTap: (){},
              iconPath: AssetsManager.supportAgent,
              title: LocalizationService.translate(StringsManager.support),
            ),
            DefaultMoreTile(
              onTap: (){},
              iconPath: AssetsManager.aboutUs,
              title: LocalizationService.translate(StringsManager.aboutUs),
            ),
            DefaultMoreTile(
              onTap: (){},
              iconPath: AssetsManager.termsAndConditions,
              title: LocalizationService.translate(StringsManager.termsAndConditions),
            ),
            if(!AppConstants.isAuthenticated)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IntrinsicWidth(
                child: DefaultAuthButton(
                  onPressed: () => navigateToAuthLayout (context),
                  title: LocalizationService.translate(StringsManager.logout),
                  backgroundColor: ColorsManager.transparent,
                  icon: AssetsManager.logout,
                  hasBorder: false,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


