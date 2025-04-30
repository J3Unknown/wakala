import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/presentation/view/screens/categories_screen.dart';
import 'package:wakala/home/presentation/view/screens/commercial_screen.dart';
import 'package:wakala/home/presentation/view/screens/home_screen.dart';
import 'package:wakala/home/presentation/view/screens/more_screen.dart';
import 'package:wakala/home/presentation/view/screens/post_screen.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';

class MainCubit extends Cubit<MainCubitStates>{
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> homeScreens = [
    HomeScreen(),
    CommercialScreen(),
    PostScreen(),
    CategoriesScreen(),
    MoreScreen()
  ];

  //TODO: These are only place holders values till we change it with its proper values
  List<PreferredSizeWidget> appBars = [
    appBar(
      actions: [
        IconButton(onPressed: (){}, icon: Icon(IconsManager.chatIcon)),
        IconButton(onPressed: (){}, icon: Icon(IconsManager.notificationIcon)),
      ]
    ),
    appBar(
      actions: [
        IconButton(onPressed: (){}, icon: Icon(IconsManager.chatIcon)),
        IconButton(onPressed: (){}, icon: Icon(IconsManager.notificationIcon)),
      ],
    ),
    appBar(),
    appBar(
      actions: [
        IconButton(onPressed: (){}, icon: Icon(IconsManager.chatIcon)),
        IconButton(onPressed: (){}, icon: Icon(IconsManager.notificationIcon)),
      ]
    ),
    appBar(
      actions:[
        IconButton(onPressed: (){}, icon: Icon(IconsManager.chatIcon)),
        IconButton(onPressed: (){}, icon: Icon(IconsManager.notificationIcon)),
      ]
    ),
  ];

  changeBottomSheetIndex(newIndex){
    currentIndex = newIndex;
    emit(MainChangeBottomNavBarIndexState());
  }
}