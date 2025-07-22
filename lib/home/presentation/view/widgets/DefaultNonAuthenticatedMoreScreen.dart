import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

import '../../../../auth/presentation/view/widgets/DefaultAuthButton.dart';
import '../../../../auth/presentation/view/widgets/DefaultMoreTile.dart';
import '../../../../utilities/local/localization_services.dart';
import '../../../../utilities/resources/alerts.dart';
import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultNonAuthenticatedMoreScreen extends StatelessWidget {
  const DefaultNonAuthenticatedMoreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppSizesDouble.s100,
          height: AppSizesDouble.s100,
          child: ClipOval(
            child: SvgPicture.asset(AssetsManager.defaultAvatar, fit: BoxFit.cover,),
          ),
        ),
        Text(LocalizationService.translate(StringsManager.welcomeGuest), style: Theme.of(context).textTheme.titleLarge,),
        SizedBox(height: AppSizesDouble.s10,),
        SizedBox(
          width: deviceSize(context).width/AppSizes.s2,
          child: DefaultAuthButton(
            onPressed: () {
              MainCubit.get(context).changeBottomNavBarIndex(0);
              navigateToAuthLayout(context);
            },
            title: StringsManager.login,
            foregroundColor: ColorsManager.white,
            backgroundColor: ColorsManager.primaryColor,
            hasBorder: false,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocalizationService.translate(StringsManager.dontHaveAccount), style: Theme.of(context).textTheme.titleMedium,),
            TextButton(
              onPressed: () => navigateToAuthLayout(context),
              style: TextButton.styleFrom(
                foregroundColor: ColorsManager.primaryColor,
              ),
              child: Text(LocalizationService.translate(StringsManager.signUp), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
            )
          ],
        ),
        DefaultMoreTile(
          onTap: () => showDialog(context: context, builder: (context) => LoginAlert()),
          iconPath: AssetsManager.eyeVisibilityOff,
          title: StringsManager.recentlyViewed,
        ),
        DefaultMoreTile(
          onTap: () => showDialog(context: context, builder: (context) => LanguageAlert()),
          iconPath: AssetsManager.language,
          title: StringsManager.language,
          hasRightIcon: false,
        ),
        DefaultMoreTile(
          onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.support))),
          iconPath: AssetsManager.supportAgent,
          title: StringsManager.support,
        ),
        DefaultMoreTile(
          onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.aboutUs))),
          iconPath: AssetsManager.aboutUs,
          title: StringsManager.aboutUs,
        ),
        DefaultMoreTile(
          onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.termsAndConditions))),
          iconPath: AssetsManager.termsAndConditions,
          title: StringsManager.termsAndConditions,
        ),
      ],
    );
  }
}