import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/profile/data/add_address_arguments.dart';
import 'package:wakala/profile/presentation/view/widgets/delete_address_dialog.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class DefaultAddressListElement extends StatelessWidget {
  const DefaultAddressListElement({super.key, this.canEdit = true, required this.address});
  final Address address;
  final bool canEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s10),
      width: double.infinity,
      height: AppSizesDouble.s50,
      decoration: BoxDecoration(
        color: ColorsManager.loginButtonBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizesDouble.s8),
        border: Border.all(color: ColorsManager.grey2)
      ),
      child: Row(
        children: [
          Expanded(child: Text('${address.regionParent!.name??''} ${address.region!.name??''} ${address.blockNo??''} ${address.street??''}', maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),),
          if(canEdit)
          IconButton(
            onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addAddress, arguments: AddAddressArguments(address: address, isEdit: true)))),
            icon: SvgPicture.asset(
              AssetsManager.edit,
              colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),
            )
          ),
          if(canEdit)
          IconButton(
            onPressed: () => showDialog(context: context, builder: (context) => DeleteAddressDialog(address: address,)),
            icon: SvgPicture.asset(
              AssetsManager.trash,
              colorFilter: ColorFilter.mode(ColorsManager.red, BlendMode.srcIn),
            )
          )
        ],
      ),
    );
  }
}
