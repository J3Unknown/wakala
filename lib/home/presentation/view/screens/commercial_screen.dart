import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class CommercialScreen extends StatelessWidget {
  const CommercialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: AppSizes.s20,
      padding: EdgeInsets.all(AppPaddings.p10),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: AppSizes.s2),
      itemBuilder: (context, index) => DefaultCommercialGridItem()
    );
  }
}

class DefaultCommercialGridItem extends StatelessWidget {
  const DefaultCommercialGridItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.commercialDetails))),
      child: Container(
        margin: EdgeInsets.all(AppSizesDouble.s5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
          image: DecorationImage(image: NetworkImage('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg',), fit: BoxFit.cover,)
        )
      ),
    );
  }
}
