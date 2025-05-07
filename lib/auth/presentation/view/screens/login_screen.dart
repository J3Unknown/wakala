import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
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
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state){},
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
              child: Column(
                children: [
                  AuthSection(
                    children: [
                      SvgPicture.asset(AssetsManager.appIcon,),
                      SizedBox(height: AppSizesDouble.s10,),
                      Text(StringsManager.welcomeToWikala, style: Theme.of(context).textTheme.headlineMedium,),
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
                      DefaultAuthButton(onPressed: (){}, title: StringsManager.login, backgroundColor: ColorsManager.primaryColor, foregroundColor: ColorsManager.white, hasBorder: false,),
                      SizedBox(height: AppSizesDouble.s30,),
                      TextButton(
                        onPressed: (){},
                        style: TextButton.styleFrom(
                          foregroundColor: ColorsManager.primaryColor,
                        ),
                        child: Text(StringsManager.forgotPassword, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(StringsManager.dontHaveAccount, style: Theme.of(context).textTheme.titleMedium,),
                          TextButton(
                            onPressed: (){},
                            style: TextButton.styleFrom(
                              foregroundColor: ColorsManager.primaryColor,
                            ),
                            child: Text(StringsManager.signUp, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),),
                          )
                        ],
                      )
                    ]
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
