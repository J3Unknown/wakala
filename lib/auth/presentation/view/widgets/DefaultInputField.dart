import 'package:flutter/material.dart';
import 'package:wakala/utilities/local/localization_services.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultInputField extends StatelessWidget {
  const DefaultInputField({
    super.key,
    required TextEditingController controller,
    required String title,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) : _controller = controller, _keyboardType = keyboardType, _title = title, _hint = hint;

  final TextEditingController _controller;
  final TextInputType _keyboardType;
  final String _title;
  final String? _hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${LocalizationService.translate(_title)} *'),
        TextFormField(
          controller: _controller,
          keyboardType: _keyboardType,
          validator: (value){
            if(value!.isEmpty){
              return LocalizationService.translate(StringsManager.validFieldMessage);
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorsManager.loginButtonBackgroundColor,
            hintText: LocalizationService.translate(_hint??''),
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
