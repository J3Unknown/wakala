import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../product_details_screen.dart';

class DefaultProductDetailsHeaderSection extends StatelessWidget {
  DefaultProductDetailsHeaderSection({
    super.key,
    required this.previewImages,
    required this.widget,
  });
  final PageController _pageController = PageController();
  final List<Image> previewImages;
  final ProductDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: AppSizesDouble.s300,
              child: PageView(
                pageSnapping: true,
                controller: _pageController,
                children: previewImages,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      margin: EdgeInsets.all(AppPaddings.p10),
                      padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s15, vertical: AppSizesDouble.s5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
                          color: widget.typeData.color
                      ),
                      child: Text(widget.typeData.type),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: (){},
                    icon: SvgPicture.asset(AssetsManager.saved, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                    style: IconButton.styleFrom(
                      backgroundColor: ColorsManager.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 0,
              left: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: previewImages.length,
                  effect: ScrollingDotsEffect(
                    activeDotScale: AppSizesDouble.s1_5,
                    dotHeight: AppSizesDouble.s10,
                    dotWidth: AppSizesDouble.s10,
                    activeDotColor: ColorsManager.white,
                    dotColor: ColorsManager.white.withValues(alpha: AppSizesDouble.s0_7),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(AppPaddings.p15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Title', style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),),
              Text('Product Glance Description', style: Theme.of(context).textTheme.titleMedium,),
              if(widget.typeData.type == 'Sale')
                Text('500 EGP', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold)),
              Text('22 Hour', style: Theme.of(context).textTheme.titleMedium,),
            ],
          ),
        )
      ],
    );
  }
}