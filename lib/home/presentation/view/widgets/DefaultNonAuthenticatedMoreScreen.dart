import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            onPressed: () => navigateToAuthLayout(context),
            title: LocalizationService.translate(StringsManager.login),
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
              child: Text(StringsManager.signUp, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
            )
          ],
        ),
        DefaultMoreTile(
          onTap: () => showDialog(context: context, builder: (context) => LoginAlert()),
          iconPath: AssetsManager.eyeVisibilityOff,
          title: LocalizationService.translate(StringsManager.recentlyViewed),
        ),
        DefaultMoreTile(
          onTap: () => showDialog(context: context, builder: (context) => LanguageAlert()),
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
      ],
    );
  }
}