import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../widgets/DefaultPasswordInputField.dart';
import '../widgets/DefaultPhoneInputField.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthCubit.get(context).isObscured = true;
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){
        if(state is AuthLoginSuccessState){
          context.read<MainCubit>().getProfile();
          Navigator.pushAndRemoveUntil(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.home)), (route) => false);
        }
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButtonUntil(
              rootLayout: Routes.authLayout,
            )
          ),
          body: LayoutBuilder(
            builder: (context, constrains) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constrains.maxHeight
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                    child: Column(
                      children: [
                        AuthSection(
                          children: [
                            SvgPicture.asset(AssetsManager.appIcon,),
                            SizedBox(height: AppSizesDouble.s10,),
                            Text(LocalizationService.translate(StringsManager.loginToWikala), style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                          ]
                        ),
                        AuthSection(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  DefaultPhoneInputField(phoneNumberController: _phoneNumberController),
                                  DefaultPasswordInputField(passwordController: _passwordController, cubit: cubit)
                                ],
                              ),
                            )
                          ]
                        ),
                        AuthSection(
                          flex: AppSizes.s2,
                          children: [
                            DefaultAuthButton(
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  cubit.login(_phoneNumberController.text, _passwordController.text);
                                }
                              },
                              title: LocalizationService.translate(StringsManager.login),
                              backgroundColor: ColorsManager.primaryColor,
                              foregroundColor: ColorsManager.white,
                              hasBorder: false,
                              pressCondition: state is AuthLoginLoadingState,
                            ),
                            SizedBox(height: AppSizesDouble.s30,),
                            TextButton(
                              onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.forgotPassword))),
                              style: TextButton.styleFrom(
                                foregroundColor: ColorsManager.primaryColor,
                              ),
                              child: Text(LocalizationService.translate(StringsManager.forgotPassword), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(LocalizationService.translate(StringsManager.dontHaveAccount), style: Theme.of(context).textTheme.titleMedium,),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacementNamed(context,  Routes.signUp),
                                  style: TextButton.styleFrom(
                                    foregroundColor: ColorsManager.primaryColor,
                                  ),
                                  child: Text(LocalizationService.translate(StringsManager.signUp), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
                                )
                              ],
                            )
                          ]
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
