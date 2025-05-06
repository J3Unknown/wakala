  import 'package:flutter/material.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultAuthButton extends StatelessWidget {
  const DefaultAuthButton({
    super.key,
    required VoidCallback onPressed,
    Color foregroundColor = ColorsManager.black,
    Color backgroundColor = ColorsManager.loginButtonBackgroundColor,
    IconData? icon,
    required String title,
    bool hasBorder = true
  }) : _onPressed=onPressed,
        _foregroundColor=foregroundColor,
        _backgroundColor=backgroundColor,
        _icon=icon,
        _hasBorder=hasBorder,
        _title=title;

  final VoidCallback _onPressed;
  final Color _backgroundColor;
  final Color _foregroundColor;
  final String _title;
  final IconData? _icon;
  final bool _hasBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizesDouble.s70,
      child: ElevatedButton.icon(
        onPressed: _onPressed,
        label: FittedBox(child: Text(_title, style: Theme.of(context).textTheme.titleLarge,)),
        icon: Icon(_icon, size: AppSizesDouble.s30,),
        style: ElevatedButton.styleFrom(
          foregroundColor: _foregroundColor,
          backgroundColor: _backgroundColor,
          elevation: AppSizesDouble.s0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
            side: _hasBorder? BorderSide(color: ColorsManager.grey2, width: AppSizesDouble.s2):BorderSide(color: ColorsManager.transparent)
          ),
          padding: EdgeInsets.all(AppPaddings.p10)
        ),
      ),
    );
  }
}