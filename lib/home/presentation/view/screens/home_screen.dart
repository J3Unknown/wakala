import 'package:flutter/material.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../widgets/search_button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
        child: Column(
          children: [
            CategoriesScroll(),
            SearchButton(),
            AdsBannerSection(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), //TODO: Get the Image from the Back End
            TopSection(title: 'Top Commercials',),
            TopSection(title: 'Top Automotive',),
            TopSection(title: 'Top Real-Estate',),
            AdsBannerSection(imgSrc: 'https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), //TODO: Get the Image from the Back End
            HorizontalProductList(),
          ],
        ),
      ),
    );
  }
}
