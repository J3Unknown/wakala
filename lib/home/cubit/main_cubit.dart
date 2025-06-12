import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/chat/presentation/view/screens/chats_list_screen.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/home/data/home_screen_data_model.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/home/presentation/view/screens/categories_screen.dart';
import 'package:wakala/home/presentation/view/screens/commercial_screen.dart';
import 'package:wakala/home/presentation/view/screens/home_screen.dart';
import 'package:wakala/home/presentation/view/screens/more_screen.dart';
import 'package:wakala/home/presentation/view/screens/post_screen.dart';
import 'package:wakala/notifications/presentation/view/notifications_screen.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';

class MainCubit extends Cubit<MainCubitStates>{
  MainCubit(): super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);
  //*Bottom Nav Bar
  int currentIndex = 0;
  Widget currentScreen = HomeScreen();
  //*Home Screen
  bool isNotificationsScreen = false;
  bool isChatsScreen = false;

  //*Category List
  bool isCategorySelected = false;
  int categoryIndex = -1;

  List<Widget> homeScreens = [
    HomeScreen(),
    CommercialScreen(),
    PostScreen(),
    CategoriesScreen(),
    MoreScreen(),
  ];

  void changeBottomNavBarIndex(index){
    currentIndex = index;
    currentScreen = homeScreens[index];
    isChatsScreen = false;
    isNotificationsScreen = false;
    emit(MainChangeBottomNavBarIndexState());
  }

  void navigateToNotifications(){
    currentScreen = NotificationsScreen();
    isChatsScreen = false;
    isNotificationsScreen = true;
    emit(MainChangeBottomNavBarIndexState());
  }

  void navigateToChats(){
    currentScreen = ChatsListScreen();
    isChatsScreen = true;
    isNotificationsScreen = false;
    emit(MainChangeBottomNavBarIndexState());
  }

  void changeCategorySelection(int newIndex){
      if(newIndex == categoryIndex){
        isCategorySelected = false;
        categoryIndex = -1;
      } else {
        isCategorySelected = true;
        categoryIndex = newIndex;
      }
      emit(MainToggleAndChangeCategorySelectionState());
  }

  //*create password screen
  bool isObscured = false;
  void changeEyeVisibility(){
    isObscured = !isObscured;
    emit(MainToggleEyeVisibilityState());
  }

  void getProfile(){
    emit(MainGetProfileLoadingState());
    if(AppConstants.isAuthenticated){
      DioHelper.getData(path: EndPoints.getAndDeleteProfile).then((value){
        Repo.profileDataModel = ProfileDataModel.fromJson(value.data);
        emit(MainGetProfileSuccessState());
      });
    }
  }

  ProfileDataModel? otherProfile;
  Future<void> getOtherProfile() async{
    emit(MainGetOtherProfileLoadingState());
    DioHelper.getData(path: EndPoints.getAndDeleteProfile); //TODO: Check for the other profiles end Point;
  }

  HomePageDataModel? homePageDataModel;
  void getHomeScreen(){
    emit(MainGetHomeScreenLoadingState());
    DioHelper.getData(path: EndPoints.home).then((value){
      log(value.data.toString());
      homePageDataModel = HomePageDataModel.fromJson(value.data);
      emit(MainGetHomeScreenSuccessState());
    });
  }

  CategoriesDataModel? categoriesDataModel;
  void getCategories(){
    emit(MainGetCategoriesLoadingState());
    DioHelper.getData(path: EndPoints.categories).then((value){
      categoriesDataModel = CategoriesDataModel.fromJson(value.data);
    });
  }

  void getSubCategories(){

  }

  CommercialAdDataModel? commercialAdDataModel;
  int currentCommercialAdsPage = 1;
  bool commercialAdsIsLoadingMore = false;
  bool commercialAdsHasMore = true;

  void getCommercialAds({bool loadMore = false}){
    if (loadMore) {
      if (!commercialAdsHasMore || commercialAdsIsLoadingMore) return;
      commercialAdsIsLoadingMore = true;
      currentCommercialAdsPage++;
      emit(MainGetCommercialAdLoadingMoreState());
    } else {
      currentCommercialAdsPage = 1;
      commercialAdsHasMore = true;
      emit(MainGetCommercialAdLoadingState());
    }

    final queryParams = {
      'page': currentCommercialAdsPage,
    };

    DioHelper.getData(
      path: EndPoints.getCommercialAd,
      query: queryParams,
    ).then((value) {
      final newData = CommercialAdDataModel.fromJson(value.data);

      if (loadMore) {
        commercialAdDataModel?.result?.commercialAdsItems?.addAll(newData.result?.commercialAdsItems ?? []);
      } else {
        commercialAdDataModel = newData;
      }

      commercialAdsHasMore = (newData.result?.pagination.currentPage ?? 0) < (newData.result?.pagination.lastPage ?? 0);

      commercialAdsIsLoadingMore = false;
      log(value.data.toString());
      emit(MainGetCommercialAdSuccessState());
    });
  }

  SpecificAdDataModel? specificAdDataModel;
  void getCommercialAdByID(int id){
    specificAdDataModel = null;
    emit(MainGetCommercialAdByIDLoadingState());
    DioHelper.getData(path: '${EndPoints.getCommercialAd}/$id').then((value){
      log(value.data.toString());
      specificAdDataModel = SpecificAdDataModel.fromJson(value.data);
      emit(MainGetCommercialAdByIDSuccessState(specificAdDataModel!));
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Response: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainGetCommercialAdByIDErrorState());
    });
  }

  Future<void> updateLang(String locale) async{
    emit(MainUpdateLangLoadingState());
    if(AppConstants.isAuthenticated){
      DioHelper.postData(
        url: EndPoints.updateLang,
        data: {
          'lang':locale
        },
      ).then((value){
        emit(MainUpdateLangSuccessState());
      }).catchError((e){
        if (e is DioException) {
          log("Dio Error: ${e.message}");
          log("Status Code: ${e.response?.statusCode}");
        } else {
          log("Non-Dio Error: $e");
        }
      });
    }
  }
  
  void createPassword(String password, String passwordConfirmation){
    emit(MainCreatePasswordSuccessState());
    DioHelper.postData(
      url: EndPoints.createPassword,
      data: {
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    ).then((value){
      emit(MainCreatePasswordSuccessState());
    });
  }

  Future<void> logOut() async{
    emit(MainLogOutLoadingState());
    DioHelper.getData(path: EndPoints.logout).then((value){
      emit(MainLogOutSuccessState());
    });
  }
}
