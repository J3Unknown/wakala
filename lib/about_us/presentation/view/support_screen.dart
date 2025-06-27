import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../auth/presentation/view/widgets/DefaultAuthButton.dart';
import '../../../home/cubit/main_cubit.dart';
import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/assets_manager.dart';
import '../../../utilities/resources/colors_manager.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  @override
  void initState() {
    if(context.read<MainCubit>().aboutUsDataModel == null){
      context.read<MainCubit>().getAboutUs();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = MainCubit.get(context);
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
                FittedBox(child: Text(LocalizationService.translate(StringsManager.contactUs), style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizesDouble.s20),)),
                SizedBox(height: AppSizesDouble.s20,),
                if(cubit.aboutUsDataModel!.result!.whatsappNumber != null)
                DefaultAuthButton(
                  onPressed: () async{
                    Uri uri = Uri.parse(cubit.aboutUsDataModel!.result!.whatsappNumber!);

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      showToastMessage(msg: 'can not launch $uri', toastState: ToastState.error);
                    }
                  },
                  title: StringsManager.whatsapp,
                  icon: AssetsManager.whatsapp,
                  iconWidth: AppSizesDouble.s50,
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: ColorsManager.white,
                  hasBorder: false,
                ),
                SizedBox(height: AppSizesDouble.s10,),
                if(cubit.aboutUsDataModel!.result!.facebook != null)
                DefaultAuthButton(
                  onPressed: () async{
                    Uri uri = Uri.parse(cubit.aboutUsDataModel!.result!.facebook!);

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      showToastMessage(msg: 'can not launch $uri', toastState: ToastState.error);
                    }
                  },
                  title: StringsManager.facebook,
                  icon: AssetsManager.facebook,
                  iconColor: ColorsManager.white,
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: ColorsManager.white,
                  iconWidth: AppSizesDouble.s40,
                  hasBorder: false,
                ),
                SizedBox(height: AppSizesDouble.s10,),
                if(cubit.aboutUsDataModel!.result!.instagram != null)
                  DefaultAuthButton(
                    onPressed: () async{
                      Uri uri = Uri.parse(cubit.aboutUsDataModel!.result!.instagram!);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        showToastMessage(msg: 'can not launch $uri', toastState: ToastState.error);
                      }
                    },
                    title: StringsManager.instagram,
                    icon: AssetsManager.instagram,
                    backgroundColor: ColorsManager.primaryColor,
                    iconColor: ColorsManager.white,
                    foregroundColor: ColorsManager.white,
                    iconWidth: AppSizesDouble.s40,
                    hasBorder: false,
                  ),
                SizedBox(height: AppSizesDouble.s10,),
                if(cubit.aboutUsDataModel!.result!.youtube != null)
                  DefaultAuthButton(
                    onPressed: () async{
                      Uri uri = Uri.parse(cubit.aboutUsDataModel!.result!.youtube!);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        showToastMessage(msg: 'can not launch $uri', toastState: ToastState.error);
                      }
                    },
                    title: StringsManager.youtube,
                    icon: AssetsManager.youtube,
                    iconColor: ColorsManager.white,
                    iconWidth: AppSizesDouble.s40,
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: ColorsManager.white,
                    hasBorder: false,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
