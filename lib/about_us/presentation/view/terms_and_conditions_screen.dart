import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../home/cubit/main_cubit.dart';
import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/assets_manager.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  void initState() {
    if(context.read<MainCubit>().aboutUsDataModel == null){
      context.read<MainCubit>().getAboutUs();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.termsAndConditions), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: MainCubit.get(context),
        builder: (context, state) => ConditionalBuilder(
          condition: MainCubit.get(context).aboutUsDataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.all(AppPaddings.p15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetsManager.appIcon, width: AppSizesDouble.s150,),
                SizedBox(height: AppSizesDouble.s10,),
                Text(LocalizationService.translate(StringsManager.termsAndConditions), style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizesDouble.s20),),
                SizedBox(height: AppSizesDouble.s10,),
                Text('${MainCubit.get(context).aboutUsDataModel!.result!.terms!}\n\n${MainCubit.get(context).aboutUsDataModel!.result!.privacy!}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
