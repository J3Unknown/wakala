import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/profile/presentation/view/widgets/profile_screen_arguments.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';

import '../../../../auth/presentation/view/widgets/DefaultAuthButton.dart';
import '../../../../auth/presentation/view/widgets/DefaultMoreTile.dart';
import '../../../../utilities/local/localization_services.dart';
import '../../../../utilities/resources/alerts.dart';
import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/repo.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultAuthenticatedMoreScreen extends StatelessWidget {
  const DefaultAuthenticatedMoreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: AppSizesDouble.s100,
          height: AppSizesDouble.s100,
          child: InkWell(
            onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.profile, arguments: ProfileScreenArguments(isOthers: false, profileDataModel: Repo.profileDataModel!)))) ,
            child: ClipOval(
              child: Repo.profileDataModel!.result!.image != null?
              Image.network(AppConstants.baseImageUrl + Repo.profileDataModel!.result!.image!, fit: BoxFit.cover,):
              SvgPicture.asset(AssetsManager.defaultAvatar, fit: BoxFit.cover,),
            ),
          ),
        ),
        Text('${LocalizationService.translate(StringsManager.welcome)} ${Repo.profileDataModel!.result!.name}', style: Theme.of(context).textTheme.titleLarge,),
        SizedBox(height: AppSizesDouble.s10,),
        DefaultMoreTile(
          onTap: () => showDialog(context: context, builder: (context) => NotificationsAlert()),
          iconPath: AssetsManager.notificationsIcon,
          title: StringsManager.notificationsSettings,
          hasRightIcon: false,
        ),
        DefaultMoreTile(
          onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.myAds))),
          iconPath: AssetsManager.libraryAdd,
          title: StringsManager.myAds,
        ),
        DefaultMoreTile(
          onTap: (){
            Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.recentlyViewing)));
          },
          iconPath: AssetsManager.eyeVisibilityOff,
          title: StringsManager.recentlyViewed,
        ),
        DefaultMoreTile(
          onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.saved))),
          iconPath: AssetsManager.saved,
          title: StringsManager.saved,
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
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: IntrinsicWidth(
            child: DefaultAuthButton(
              onPressed: () async => await MainCubit.get(context).logOut(),
              title: StringsManager.logout,
              backgroundColor: ColorsManager.transparent,
              icon: AssetsManager.logout,
              hasBorder: false,
            ),
          ),
        )
      ],
    );
  }
}