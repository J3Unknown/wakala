import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthFooterSection.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () async{
                AppConstants.isGuest = true;
                await CacheHelper.saveData(key: KeysManager.isGuest, value: true).then((value){
                  Navigator.pushReplacement(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.home)));
                });
              },
              child: Text(LocalizationService.translate(StringsManager.skip), style: Theme.of(context).textTheme.titleLarge,)
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
          child: Column(
            children: [
              AuthSection(
                children: [
                  SvgPicture.asset(AssetsManager.appIcon,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text(LocalizationService.translate(StringsManager.welcomeToWikala), style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                ],
              ),
              AuthSection(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DefaultAuthButton(
                    onPressed: () => Navigator.push(context,RoutesGenerator.getRoute(RouteSettings(name: Routes.login))),
                    icon: AssetsManager.phoneIcon,
                    title: StringsManager.signInWithPhone,
                  ),
                  // DefaultAuthButton(
                  //   onPressed: (){},
                  //   icon: AssetsManager.googleIcon,
                  //   title: StringsManager.signInWithGoogle,
                  // ),
               ]
              ),
              AuthSection(
                flex: AppSizes.s2,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: AppPaddings.p20),
                    child: AuthFooterSection(
                      title: StringsManager.notAMemberYet,
                      buttonTitle: StringsManager.signUp,
                      onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.signUp))),
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AuthFooterSection(
                    title: StringsManager.byContinueYouAgree,
                    buttonTitle: StringsManager.termsOfService,
                    onPressed: (){},
                  ),
                  AuthFooterSection(
                    title:StringsManager.andOur,
                    buttonTitle: StringsManager.privacyPolicy,
                    onPressed: (){},
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
