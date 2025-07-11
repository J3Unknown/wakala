import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/presentation/view/widgets/bottom_nav_bar.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';


import '../../../utilities/resources/alerts.dart';
import '../../../utilities/resources/assets_manager.dart';
import '../../../utilities/resources/colors_manager.dart';
import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/values_manager.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final TextEditingController _searchController = TextEditingController();

  final DeBouncer _deBouncer = DeBouncer();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return Scaffold(
          appBar: cubit.currentIndex != AppSizes.s2?AppBar(
            title: shouldBeSearchBar(cubit)?
              CustomSearchBar(searchController: _searchController, onChange: () => _deBouncer.run((){})): //TODO: run the commercial products' search
              SvgPicture.asset(AssetsManager.appIcon,width: AppSizesDouble.s25, height: AppSizesDouble.s25, fit: BoxFit.contain,),
            actions: !shouldBeSearchBar(cubit)?[
              IconButton(
                onPressed: () {
                  if(AppConstants.isAuthenticated){
                    cubit.navigateToChats();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => LoginAlert()
                    );
                  }
                },
                icon: SvgPicture.asset(
                AssetsManager.chatsIcon,
                colorFilter: ColorFilter.mode(cubit.isChatsScreen? ColorsManager.primaryColor:ColorsManager.black, BlendMode.srcIn),
                )
              ),
              IconButton(
                onPressed: () {
                  if(AppConstants.isAuthenticated){
                    cubit.navigateToNotifications();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => LoginAlert()
                    );
                  }
                },
                icon: SvgPicture.asset(
                  AssetsManager.notificationsIcon,
                  colorFilter: ColorFilter.mode(cubit.isNotificationsScreen? ColorsManager.primaryColor:ColorsManager.black, BlendMode.srcIn)
                )
              ),
            ]:[],
          ):null,
          body: cubit.currentScreen,
          bottomNavigationBar: BottomNavBar(cubit: cubit),
        );
      },
    );
  }

  bool shouldBeSearchBar(MainCubit cubit){
    return cubit.currentIndex == AppSizes.s2 || cubit.currentIndex == AppSizes.s1?true:false;
  }
}
