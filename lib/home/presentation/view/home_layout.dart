import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/presentation/view/widgets/bottom_nav_bar.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state){},
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
          return Scaffold(
            appBar: cubit.appBars[cubit.currentIndex],
            body: cubit.homeScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavBar(cubit: cubit),
          );
        },
      ),
    );
  }
}
