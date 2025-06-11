import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({super.key});

  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.addressInformation), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s20),
        child: Column(
          children: [
            DefaultTextInputField(
              controller: _addressNameController,
              obscured: false,
              hintText: 'Address Name',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultTextInputField(
              controller: _countryController,
              obscured: false,
              hintText: 'Country',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultTextInputField(
              controller: _cityController,
              obscured: false,
              hintText: 'City & Area',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultTextInputField(
              controller: _addressOneController,
              obscured: false,
              hintText: 'Address Line 1',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultTextInputField(
              controller: _addressTwoController,
              obscured: false,
              hintText: 'Address Line 2',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultTextInputField(
              controller: _noteController,
              obscured: false,
              maxLines: 5,
              hintText: 'Notes',
              borderColor: ColorsManager.grey3,
              isOutlined: true,
            ),
            SizedBox(height: AppSizesDouble.s10,),
            DefaultAuthButton(
              onPressed: (){},
              title: 'Save Address',
              hasBorder: false,
              backgroundColor: ColorsManager.primaryColor,
              foregroundColor: ColorsManager.white,
              height: AppSizesDouble.s60,
            )
          ],
        ),
      ),
    );
  }
}
