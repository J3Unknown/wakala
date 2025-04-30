import 'package:flutter/material.dart';
import 'package:wakala/home/cubit/main_cubit.dart';

class BottomNavBar extends StatelessWidget {
  late MainCubit cubit;
  BottomNavBar({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
