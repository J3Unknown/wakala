import 'package:flutter/material.dart';
import '../../../../utilities/resources/components.dart';
import '../widgets/search_button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CategoriesScroll(),
          SearchButton(),
          
        ],
      ),
    );
  }
}
