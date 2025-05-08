import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultPhoneInputField.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/strings_manager.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
          child: Column(
            children: [
              AuthSection(
                flex: AppSizes.s3,
                children: [
                  SvgPicture.asset(AssetsManager.appIcon,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text(StringsManager.enterYourPhone, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                ]
              ),
              AuthSection(
                flex: AppSizes.s6,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Form(key: _formKey, child: DefaultPhoneInputField(phoneNumberController: _phoneController)),
                  SizedBox(height: AppSizesDouble.s20,),
                  DefaultAuthButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.otp)));
                      }
                    },
                    title: StringsManager.submit,
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: ColorsManager.white,
                    hasBorder: false,
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
