import 'package:flutter/material.dart';
import 'package:wakala/utilities/local/localization_services.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class AuthFooterSection extends StatelessWidget {
  const AuthFooterSection({
    super.key,
    required String title,
    required String buttonTitle,
    required VoidCallback onPressed,
    TextStyle? textStyle,
  }) : _title=title, _buttonTitle=buttonTitle, _onPressed=onPressed, _textStyle=textStyle;

  final String _title;
  final String _buttonTitle;
  final VoidCallback _onPressed;
  final TextStyle? _textStyle;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocalizationService.translate(_title), style: _textStyle??Theme.of(context).textTheme.titleMedium,),
          SizedBox(
            height: AppSizesDouble.s25,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: AppPaddings.p5),
              ),
              onPressed: _onPressed,
              child: Text(
                LocalizationService.translate(_buttonTitle),
                style: _textStyle?.copyWith(color: ColorsManager.primaryColor)??Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor)
              )
            ),
          )
        ],
      ),
    );
  }
}