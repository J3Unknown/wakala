import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/profile/presentation/view/widgets/default_address_list_element.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';

class SelectAddressDialog extends StatelessWidget {
  const SelectAddressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var addresses = Repo.profileDataModel!.result!.address;
    return AlertDialog(
      title: Text(LocalizationService.translate(StringsManager.selectAddress)),
      backgroundColor: ColorsManager.white,
      content: (addresses.isNotEmpty)?Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          addresses.length,
          (index) => InkWell(
            onTap: () => Navigator.pop(context, addresses[index]!),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppPaddings.p5),
              child: DefaultAddressListElement(address: addresses[index]!, canEdit: false,),
            )
          ),
        ),
      ):Column(
        children: [
          Text(LocalizationService.translate(StringsManager.noAddressesWarning)),
          TextButton(
            onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addAddress))),
            child: Row(
              children: [
                SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                Text(LocalizationService.translate(StringsManager.addAddress), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
