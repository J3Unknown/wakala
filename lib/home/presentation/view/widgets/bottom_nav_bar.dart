import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class BottomNavBar extends StatelessWidget {
  final MainCubit cubit;
  const BottomNavBar({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: cubit.currentIndex,
      selectedFontSize: AppSizesDouble.s14,
      unselectedFontSize: AppSizesDouble.s14,
      selectedItemColor: cubit.isChatsScreen || cubit.isNotificationsScreen? ColorsManager.black: ColorsManager.primaryColor,
      onTap: (index) {
        if((index == AppSizes.s2 || index == AppSizes.s1) && !AppConstants.isAuthenticated){
          showDialog(context: context, builder: (context) => LoginAlert());
        } else {
          cubit.changeBottomNavBarIndex(index);
        }
      },
      items: [
        BottomNavigationBarItem(icon: SvgPicture.asset(AssetsManager.home, colorFilter: ColorFilter.mode( selectedIconColor(AppSizes.s0), BlendMode.srcIn),), label: LocalizationService.translate(StringsManager.home)),
        BottomNavigationBarItem(icon: SvgPicture.asset(AssetsManager.commercial, colorFilter: ColorFilter.mode(selectedIconColor(AppSizes.s1), BlendMode.srcIn)), label: LocalizationService.translate(StringsManager.commercial)),
        BottomNavigationBarItem(icon: SvgPicture.asset(AssetsManager.libraryAdd,colorFilter: ColorFilter.mode(selectedIconColor(AppSizes.s2), BlendMode.srcIn)), label: LocalizationService.translate(StringsManager.post)),
        BottomNavigationBarItem(icon: SvgPicture.asset(AssetsManager.categories, colorFilter: ColorFilter.mode(selectedIconColor(AppSizes.s3), BlendMode.srcIn)), label: LocalizationService.translate(StringsManager.categories)),
        BottomNavigationBarItem(icon: SvgPicture.asset(AssetsManager.more, colorFilter: ColorFilter.mode(selectedIconColor(AppSizes.s4), BlendMode.srcIn)), label: LocalizationService.translate(StringsManager.more)),
      ]
    );
  }

  Color selectedIconColor(int index){
    return cubit.currentIndex == index && !(cubit.isChatsScreen || cubit.isNotificationsScreen)? ColorsManager.primaryColor: ColorsManager.grey;
  }
}
