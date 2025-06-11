import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/data/create_password_screen_arguments.dart';
import 'package:wakala/auth/presentation/cubit/auth_cubit.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late final String _phone;
  late final int _otpCode;

  @override
  void didChangeDependencies() {
    final CreatePasswordScreenArguments args = ModalRoute.of(context)!.settings.arguments as CreatePasswordScreenArguments;
    _phone = args.phone;
    _otpCode = args.otpCode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainCubitStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
              child: Text(LocalizationService.translate(StringsManager.createPassword), style: Theme.of(context).textTheme.titleLarge,),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizesDouble.s20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultTextInputField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  isOutlined: true,
                  hintText: StringsManager.password,
                  obscured: MainCubit.get(context).isObscured,
                  suffixIcon: MainCubit.get(context).isObscured? AssetsManager.eyeVisibilityOff:AssetsManager.eyeVisibility,
                  onSuffixPressed: () => MainCubit.get(context).changeEyeVisibility(),
                  validator: (String? value){
                    if(value!.isEmpty){
                      return LocalizationService.translate(StringsManager.emptyFieldMessage);
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizesDouble.s15,),
                DefaultTextInputField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  isOutlined: true,
                  hintText: StringsManager.confirmPassword,
                  obscured: MainCubit.get(context).isObscured,
                  validator: (String? value){
                    if(value!.isEmpty){
                      return LocalizationService.translate(StringsManager.emptyFieldMessage);
                    } else if(_confirmPasswordController.text != _passwordController.text){
                      return LocalizationService.translate(StringsManager.passwordMismatchMessage);
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizesDouble.s15,),
                DefaultAuthButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      AuthCubit.get(context).resetPassword(
                        phone: _phone,
                        otpCode: _otpCode,
                        password: _passwordController.text,
                        passwordConfirmation: _confirmPasswordController.text
                      );
                    }
                  },
                  title: StringsManager.createPassword,
                  height: AppSizesDouble.s60,
                  hasBorder: false,
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: ColorsManager.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
