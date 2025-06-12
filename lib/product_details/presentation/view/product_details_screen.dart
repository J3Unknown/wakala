import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/chat/presentation/view/widgets/default_user_card.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/product_details/presentation/view/widgets/DefaultProductDetailsHeaderSection.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
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

  @override
  void initState() {
    typeData = getProductType(null);
    context.read<MainCubit>().getCommercialAdByID(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SpecificAdDataModel? dataModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocalizationService.translate(StringsManager.productDetails)),
        actions: [
          IconButton(onPressed: (){}, icon: SvgPicture.asset(AssetsManager.share, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),))
        ],
      ),
      body: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state){
          if(state is MainGetCommercialAdByIDSuccessState){
            dataModel = state.specificAdDataModel;
          }
        },
        builder: (context, state) => ConditionalBuilder(
          condition: dataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppPaddings.p15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultProductDetailsHeaderSection(previewImages: dataModel!.result!.ad!.images!, typeData: typeData, ad: dataModel!.result!.ad!,),
                if(typeData.type == 'Auction')
                ExpandableList(
                  title: 'Auctions',
                  previewObject: [
                    Text('preview Object')
                  ],
                  fullContent: [
                    Text('full Content')
                  ]
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
                  title: 'Description',
                  previewObject: [
                    Text(dataModel!.result!.ad!.description!, maxLines: 1, overflow: TextOverflow.ellipsis,)
                  ],
                  fullContent: [
                    Text(dataModel!.result!.ad!.description!)
                  ]
                ),
                ExpandableList(
                  isExpandable: false,
                  title: 'Address',
                  previewObject: [
                    Text('User Address')
                  ],
                  fullContent: []
                ),
                if(dataModel!.result!.ad!.user!=null)
                ExpandableList(
                  isExpandable: false,
                  title: 'Advertiser',
                  previewObject: [
                    DefaultUserCard(
                      hasMargin: false,
                      hasUnderline: false,
                      user: dataModel!.result!.ad!.user!,
                    ),
                  ],
                  fullContent: []
                ),
                ExpandableList(
                  isExpandable: false,
                  title: 'Related Ads',
                  previewObject: [
                    HorizontalProductList(products: dataModel!.result!.relatedAds!,),
                  ],
                  fullContent: []
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
