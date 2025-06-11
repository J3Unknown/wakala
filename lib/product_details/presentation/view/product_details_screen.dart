import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/chat/presentation/view/widgets/default_user_card.dart';
import 'package:wakala/product_details/presentation/view/widgets/DefaultProductDetailsHeaderSection.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.typeData});
  final ProductTypeData typeData;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocalizationService.translate(StringsManager.productDetails)),
        actions: [
          IconButton(onPressed: (){}, icon: SvgPicture.asset(AssetsManager.share, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: AppPaddings.p15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultProductDetailsHeaderSection(previewImages: previewImages, widget: widget),
            if(widget.typeData.type == 'Auction')
            ExpandableList(
              title: 'Auctions',
              previewObject: [
                Text('preview Object')
              ],
              fullContent: [
                Text('full Content')
              ]
            ),
            ExpandableList(
              title: 'Details',
              previewObject: [
                Text('preview Object'),
              ],
              fullContent: [
                Text('full Content'),
                Text('full Content'),
                Text('full Content'),
                Text('full Content'),
              ]
            ),
            ExpandableList(
              title: 'Description',
              previewObject: [
                Text('preview Object')
              ],
              fullContent: [
                Text('full Content'),
                Text('full Content'),
                Text('full Content'),
                Text('full Content'),
              ]
            ),
            ExpandableList(
              isExpandable: false,
              title: 'Address',
              previewObject: [
                Text('Address')
              ],
              fullContent: []
            ),
            ExpandableList(
              isExpandable: false,
              title: 'Advertiser',
              previewObject: [
                DefaultUserCard(
                  hasMargin: false,
                  hasUnderline: false,
                ),
              ],
              fullContent: []
            ),
            ExpandableList(
              isExpandable: false,
              title: 'Related Ads',
              previewObject: [
                HorizontalProductList(),
              ],
              fullContent: []
            ),
          ],
        ),
      ),
    );
  }
}
