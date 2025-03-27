import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';

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
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              selectedLabelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              selectedItemColor: Colors.blue,
              unselectedLabelStyle: TextStyle(color: Colors.black),
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 14,
              selectedIconTheme: IconThemeData(
                size: 30
              ),
              onTap: (newIndex){
                cubit.changeBottomSheetIndex(newIndex);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.stars_rounded,), label: 'Commercial'),
                BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined,), label: 'Post'),
                BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined,), label: 'Categories'),
                BottomNavigationBarItem(icon: Icon(Icons.view_list_rounded,), label: 'more'),
              ]
            ),
          );
        },
      ),
    );
  }
}
