import 'package:flutter/material.dart';

class AuthSection extends StatelessWidget {
  const AuthSection({
    super.key,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    int? flex,
  }) : _children=children,_mainAxisAlignment=mainAxisAlignment, _flex=flex;

  final List<Widget> _children;
  final MainAxisAlignment _mainAxisAlignment;
  final int? _flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex??1,
      child: Column(
        mainAxisAlignment: _mainAxisAlignment,
        children: _children,
      ),
    );
  }
}