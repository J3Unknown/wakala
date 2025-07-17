import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

import '../../../../home/data/specific_ad_data_model.dart';
import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultProductDetailsHeaderSection extends StatefulWidget {
  const DefaultProductDetailsHeaderSection({
    super.key,
    required this.previewImages,
    required this.typeData,
    required this.ad,
  });
  final List<AdImage> previewImages;
  final ProductTypeData typeData;
  final Ad ad;
  @override
  State<DefaultProductDetailsHeaderSection> createState() => _DefaultProductDetailsHeaderSectionState();
}

class _DefaultProductDetailsHeaderSectionState extends State<DefaultProductDetailsHeaderSection> {
  final PageController _pageController = PageController();
  bool isSaved = false;

  @override
  void initState() {
    if(MainCubit.get(context).savedAdsDataModel != null){
      _checkIfSaved();
    }
    super.initState();
  }

  _checkIfSaved() {
    isSaved = MainCubit.get(context).savedAdsDataModel!.result!.any((e) {
      return e.adId == widget.ad.id!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if(state is MainSaveAdSuccessState || state is MainUnSaveAdSuccessState){
          _checkIfSaved();
        }

        if(state is MainGetSavedAdsSuccessState){
          _checkIfSaved();
        }
      },
      builder: (context, state) => Column(
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
                  children: List.generate(widget.previewImages.length, (index) => Image.network(AppConstants.baseImageUrl + widget.previewImages[index].image)),
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
                        child: Text(LocalizationService.translate(widget.typeData.type)),
                      ),
                    ),
                    if(!isSaved && widget.ad.userId != Repo.profileDataModel!.result!.id)
                    IconButton.filled(
                      onPressed: () {
                        MainCubit.get(context).saveAd(widget.ad.id!);
                      },
                      icon: SvgPicture.asset(AssetsManager.saved, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                      style: IconButton.styleFrom(
                        backgroundColor: ColorsManager.white,
                      ),
                    ),
                    if(isSaved && widget.ad.userId != Repo.profileDataModel!.result!.id)
                    IconButton.filled(
                      onPressed: () => MainCubit.get(context).unSaveAd(widget.ad.id!),
                      icon: SvgPicture.asset(AssetsManager.savedFilled, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
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
                    count: widget.previewImages.length,
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
                Text(widget.ad.title!, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),),
                Text(widget.ad.description!, style: Theme.of(context).textTheme.titleMedium,),
                if(widget.typeData.type == 'Sale')
                Text('${widget.ad.price!} ${LocalizationService.translate(StringsManager.egp)}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold)),
                Text(DateFormat('dd - MM - yyyy').format(DateTime.parse(widget.ad.createdAt!)), style: Theme.of(context).textTheme.titleMedium,),
              ],
            ),
          )
        ],
      ),
    );
  }
}