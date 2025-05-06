import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/widgets/AuthSection.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p20),
        child: Column(
          children: [
            AuthSection(
              children: [
                Text(StringsManager.wikala, style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.grey),),
                Text(StringsManager.welcomeToWikala, style: Theme.of(context).textTheme.headlineMedium,),
              ]
            ),
            AuthSection(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${StringsManager.phoneNumber} *'),
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              ]
            ),
            AuthSection(
              children: [

              ]
            )
          ],
        ),
      ),
    );
  }
}
