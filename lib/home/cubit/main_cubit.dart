import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/chat/presentation/view/screens/chats_list_screen.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/presentation/view/screens/categories_screen.dart';
import 'package:wakala/home/presentation/view/screens/commercial_screen.dart';
import 'package:wakala/home/presentation/view/screens/home_screen.dart';
import 'package:wakala/home/presentation/view/screens/more_screen.dart';
import 'package:wakala/home/presentation/view/screens/post_screen.dart';
import 'package:wakala/notifications/presentation/view/notifications_screen.dart';

class MainCubit extends Cubit<MainCubitStates>{
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  Widget currentScreen = HomeScreen();
  bool isNotificationsScreen = false;
  bool isChatsScreen = false;

  List<Widget> homeScreens = [
    HomeScreen(),
    CommercialScreen(),
    PostScreen(),
    CategoriesScreen(),
    MoreScreen(),
  ];

  changeBottomNavBarIndex(index){
    currentIndex = index;
    currentScreen = homeScreens[index];
    isChatsScreen = false;
    isNotificationsScreen = false;
    emit(MainChangeBottomNavBarIndexState());
  }

  navigateToNotifications(){
    currentScreen = NotificationsScreen();
    isChatsScreen = false;
    isNotificationsScreen = true;
    emit(MainChangeBottomNavBarIndexState());
  }

  navigateToPost(){
    currentScreen = PostScreen();
    isChatsScreen = false;
    isNotificationsScreen = false;
    emit(MainChangeBottomNavBarIndexState());
  }

  navigateToChats(){
    currentScreen = ChatsListScreen();
    isChatsScreen = true;
    isNotificationsScreen = false;
    emit(MainChangeBottomNavBarIndexState());
  }

}