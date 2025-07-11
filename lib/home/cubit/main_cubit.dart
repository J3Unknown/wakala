import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wakala/about_us/data/about_us_data_model.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/chat/data/chats_data_model.dart';
import 'package:wakala/chat/presentation/view/screens/chats_list_screen.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/home/data/home_screen_data_model.dart';
import 'package:wakala/home/data/report_options_data_model.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';
import 'package:wakala/home/presentation/view/screens/categories_screen.dart';
import 'package:wakala/home/presentation/view/screens/commercial_screen.dart';
import 'package:wakala/home/presentation/view/screens/home_screen.dart';
import 'package:wakala/home/presentation/view/screens/more_screen.dart';
import 'package:wakala/home/presentation/view/screens/post_screen.dart';
import 'package:wakala/notifications/presentation/view/notifications_screen.dart';
import 'package:wakala/product_details/data/auctions_data_model.dart';
import 'package:wakala/profile/data/cities_and_regions_dataModel.dart';
import 'package:wakala/profile/data/followings_data_model.dart';
import 'package:wakala/saved/data/saved_ads_data_model.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/components.dart';
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
  Future<void> getOtherProfile(int profileId) async{
    emit(MainGetOtherProfileLoadingState());
    DioHelper.getData(path: '${EndPoints.getOtherProfile}/$profileId').then((value){
      otherProfile = ProfileDataModel.fromJson(value.data);
      emit(MainGetOtherProfileSuccessState());
    });
  }

  HomePageDataModel? homePageDataModel;
  void getHomeScreen(){
    emit(MainGetHomeScreenLoadingState());
    DioHelper.getData(path: EndPoints.home).then((value){
      homePageDataModel = HomePageDataModel.fromJson(value.data);
      emit(MainGetHomeScreenSuccessState());
    });
  }

  CategoriesDataModel? categoriesDataModel;
  void getCategories(){
    emit(MainGetCategoriesLoadingState());
    DioHelper.getData(path: EndPoints.categories).then((value){
      categoriesDataModel = CategoriesDataModel.fromJson(value.data);
      emit(MainGetCategoriesSuccessState());
    });
  }

  Categories? specificCategoriesDataModel;
  Future<void> getSubCategories(int categoryId) async{
    specificCategoriesDataModel = null;
    emit(MainGetSubCategoriesLoadingState());
    DioHelper.getData(
      path: EndPoints.subCategories,
      query: {
        'category_id':categoryId
      }
    ).then((value){
      specificCategoriesDataModel = Categories.fromJson(value.data['result']);
      emit(MainGetSubCategoriesSuccessState(specificCategoriesDataModel));
    });
  }

  CommercialAdDataModel? searchScreenAdsDataModel;
  int currentSearchCommercialAdsPage = 1;
  bool searchCommercialAdsIsLoadingMore = false;
  bool searchCommercialAdsHasMore = true;
  void getSearchCommercialAds({
    bool loadMore = false,
    int? categoryId,
    int? userId,
    String? search,
    int? minPrice,
    int? maxPrice,
    int? cityId,
    int? regionId,
    int? typeId,
  }){
    if (loadMore) {
      if (!commercialAdsHasMore || commercialAdsIsLoadingMore) return;
      commercialAdsIsLoadingMore = true;
      currentCommercialAdsPage++;
      emit(MainGetCommercialAdLoadingMoreState());
    } else {
      currentSearchCommercialAdsPage = 1;
      searchCommercialAdsHasMore = true;
      emit(MainGetCommercialAdLoadingState());
    }

    final queryParams = {
      'page': currentCommercialAdsPage,
      'category_id': categoryId,
      'user_id': userId,
      'search': search,
      'min_price': minPrice,
      'max_price': maxPrice,
      'city_id': cityId,
      'region_id': regionId,
      'type_id': typeId,
    };

    DioHelper.getData(
      path: EndPoints.getCommercialAd,
      query: queryParams,
    ).then((value) {
      final newData = CommercialAdDataModel.fromJson(value.data);

      if (loadMore) {
        searchScreenAdsDataModel?.result?.commercialAdsItems?.addAll(newData.result?.commercialAdsItems ?? []);
      } else {
        searchScreenAdsDataModel = newData;
      }

      searchCommercialAdsHasMore = (newData.result?.pagination.currentPage ?? 0) < (newData.result?.pagination.lastPage ?? 0);

      searchCommercialAdsIsLoadingMore = false;
      emit(MainGetCommercialAdSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Response: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainGetCommercialAdErrorState());
    });
  }

  //*For Home Screen Search By Category
  CommercialAdDataModel? homeScreenAdsDataModel;
  int currentHomeCommercialAdsPage = 1;
  bool homeCommercialAdsIsLoadingMore = false;
  bool homeCommercialAdsHasMore = true;
  void getHomeCommercialAds({
    bool loadMore = false,
    int? categoryId,
    int? userId,
    String? search,
    int? minPrice,
    int? maxPrice,
    int? cityId,
    int? regionId,
    int? typeId,
  }){
    if (loadMore) {
      if (!commercialAdsHasMore || commercialAdsIsLoadingMore) return;
      commercialAdsIsLoadingMore = true;
      currentCommercialAdsPage++;
      emit(MainGetCommercialAdLoadingMoreState());
    } else {
      currentHomeCommercialAdsPage = 1;
      homeCommercialAdsHasMore = true;
      emit(MainGetCommercialAdLoadingState());
    }

    final queryParams = {
      'page': currentCommercialAdsPage,
      'category_id': categoryId,
      'user_id': userId,
      'search': search,
      'min_price': minPrice,
      'max_price': maxPrice,
      'city_id': cityId,
      'region_id': regionId,
      'type_id': typeId,
    };

    DioHelper.getData(
      path: EndPoints.getCommercialAd,
      query: queryParams,
    ).then((value) {
      final newData = CommercialAdDataModel.fromJson(value.data);

      if (loadMore) {
        homeScreenAdsDataModel?.result?.commercialAdsItems?.addAll(newData.result?.commercialAdsItems ?? []);
      } else {
        homeScreenAdsDataModel = newData;
      }

      homeCommercialAdsHasMore = (newData.result?.pagination.currentPage ?? 0) < (newData.result?.pagination.lastPage ?? 0);

      homeCommercialAdsIsLoadingMore = false;
      emit(MainGetCommercialAdSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Response: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainGetCommercialAdErrorState());
    });
  }

  //*For Commercial Screen
  CommercialAdDataModel? commercialAdDataModel;
  int currentCommercialAdsPage = 1;
  bool commercialAdsIsLoadingMore = false;
  bool commercialAdsHasMore = true;
  void getCommercialAds({
    bool loadMore = false,
    int? categoryId,
    int? userId,
    String? search,
    int? minPrice,
    int? maxPrice,
    int? cityId,
    int? regionId,
    int? typeId,
  }){
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
      'category_id': categoryId,
      'user_id': userId,
      'search': search,
      'min_price': minPrice,
      'max_price': maxPrice,
      'city_id': cityId,
      'region_id': regionId,
      'type_id': typeId,
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
      emit(MainGetCommercialAdSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Response: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainGetCommercialAdErrorState());
    });
  }


  CommercialAdDataModel? myAdsDataModel;
  int currentMyAdsPage = 1;
  bool myAdsIsLoadingMore = false;
  bool myAdsHasMore = true;
  void getMyAds({bool loadMore = false}){
    if (loadMore) {
      if (!myAdsHasMore || myAdsIsLoadingMore) return;
      myAdsIsLoadingMore = true;
      currentMyAdsPage++;
      emit(MainGetMyAdsLoadingMoreState());
    } else {
      currentMyAdsPage = 1;
      myAdsHasMore = true;
      emit(MainGetMyAdsLoadingState());
    }

    final data = {
      'page': currentMyAdsPage,
    };

    DioHelper.getData(
      path: EndPoints.getMyAds,
      data: data,
    ).then((value) {
      final newData = CommercialAdDataModel.fromJson(value.data);

      if (loadMore) {
        commercialAdDataModel?.result?.commercialAdsItems?.addAll(newData.result?.commercialAdsItems ?? []);
      } else {
        commercialAdDataModel = newData;
      }

      commercialAdsHasMore = (newData.result?.pagination.currentPage ?? 0) < (newData.result?.pagination.lastPage ?? 0);

      commercialAdsIsLoadingMore = false;
      emit(MainGetMyAdsSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Response: ${e.response?.data}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainGetMyAdsErrorState());
    });
  }

  SpecificAdDataModel? specificAdDataModel;
  Future<void> getCommercialAdByID(int id) async{
    specificAdDataModel = null;
    emit(MainGetCommercialAdByIDLoadingState());
    DioHelper.getData(path: '${EndPoints.getCommercialAd}/$id').then((value){
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

  void editProfile({required String name, required String phone, File? image}){
    emit(MainEditAccountLoadingState());
    DioHelper.postData(
      url: EndPoints.createPassword,
      data: {
        'name': name,
        'phone': phone,
        'image':image,
      }
    ).then((value){
      emit(MainEditAccountSuccessState());
    });
  }
  
  void deleteAccount(context){
    emit(MainDeleteAccountLoadingState());
    DioHelper.deleteData(url: EndPoints.getAndDeleteProfile).then((value){
      navigateToAuthLayout(context);
    });
  }
  
  Future<void> logOut() async{
    emit(MainLogOutLoadingState());
    DioHelper.getData(path: EndPoints.logout).then((value){
      emit(MainLogOutSuccessState());
    });
  }

  CitiesAndRegionsDataModel? cities;
  void getCities(){
    emit(MainGetCitiesLoadingState());
    DioHelper.getData(
      path: EndPoints.cities
    ).then((value){
      cities = CitiesAndRegionsDataModel.fromJson(value.data);
      emit(MainGetCitiesSuccessState());
    });
  }

  CitiesAndRegionsDataModel? regions;
  void getRegions(int id){
    emit(MainGetRegionsLoadingState());
    DioHelper.getData(
      path: EndPoints.cities,
      query: {'id':id}
    ).then((value){
      regions = CitiesAndRegionsDataModel.fromJson(value.data);
      emit(MainGetRegionsSuccessState());
    });
  }

  void deleteAddress(int id){
    emit(MainDeleteAddressLoadingState());
    DioHelper.deleteData(
      url: EndPoints.deleteMyRegion,
      query: {'id':id}
    ).then((value){
      Repo.profileDataModel!.result!.address.removeWhere((e) => e!.id == id);
      emit(MainDeleteAddressSuccessState());
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  List<File> adImagesList = [];
  void pickAdsImages() async{
    emit(MainUploadAdImagesLoadingState());
    int remaining = 8 - adImagesList.length;
    final List<XFile> selectedImages = [];
    log(remaining.toString());
    if(remaining == 0) return;
    if(remaining == 1){
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if(image != null) selectedImages.add(image);
    }else if(remaining >= 1){
      final List<XFile>? images = await _imagePicker.pickMultiImage(limit: remaining);
      if(images != null) selectedImages.addAll(images);
    }
    if(selectedImages.isNotEmpty){
      final List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      for(var e in selectedImages){
        if(adImagesList.length == 8) {
          emit(MainUploadAdImagesSuccessState());
          break;
        }
        File image = File(e.path);
        int fileSizeInBytes = await image.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if(fileSizeInMB < 1 && allowedExtensions.contains(e.name.split('.').last.toLowerCase())){
          adImagesList.add(image);
        } else {
          if(fileSizeInMB < 1){
            showToastMessage(msg: 'The Image: ${e.name} is greater than 1 MB');
          } else {
            showToastMessage(msg: 'The Image: ${e.name} has an unsupported format!');
          }
        }
      }
      emit(MainUploadAdImagesSuccessState());
    }
  }

  AboutUsDataModel? aboutUsDataModel;
  void getAboutUs(){
    emit(MainGetAboutUsLoadingState());
    DioHelper.getData(path: EndPoints.aboutUs).then((value){
      aboutUsDataModel = AboutUsDataModel.fromJson(value.data);
      emit(MainGetAboutUsSuccessState());
    });
  }

  void saveAd(int id){
    emit(MainSaveAdLoadingState());
    DioHelper.postData(
      url: EndPoints.savedAds,
      data: {'id':id,}
    ).then((value){
      emit(MainSaveAdSuccessState());
    });
  }

  void unSaveAd(int id){
    emit(MainUnSaveAdLoadingState());
    DioHelper.postData(
      url: EndPoints.savedAds,
      data: {'id':id,}
    ).then((value){
      emit(MainUnSaveAdSuccessState());
    });
  }

  void postAd({
    required int categoryId,
    required int typeId,
    required String title,
    required String description,
    required String contactMethod,
    int negotiable = 0,
    startDate,
    endDate,
    required File mainImage,
    required List<File> images,
    required int cityId,
    required int regionId,
    price,
    lowestAuction,
    exchangeItem
  }){
    emit(MainPostAdLoadingState());
    DioHelper.postData(
      url: EndPoints.saveAd,
      data: {
        'category_id':categoryId,
        'type_id':typeId,
        'title':title,
        'description':description,
        'contact_method':contactMethod,
        'negotiable':negotiable,
        'start_date':startDate,
        'end_date':endDate,
        'mainImage':mainImage,
        'images':images,
        'city_id':cityId,
        'region_id':regionId,
        'price':price,
        'lowest_auction_price':lowestAuction,
        'change_product':exchangeItem
      }
    ).then((value){
      showToastMessage(msg: 'Ad Was Added Successfully', toastState: ToastState.success);
      emit(MainPostAdSuccessState());
      changeBottomNavBarIndex(0);
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Status Code: ${e.response?.statusCode}");
        log("data: ${e.response?.data}");
      } else {
        log("Non-Dio Error: $e");
      }
    });
  }

  //TODO: check on after checking on the error
  void addAddress({
    required int cityId,
    required int regionId,
    int? blockNo,
    String? street,
    int? buildingNo,
    int? floorNo,
    int? flatNo,
    String? notes,
  }){
    emit(MainAddAddressLoadingState());
    DioHelper.postData(
      url: EndPoints.addMyRegion,
      data: {
        'id':regionId,
        'region_parent':cityId,
        'block_no':blockNo,
        'street':street,
        'building_no':buildingNo,
        'floor_no':floorNo,
        'flat_no':flatNo,
        'notes':notes
      }
    ).then((value){
      log(value.data.toString());
      if(value.data['success']){
        Repo.profileDataModel!.result!.address.add(Address.fromJson(value.data));
        emit(MainAddAddressSuccessState());
      } else {
        emit(MainAddAddressErrorState());
      }
    });
  }

  void editAddress({
    required int regionId,
    required int id,
    int? blockNo,
    String? street,
    int? buildingNo,
    int? floorNo,
    int? flatNo,
    String? notes,
  }){
    emit(MainAddAddressLoadingState());
    DioHelper.postData(
      url: EndPoints.editMyRegion,
      data: {
        'id':id,
        'region_id':regionId,
        'block_no':blockNo,
        'street':street,
        'building_no':buildingNo,
        'floor_no':floorNo,
        'flat_no':flatNo,
        'notes':notes
      }
    ).then((value){
      log(value.data.toString());
      if(value.data['success']){
        Repo.profileDataModel!.result!.address.add(Address.fromJson(value.data));
        emit(MainAddAddressSuccessState());
      } else {
        emit(MainAddAddressErrorState());
      }
    });
  }
  
  SavedAdsDataModel? savedAdsDataModel;
  void getSavedAds(){
    emit(MainGetSavedAdsLoadingState());
    DioHelper.getData(path: EndPoints.savedAds).then((value){
      savedAdsDataModel = SavedAdsDataModel.fromJson(value.data);
      emit(MainGetSavedAdsSuccessState());
    });
  }

  AuctionsDataModel? auctionsDataModel;
  void getAuctionsForAd(int adId){
    emit(MainGetAuctionsForAdLoadingState());
    DioHelper.getData(
      path: '${EndPoints.getAuctionsForAd}/$adId'
    ).then((value){
      auctionsDataModel = value.data == []?AuctionsDataModel.fromJson(value.data):null;
      emit(MainGetAuctionsForAdSuccessState());
    });
  }

  void saveAuction(int adId, int price){
    emit(MainSaveAuctionLoadingState());
    DioHelper.postData(
      url: EndPoints.saveAdAuction,
      data: {
        'price':price,
        'ad_id':adId
      }
    ).then((value){
      if(value.data['success']){
        auctionsDataModel!.result.add(value.data['result']);
        emit(MainSaveAuctionSuccessState());
      } else {
        showToastMessage(
          msg: value.data['msg'],
          toastState: ToastState.error,
        );
        emit(MainSaveAuctionErrorState());
      }
    });
  }

  void follow(int userToFollowId){
    emit(MainFollowLoadingState());
    DioHelper.postData(
      url: '${EndPoints.followAndUnfollow}/$userToFollowId',
    ).then((value){
      log(value.data.toString());
      followingsDataModel.add(FollowingsDataModel.fromJson(value.data));
      emit(MainFollowSuccessState());
    });
  }

  void unfollow(int userToUnfollowId){
    emit(MainUnfollowLoadingState());
    DioHelper.deleteData(
      url: '${EndPoints.followAndUnfollow}/$userToUnfollowId',
    ).then((value){
      followingsDataModel.removeAt(userToUnfollowId);
      emit(MainUnfollowSuccessState());
    });
  }

  List<FollowingsDataModel> followingsDataModel = [];
  void getFollowing(int userToFollowId){
    if(AppConstants.isAuthenticated){
      emit(MainGetFollowingLoadingState());
      DioHelper.deleteData(
        url: '${EndPoints.followAndUnfollow}/$userToFollowId',
      ).then((value){
        if(value.data != null && value.data is List){
          followingsDataModel = (value.data as List).map((i) => FollowingsDataModel.fromJson(i)).toList();
        }
        emit(MainGetFollowingSuccessState());
      });
    }

  }

  ChatsDataModel? chatsDataModel;
  void getChats(){
    emit(MainGetChatsLoadingState());
    DioHelper.getData(
      path: EndPoints.chat
    ).then((value){
      chatsDataModel = ChatsDataModel.fromJson(value.data);
      emit(MainGetChatsSuccessState());
    });
  }

  PlatformFile? pickedFiles;
  void getChatAttachment() async{
    emit(MainPickChatFilesLoadingState());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if(result == null){
      emit(MainPickChatFilesErrorState());
      return;
    }
    pickedFiles = result.files.first;
    emit(MainPickChatFilesSuccessState());
  }

  void sendMessage(int receiverId, message, String messageType){
    emit(MainSendMessageLoadingState());
    DioHelper.postData(
      url: EndPoints.chat,
      data: {
        'receiver_id': receiverId,
        'message': message,
        'message_type': messageType,
      }
    ).then((value){
      pickedFiles = null;
      emit(MainSendMessageSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainSendMessageErrorState());
    });
  }

  void deleteMessage(int messageId){
    emit(MainDeleteMessageLoadingState());
    DioHelper.deleteData(
      url: EndPoints.chat,
      data: {
        'id': messageId,
      }
    ).then((value){
      emit(MainDeleteMessageSuccessState());
    }).catchError((e){
      if (e is DioException) {
        log("Dio Error: ${e.message}");
        log("Status Code: ${e.response?.statusCode}");
      } else {
        log("Non-Dio Error: $e");
      }
      emit(MainDeleteMessageErrorState());
    });
  }

  void addToRecentlyViewed(int id){
    emit(MainAddToRecentlyViewedLoadingState());
    // DioHelper.postData(url: EndPoints.)
  }

  void hideAd(int adId){
    emit(MainHideAdLoadingState());
    DioHelper.postData(url:
      EndPoints.hideAd,
      data: {'ad_id':adId}
    ).then((value){
      emit(MainHideAdSuccessState());
    });
  }

  ReportOptionsDataModel? reportOptionsDataModel;
  void getReports(){
    emit(MainGetReportLoadingState());
    DioHelper.getData(
      path: EndPoints.reportOptions
    ).then((value){
      reportOptionsDataModel = ReportOptionsDataModel.fromJson(value.data);
      emit(MainGetReportSuccessState());
    });
  }

  void report({required String reportType, required int reportedId, required int option, String? notes}){
    emit(MainReportLoadingState());
    DioHelper.postData(
      url: EndPoints.report,
      data: {
        'reportable_id':reportedId,
        'reportable_type': reportType,
        'report_option_id': option,
        'additional_notes': notes
      }
    ).then((value){
      showToastMessage(
        msg: 'Report was Successfully Sent!',
        toastState: ToastState.success
      );
      emit(MainReportSuccessState());
    });
  }
}
