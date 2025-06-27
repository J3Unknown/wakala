import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/profile/data/add_address_arguments.dart';
import 'package:wakala/profile/presentation/view/widgets/default_address_list_element.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/repo.dart';

import '../../../utilities/resources/assets_manager.dart';
import '../../../utilities/resources/colors_manager.dart';
import '../../../utilities/resources/routes_manager.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class AddressesListScreen extends StatelessWidget {
  const AddressesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.addressList), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
        child: CustomScrollView(
          slivers: [
            SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
              itemCount: Repo.profileDataModel!.result!.address.length,
              itemBuilder: (context, index) => DefaultAddressListElement(address: Repo.profileDataModel!.result!.address[index]!,)
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addAddress, arguments: AddAddressArguments(isEdit: false)))),
                child: Row(
                  children: [
                    SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                    Text(LocalizationService.translate(StringsManager.addAddress), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),)
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
