import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';

import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

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
            child: Text(LocalizationService.translate(StringsManager.aboutUs), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: BlocBuilder(
        bloc: MainCubit.get(context),
        builder: (context, state) => ConditionalBuilder(
          condition: MainCubit.get(context).aboutUsDataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) =>  SingleChildScrollView(
            padding: EdgeInsets.all(AppPaddings.p15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetsManager.appIcon, width: AppSizesDouble.s150,),
                SizedBox(height: AppSizesDouble.s10,),
                Text(LocalizationService.translate(StringsManager.aboutUs), style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizesDouble.s20),),
                SizedBox(height: AppSizesDouble.s10,),
                Text(MainCubit.get(context).aboutUsDataModel!.result!.description!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
