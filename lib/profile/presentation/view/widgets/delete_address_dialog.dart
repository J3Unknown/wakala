import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../auth/data/profile_data_model.dart';
import '../../../../utilities/resources/colors_manager.dart';

class DeleteAddressDialog extends StatelessWidget {
  const DeleteAddressDialog({super.key, required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.white,
      title: Text(LocalizationService.translate(StringsManager.deleteAddress), textAlign: TextAlign.center,),
      alignment: Alignment.center,
      contentPadding: EdgeInsets.all(AppPaddings.p10),
      actions: [
        DefaultAuthButton(
          onPressed: () => Navigator.of(context).pop(),
          title: LocalizationService.translate(StringsManager.cancel),
        ),
        SizedBox(height: AppSizesDouble.s10,),
        DefaultAuthButton(
          backgroundColor: ColorsManager.deepRed,
          foregroundColor: ColorsManager.white,
          hasBorder: false,
          onPressed: () {
            MainCubit.get(context).deleteAddress(address.id!);
            Navigator.of(context).pop();
          },
          title: LocalizationService.translate(StringsManager.confirm),
        ),
      ],
      content: Text('${StringsManager.deleteAddressWarning}\n\n"${address.regionParent!.name??''} ${address.region!.name??''} ${address.blockNo??''} ${address.street}"\n', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
    );
  }
}
