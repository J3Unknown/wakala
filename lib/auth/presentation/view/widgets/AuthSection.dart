import 'package:flutter/material.dart';

class AuthSection extends StatelessWidget {
  const AuthSection({
    super.key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center
  }) : _children=children,_mainAxisAlignment=mainAxisAlignment;

  final List<Widget> _children;
  final MainAxisAlignment _mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: _mainAxisAlignment,
        children: _children,
      ),
    );
  }
}