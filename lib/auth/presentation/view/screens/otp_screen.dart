import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({required this.phone, super.key});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late AuthCubit _authCubit;
  late String _phoneNumber;

  @override
  void initState() {
    _phoneNumber = widget.phone;
    _authCubit = AuthCubit.get(context);
    _authCubit.initializeStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: LayoutBuilder(
          builder:(context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight
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
                          Text(LocalizationService.translate(StringsManager.enterReceivedOTP), style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),),
                        ]
                      ),
                      AuthSection(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
                            child: PinCodeTextField(
                              autoFocus: true,
                              pinTheme: PinTheme(
                                borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                                shape: PinCodeFieldShape.box,
                                fieldHeight: AppSizesDouble.s60,
                                fieldWidth: AppSizesDouble.s45,
                                inactiveColor: ColorsManager.grey,
                                selectedColor: ColorsManager.primaryColor,
                              ),
                              appContext: context,
                              length: AppSizes.s4,
                              keyboardType: TextInputType.number,
                              controller: _otpController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value){
                                if(value!.length != AppSizes.s4){
                                  return LocalizationService.translate(StringsManager.validOtpMessage);
                                }
                                return null;
                              },
                            ),
                          ),
                          DefaultAuthButton(
                            onPressed: (){},
                            title: LocalizationService.translate(StringsManager.confirm),
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
                              return Text('${_authCubit.counter}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold),);
                            }
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(LocalizationService.translate(StringsManager.notReceived), style: Theme.of(context).textTheme.titleMedium,),
                              TextButton(
                                onPressed: _authCubit.canResendCode? () => _sendVerificationCode():null,
                                child: Text(LocalizationService.translate(StringsManager.sendAgain), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: _authCubit.canResendCode?ColorsManager.primaryColor:ColorsManager.grey),),
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


  void _sendVerificationCode(){
    _authCubit.sendVerificationCode();
  }
}
