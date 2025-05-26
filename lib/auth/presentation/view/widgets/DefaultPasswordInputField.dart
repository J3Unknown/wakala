import 'package:flutter/material.dart';

import '../../../../utilities/local/localization_services.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/icons_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../../cubit/auth_cubit.dart';

class DefaultPasswordInputField extends StatelessWidget {
  const DefaultPasswordInputField({
    super.key,
    required TextEditingController passwordController,
    required this.cubit,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${LocalizationService.translate(StringsManager.password)} *'),
        TextFormField(
          controller: _passwordController,
          obscureText: cubit.isObscured,
          keyboardType: TextInputType.visiblePassword,
          validator: (value){
            if(value!.isEmpty){
              return LocalizationService.translate(StringsManager.validFieldMessage);
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorsManager.loginButtonBackgroundColor,
            suffixIcon: IconButton(
              icon: Icon(
                cubit.isObscured?IconsManager.obscuredIcon:IconsManager.nonObscuredIcon,
                color: cubit.isObscured?ColorsManager.grey3:ColorsManager.primaryColor,
              ),
              onPressed: () => cubit.changeObscured(),
            ),
            hintText: StringsManager.hintText,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                borderSide: BorderSide(color: ColorsManager.grey3, width: AppSizesDouble.s2)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                borderSide: BorderSide(color: ColorsManager.primaryColor)
            ),
          ),
        ),
      ],
    );
  }
}