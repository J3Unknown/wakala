import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wakala/auth/data/create_password_screen_arguments.dart';
import 'package:wakala/auth/data/otp_screen_arguments.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late AuthCubit _authCubit;
  late String _phoneNumber;
  late bool _isResetPassword;
  late String _name;
  late String _password;

  @override
  void didChangeDependencies() {
    final OtpScreenArguments args = ModalRoute.of(context)!.settings.arguments as OtpScreenArguments;
    _phoneNumber = args.phone;
    _isResetPassword = args.isResetPassword;
    _name = args.name;
    _password = args.password;
    super.didChangeDependencies();
  }

  void _sendVerificationCode(){
    _authCubit.timer();
    if(_isResetPassword){
      _authCubit.sendForgotPasswordOtp(_phoneNumber);
    } else {
      _authCubit.sendVerificationCode(_phoneNumber);
    }
  }

  @override
  void initState() {
    _authCubit = AuthCubit.get(context);
    _authCubit.initializeStream();
    _authCubit.timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state){
        if(state is AuthSignUpSuccessState){
          showToastMessage(msg: LocalizationService.translate(StringsManager.loginSuccess), toastState: ToastState.success);
          Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.home)));
        }
      },
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
                            onPressed: (){
                              if(int.parse(_otpController.text) != _authCubit.otpCode){
                                showToastMessage(
                                  msg: LocalizationService.translate(StringsManager.invalidOtp),
                                  toastState: ToastState.info
                                );
                              } else {
                                if(_isResetPassword){
                                  Navigator.push(
                                    context,
                                    RoutesGenerator.getRoute(
                                      RouteSettings(
                                        name: Routes.createPassword,
                                        arguments: CreatePasswordScreenArguments(
                                          phone: _phoneNumber,
                                          otpCode: _authCubit.otpCode!,
                                        )
                                      )
                                    )
                                  );
                                } else {
                                  _authCubit.register(
                                    phone: _phoneNumber,
                                    name: _name,
                                    otpCode: _authCubit.otpCode!,
                                    password: _password
                                  );
                                }
                              }
                            },
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
}
