import 'package:flutter/material.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultPhoneInputField extends StatelessWidget {
  const DefaultPhoneInputField({
    super.key,
    required TextEditingController phoneNumberController,
  }) : _phoneNumberController = phoneNumberController;

  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${StringsManager.phoneNumber} *'),
        TextFormField(
          controller: _phoneNumberController,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorsManager.loginButtonBackgroundColor,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: AppPaddings.p15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(StringsManager.egy, style: TextStyle(fontSize: AppSizesDouble.s17, fontWeight: FontWeight.bold),),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppMargins.m20),
                    color: ColorsManager.grey3,
                    width: AppSizesDouble.s1_5,
                    height: AppSizesDouble.s40,
                  )
                ],
              ),
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
