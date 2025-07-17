import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/chat/data/chat_screen_arguments.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';

import '../../../chat/data/chats_data_model.dart';
import '../../../home/cubit/main_cubit.dart';
import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/alerts.dart';
import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/routes_manager.dart';
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
  SpecificAdDataModel? _specificAdDataModel;
  bool isSaved = false;
  @override
  void initState() {
    MainCubit.get(context).getCommercialAdByID(widget.id);
    super.initState();
  }

 _checkIfSaved(){
    isSaved = MainCubit.get(context).savedAdsDataModel!.result!.any((e) {
      return e.adId == _specificAdDataModel!.result!.ad!.id;
    });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(IconsManager.closeIcon)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.commercialAdDetails), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {
          if(state is MainGetCommercialAdByIDSuccessState){
            _specificAdDataModel = state.specificAdDataModel;
            if(MainCubit.get(context).savedAdsDataModel != null){
              _checkIfSaved();
            } else {
              MainCubit.get(context).getSavedAds();
            }
          }

          if(state is MainGetSavedAdsSuccessState || state is MainSaveAdSuccessState || state is MainUnSaveAdSuccessState){
            _checkIfSaved();
          }
        },
        builder: (context, state) => ConditionalBuilder(
          condition: _specificAdDataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) => CustomScrollView(
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
                        children: List.generate(_specificAdDataModel!.result!.ad!.images!.length, (index) => Image.network(AppConstants.baseImageUrl + _specificAdDataModel!.result!.ad!.images![index].image)),
                      ),
                      Positioned(
                        bottom: AppSizesDouble.s40,
                        right: AppSizesDouble.s0,
                        left: AppSizesDouble.s0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: _specificAdDataModel!.result!.ad!.images!.length,
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
                      onPressed: (){
                        if(AppConstants.isAuthenticated){
                          showDialog(
                            context: context,
                            builder: (context) => ReportAlert(
                              reportType: KeysManager.ad,
                              reportedId: _specificAdDataModel!.result!.ad!.id.toString()
                            )
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => LoginAlert()
                          );
                        }
                      },
                      imagePath: AssetsManager.report,
                    ),
                    DefaultTitledIconButton(
                      title: StringsManager.hide,
                      onPressed: (){
                        if(AppConstants.isAuthenticated){
                          MainCubit.get(context).hideAd(_specificAdDataModel!.result!.ad!.id!);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => LoginAlert()
                          );
                        }
                      },
                      imagePath: AssetsManager.hide,
                    ),
                    !isSaved?
                    DefaultTitledIconButton(
                      title: StringsManager.save,
                      onPressed: () {
                        if(AppConstants.isAuthenticated){
                          MainCubit.get(context).saveAd(_specificAdDataModel!.result!.ad!.id!);
                        } else{
                          showDialog(
                            context: context,
                            builder: (context) => LoginAlert()
                          );
                        }
                      },
                      imagePath: AssetsManager.saved,
                    ):
                    DefaultTitledIconButton(
                      title: StringsManager.unSave,
                      onPressed: () => MainCubit.get(context).unSaveAd(_specificAdDataModel!.result!.ad!.id!),
                      imagePath: AssetsManager.savedFilled,
                    ),
                    DefaultTitledIconButton(
                      title: StringsManager.share,
                      onPressed: () => shareAd(AppConstants.baseImageUrl + _specificAdDataModel!.result!.ad!.mainImage!, _specificAdDataModel!.result!.ad!.title!, _specificAdDataModel!.result!.ad!.price!, _specificAdDataModel!.result!.ad!.description!),
                      imagePath: AssetsManager.share,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: ExpandableList(
                  title: StringsManager.description,
                  previewObject: [Text(_specificAdDataModel!.result!.ad!.description!, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)],
                  fullContent: [Text(_specificAdDataModel!.result!.ad!.description!)]
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
                          onPressed: () {
                            if(AppConstants.isAuthenticated){
                              Chat? chat;
                              if(MainCubit.get(context).chatsDataModel != null && MainCubit.get(context).chatsDataModel!.result!.chats.isNotEmpty){
                                for (var e in MainCubit.get(context).chatsDataModel!.result!.chats) {
                                  if(e.receiver!.id == _specificAdDataModel!.result!.ad!.user!.id){
                                    chat = e;
                                    break;
                                  }
                                }
                              }
                              Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.chat, arguments: ChatScreenArgument(_specificAdDataModel!.result!.ad!.user!.id, _specificAdDataModel!.result!.ad!.user!.name, _specificAdDataModel!.result!.ad!.user!.image, chat))));
                            } else {
                              showDialog(context: context, builder: (context) => LoginAlert());
                            }
                          },
                          title: StringsManager.message,
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
                          onPressed: () async {
                            if(AppConstants.isAuthenticated){
                              await FlutterPhoneDirectCaller.callNumber(_specificAdDataModel!.result!.ad!.user!.phone!.toString());
                            } else {
                              showDialog(context: context, builder: (context) => LoginAlert());
                            }
                          },
                          title: StringsManager.call,
                          height: AppSizesDouble.s60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: AppSizesDouble.s10,)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
                sliver: SliverGrid.builder(
                  itemCount: _specificAdDataModel!.result!.relatedAds!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSizes.s2,
                    crossAxisSpacing: AppSizesDouble.s10,
                    mainAxisSpacing: AppSizesDouble.s10,
                    childAspectRatio: AppSizesDouble.s0_8,
                  ),
                  itemBuilder: (context, index) {
                    return DefaultCommercialGridItem(item: _specificAdDataModel!.result!.relatedAds![index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

