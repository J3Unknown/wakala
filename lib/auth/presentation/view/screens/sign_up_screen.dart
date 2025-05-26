import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){},
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
                                DefaultInputField(controller: _nameController, title: LocalizationService.translate(StringsManager.fullName), hint: LocalizationService.translate(StringsManager.nameHintText),),
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
                          DefaultAuthButton(onPressed: (){}, title: LocalizationService.translate(StringsManager.signUp), hasBorder: false, foregroundColor: ColorsManager.white, backgroundColor: ColorsManager.primaryColor,),
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
