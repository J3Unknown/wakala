import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:intl/intl.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/chat/presentation/view/widgets/default_user_card.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/product_details/data/auctions_data_model.dart';
import 'package:wakala/product_details/presentation/view/widgets/DefaultProductDetailsHeaderSection.dart';
import 'package:wakala/product_details/presentation/view/widgets/add_auction_alert.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.id});

  final int id;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  late final ProductTypeData typeData;
  SpecificAdDataModel? dataModel;
  bool isSaved = false;
  @override
  void initState(){
    context.read<MainCubit>().getCommercialAdByID(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocalizationService.translate(StringsManager.productDetails)),
        actions: [
          IconButton(
            onPressed: () => shareButton('${AppConstants.baseUrl + EndPoints.getCommercialAd}/${widget.id}', 'Check this out on Wikala!!'),
            icon: SvgPicture.asset(AssetsManager.share, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),)
          )
        ],
      ),
      body: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state){
          if(state is MainGetCommercialAdByIDSuccessState){
            dataModel = state.specificAdDataModel;
            log(dataModel!.result!.ad!.id.toString());
            PairOfIdAndName pair = getTypeById(dataModel!.result!.ad!.typeId!);
            typeData = getProductType(pair.name);
            if(typeData.type == 'Auction'){
              MainCubit.get(context).getAuctionsForAd(dataModel!.result!.ad!.id!);
            }
          }
        },
        builder: (context, state) => ConditionalBuilder(
          condition: dataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: AppPaddings.p15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultProductDetailsHeaderSection(previewImages: dataModel!.result!.ad!.images!, typeData: typeData, ad: dataModel!.result!.ad!,),
                      if(typeData.type == 'Auction')
                      ConditionalBuilder(
                        condition: MainCubit.get(context).auctionsDataModel != null && MainCubit.get(context).auctionsDataModel!.result.isNotEmpty && state is !MainGetAuctionsForAdLoadingState,
                        fallback: (context){
                          if(state is MainGetAuctionsForAdLoadingState){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return SizedBox();
                        },
                        builder: (context) => ExpandableList(
                          title: StringsManager.auction,
                          previewObject: [
                            DefaultAuctionCard(
                              auction: MainCubit.get(context).auctionsDataModel!.result.first,
                            )
                          ],
                          fullContent: [
                            ...List.generate(
                              MainCubit.get(context).auctionsDataModel!.result.length,
                              (index) => DefaultAuctionCard(
                                auction: MainCubit.get(context).auctionsDataModel!.result[index],
                              )
                            )
                          ]
                        )
                      ),
                      // ExpandableList(
                      //   title: 'Details',
                      //   previewObject: [
                      //     Text('preview Object'),
                      //   ],
                      //   fullContent: [
                      //     Text('full Content'),
                      //     Text('full Content'),
                      //     Text('full Content'),
                      //     Text('full Content'),
                      //   ]
                      // ),
                      ExpandableList(
                        title: StringsManager.description,
                        previewObject: [
                          Text(dataModel!.result!.ad!.description!, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
                        ],
                        fullContent: [
                          Text(dataModel!.result!.ad!.description!)
                        ]
                      ),
                      // ExpandableList(
                      //   isExpandable: false,
                      //   title: 'Address',
                      //   previewObject: [
                      //     dataModel!.result!.ad!.city
                      //   ],
                      //   fullContent: []
                      // ),
                      if(dataModel!.result!.ad!.user!=null)
                      ExpandableList(
                        isExpandable: false,
                        title: StringsManager.advertiser,
                        previewObject: [
                          DefaultUserCard(
                            hasMargin: false,
                            hasUnderline: false,
                            id: dataModel!.result!.ad!.user!.id,
                            name: dataModel!.result!.ad!.user!.name,
                            image: dataModel!.result!.ad!.user!.image,
                          ),
                        ],
                        fullContent: []
                      ),
                      ExpandableList(
                        isExpandable: false,
                        title: StringsManager.relatedAds,
                        previewObject: [
                          HorizontalProductList(products: dataModel!.result!.relatedAds!,),
                        ],
                        fullContent: []
                      ),
                    ],
                  ),
                ),
              ),
              if(typeData.type != 'Auction')
              Padding(
                padding: EdgeInsets.only(bottom: AppPaddings.p20, left: AppPaddings.p15, right: AppPaddings.p15),
                child: SizedBox(
                  height: AppSizesDouble.s60,
                  child: Row(
                    children: [
                      if(dataModel!.result!.ad!.contactMethod == 'chat')
                      Expanded(
                        child: DefaultAuthButton(
                          onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.chat, arguments: dataModel!.result!.ad!.user!.id))),
                          title: StringsManager.message,
                          icon: AssetsManager.chatsIcon,
                          iconColor: ColorsManager.white,
                          backgroundColor: ColorsManager.primaryColor,
                          foregroundColor: ColorsManager.white,
                          height: AppSizesDouble.s60,
                          hasBorder: false,
                        ),
                      ),
                      SizedBox(width: AppSizesDouble.s10,),
                      if(dataModel!.result!.ad!.contactMethod == 'phone')
                      Expanded(
                        child: DefaultAuthButton(
                          onPressed: () async => await FlutterPhoneDirectCaller.callNumber(dataModel!.result!.ad!.user!.phone!.toString()),
                          title: StringsManager.call,
                          icon: AssetsManager.call,
                          iconColor: ColorsManager.white,
                          backgroundColor: ColorsManager.primaryColor,
                          foregroundColor: ColorsManager.white,
                          height: AppSizesDouble.s60,
                          hasBorder: false,
                        )
                      )
                    ],
                  ),
                ),
              ),
              if(typeData.type == 'Auction')
              Padding(
                padding: EdgeInsets.only(bottom: AppPaddings.p20, left: AppPaddings.p15, right: AppPaddings.p15),
                child: SizedBox(
                  height: AppSizesDouble.s60,
                  width: double.infinity,
                  child: DefaultAuthButton(
                    onPressed: () async{
                      if(AppConstants.isAuthenticated) {
                        String? result;
                        result = await showDialog(context: context, builder: (context) => AddAuctionAlert(adId: dataModel!.result!.ad!.id!, lowestAuctionPrice: dataModel!.result!.ad!.price!,));
                        if(result == 'added'){
                          MainCubit.get(context).getAuctionsForAd(dataModel!.result!.ad!.id!);
                        }
                      } else {
                        showDialog(context: context, builder: (context) => LoginAlert());
                      }
                    },
                    title: StringsManager.addAuction,
                    icon: AssetsManager.auction,
                    iconColor: ColorsManager.white,
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: ColorsManager.white,
                    height: AppSizesDouble.s60,
                    hasBorder: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultAuctionCard extends StatelessWidget {
  const DefaultAuctionCard({
    super.key,
    required this.auction
  });

  final Auction auction;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: auction.user!.image != null? NetworkImage(AppConstants.baseImageUrl + MainCubit.get(context).auctionsDataModel!.result.first.user!.image!):svg_provider.Svg(AssetsManager.defaultAvatar),
        ),
        Text(auction.user!.name, style: Theme.of(context).textTheme.titleLarge,),
        Spacer(),
        Column(
          children: [
            Text(DateFormat('HH:mm').format(DateTime.parse(auction.createdAt!))),
            Text(auction.price!, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor),),
          ],
        )
      ],
    );
  }
}
