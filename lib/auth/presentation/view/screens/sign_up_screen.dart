import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/auth/data/otp_screen_arguments.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultInputField.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultPasswordInputField.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultPhoneInputField.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthCubit.get(context).isObscured = true;
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){
        if(state is AuthSendingOtpCodeSuccessState){
          Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.otp, arguments: OtpScreenArguments(_phoneController.text, false, name: _nameController.text, password: _passwordController.text))));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: BackButtonUntil(rootLayout: Routes.authLayout)
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
                        flex: AppSizes.s3,
                        children: [
                          SvgPicture.asset(AssetsManager.appIcon,),
                          SizedBox(height: AppSizesDouble.s10,),
                          Text(LocalizationService.translate(StringsManager.signUpToWikala), style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                        ]
                      ),
                      AuthSection(
                        flex: AppSizes.s4,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                DefaultInputField(controller: _nameController, title: StringsManager.fullName, hint: StringsManager.nameHintText,),
                                SizedBox(height: AppSizesDouble.s20,),
                                DefaultPhoneInputField(phoneNumberController: _phoneController),
                                DefaultPasswordInputField(passwordController: _passwordController, cubit: AuthCubit.get(context)),
                              ],
                            ),
                          ),
                        ]
                      ),
                      AuthSection(
                        flex: AppSizes.s5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultAuthButton(
                            onPressed: () async{
                              if(_formKey.currentState!.validate()){
                                AuthCubit.get(context).sendVerificationCode(_phoneController.text);
                              }
                            },
                            title: StringsManager.signUp,
                            hasBorder: false,
                            foregroundColor: ColorsManager.white,
                            backgroundColor: ColorsManager.primaryColor,
                            pressCondition: state is AuthSendingOtpCodeLoadingState,
                          ),
                          SizedBox(height: AppSizesDouble.s15,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(LocalizationService.translate(StringsManager.alreadyHaveAccount), style: Theme.of(context).textTheme.titleMedium,),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context,  Routes.login),
                                style: TextButton.styleFrom(
                                  foregroundColor: ColorsManager.primaryColor,
                                ),
                                child: Text(LocalizationService.translate(StringsManager.login), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
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
      ),
    );
  }
}
