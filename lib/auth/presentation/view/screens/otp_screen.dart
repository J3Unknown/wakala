import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    AuthCubit.get(context).initializeStream();
    super.initState();
  }

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
                children: [
                  SvgPicture.asset(AssetsManager.appIcon,),
                  SizedBox(height: AppSizesDouble.s10,),
                  Text(StringsManager.loginToWikala, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                ]
              ),
              AuthSection(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PinCodeTextField(
                    appContext: context,
                    length: AppSizes.s4,
                    keyboardType: TextInputType.number,
                    controller: _otpController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  DefaultAuthButton(
                    onPressed: (){},
                    title: StringsManager.confirm,
                    hasBorder: false,
                    foregroundColor: ColorsManager.white,
                    backgroundColor: ColorsManager.primaryColor,
                  )
                ]
              ),
              AuthSection(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: AuthCubit.get(context).timerStream,
                    builder: (context, snapShot){
                      return Text('${AuthCubit.get(context).counter}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold),);
                    }
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(StringsManager.notReceived, style: Theme.of(context).textTheme.titleMedium,),
                      TextButton(
                        onPressed: AuthCubit.get(context).canResendCode? () => _sendVerificationCode():null,
                        child: Text(StringsManager.sendAgain, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AuthCubit.get(context).canResendCode?ColorsManager.primaryColor:ColorsManager.grey),),
                      )
                    ],
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  void _sendVerificationCode(){
    AuthCubit.get(context).sendVerificationCode();
  }
}
