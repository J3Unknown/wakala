import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';

import '../../../home/cubit/main_cubit.dart';
import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class CommercialDetails extends StatefulWidget {
  const CommercialDetails({super.key, required this.id});
  final int id;

  @override
  State<CommercialDetails> createState() => _CommercialDetailsState();
}

class _CommercialDetailsState extends State<CommercialDetails> {
  final PageController _pageController = PageController();

  final List<Image> previewImages = [
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
    Image.network('https://www.mouthmatters.com/wp-content/uploads/2024/07/placeholder-wide.jpg', fit: BoxFit.cover,),
  ];

  @override
  void initState() {
    MainCubit.get(context).getCommercialAds();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () =>Navigator.pop(context), icon: Icon(IconsManager.closeIcon)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.commercialAdDetails, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers:  [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: AppMargins.m15),
              height: AppSizesDouble.s350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizesDouble.s8),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: [
                  PageView(
                    pageSnapping: true,
                    controller: _pageController,
                    children: previewImages,
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
              )
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSizesDouble.s20,)),
          SliverToBoxAdapter(
            child: DefaultActionsRow(
              children:[
                DefaultTitledIconButton(
                  title: StringsManager.report,
                  onPressed: (){},
                  imagePath: AssetsManager.report,
                ),
                DefaultTitledIconButton(
                  title: StringsManager.hide,
                  onPressed: (){},
                  imagePath: AssetsManager.hide,
                ),
                DefaultTitledIconButton(
                  title: StringsManager.save,
                  onPressed: (){},
                  imagePath: AssetsManager.saved,
                ),
                DefaultTitledIconButton(
                  title: StringsManager.share,
                  onPressed: (){},
                  imagePath: AssetsManager.share,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: ExpandableList(
              titleHasHeader: false,
              title: 'Description',
              previewObject: [
                Text('Preview Description')
              ],
              fullContent: [
                Text('Full Description'),
                Text('Full Description'),
                Text('Full Description'),
                Text('Full Description'),
                Text('Full Description'),
              ]
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: DefaultAuthButton(
                      backgroundColor: ColorsManager.primaryColor,
                      foregroundColor: ColorsManager.white,
                      icon: AssetsManager.chatsIcon,
                      iconColor: ColorsManager.white,
                      hasBorder: false,
                      onPressed: (){},
                      title: 'Message',
                      height: AppSizesDouble.s60,
                    ),
                  ),
                  SizedBox(width: AppSizesDouble.s5,),
                  Expanded(
                    child: DefaultAuthButton(
                      backgroundColor: ColorsManager.primaryColor,
                      foregroundColor: ColorsManager.white,
                      icon: AssetsManager.call,
                      iconColor: ColorsManager.white,
                      hasBorder: false,
                      onPressed: (){},
                      title: 'Call',
                      height: AppSizesDouble.s60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSizesDouble.s10,)),
          SliverGrid.builder(
            itemCount: MainCubit.get(context).commercialAdDataModel!.result!.commercialAdsItems!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              return DefaultCommercialGridItem(item: MainCubit.get(context).commercialAdDataModel!.result!.commercialAdsItems![index]);
            },
          ),
        ],
      ),
    );
  }
}

