import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/home/data/specific_ad_data_model.dart';

abstract class MainCubitStates{}

class MainInitialState extends MainCubitStates{}

class MainChangeBottomNavBarIndexState extends MainCubitStates{}

class MainChangeLocaleState extends MainCubitStates{}

class MainToggleAndChangeCategorySelectionState extends MainCubitStates{}

class MainToggleEyeVisibilityState extends MainCubitStates{}

class MainGetProfileLoadingState extends MainCubitStates{}

class MainGetProfileSuccessState extends MainCubitStates{}

class MainGetProfileErrorState extends MainCubitStates{}

class MainGetOtherProfileLoadingState extends MainCubitStates{}

class MainGetOtherProfileSuccessState extends MainCubitStates{}

class MainGetOtherProfileErrorState extends MainCubitStates{}

class MainUpdateLangLoadingState extends MainCubitStates{}

class MainUpdateLangSuccessState extends MainCubitStates{}

class MainGetHomeScreenLoadingState extends MainCubitStates{}

class MainGetHomeScreenSuccessState extends MainCubitStates{}

class MainGetHomeScreenErrorState extends MainCubitStates{}

class MainGetCategoriesLoadingState extends MainCubitStates{}

class MainGetCategoriesSuccessState extends MainCubitStates{}

class MainGetCategoriesErrorState extends MainCubitStates{}

class MainGetCommercialAdLoadingState extends MainCubitStates{}

class MainGetCommercialAdLoadingMoreState extends MainCubitStates{}

class MainGetCommercialAdSuccessState extends MainCubitStates{}

class MainGetCommercialAdErrorState extends MainCubitStates{}

class MainGetMyAdsLoadingState extends MainCubitStates{}

class MainGetMyAdsLoadingMoreState extends MainCubitStates{}

class MainGetMyAdsSuccessState extends MainCubitStates{}

class MainGetMyAdsErrorState extends MainCubitStates{}

class MainGetCommercialAdByIDLoadingState extends MainCubitStates{}

class MainGetCommercialAdByIDSuccessState extends MainCubitStates{
  final SpecificAdDataModel specificAdDataModel;
  MainGetCommercialAdByIDSuccessState(this.specificAdDataModel);

}

class MainGetCommercialAdByIDErrorState extends MainCubitStates{}

class MainLogOutLoadingState extends MainCubitStates{}

class MainLogOutSuccessState extends MainCubitStates{}

class MainLogOutErrorState extends MainCubitStates{}

class MainGetSubCategoriesLoadingState extends MainCubitStates{}

class MainGetSubCategoriesSuccessState extends MainCubitStates{
  final Categories? specificCategoriesDataModel;

  MainGetSubCategoriesSuccessState(this.specificCategoriesDataModel);
}

class MainGetSubCategoriesErrorState extends MainCubitStates{}

class MainCreatePasswordLoadingState extends MainCubitStates{}

class MainCreatePasswordSuccessState extends MainCubitStates{}

class MainCreatePasswordErrorState extends MainCubitStates{}

class MainEditAccountLoadingState extends MainCubitStates{}

class MainEditAccountSuccessState extends MainCubitStates{}

class MainEditAccountErrorState extends MainCubitStates{}


class MainDeleteAccountLoadingState extends MainCubitStates{}

class MainDeleteAccountSuccessState extends MainCubitStates{}

class MainDeleteAccountErrorState extends MainCubitStates{}

class MainGetCitiesLoadingState extends MainCubitStates{}

class MainGetCitiesSuccessState extends MainCubitStates{}

class MainGetCitiesErrorState extends MainCubitStates{}

class MainGetRegionsLoadingState extends MainCubitStates{}

class MainGetRegionsSuccessState extends MainCubitStates{}

class MainGetRegionsErrorState extends MainCubitStates{}

class MainUploadAdImagesLoadingState extends MainCubitStates{}

class MainUploadAdImagesSuccessState extends MainCubitStates{}

class MainUploadAdImagesErrorState extends MainCubitStates{}

class MainGetAboutUsLoadingState extends MainCubitStates{}

class MainGetAboutUsSuccessState extends MainCubitStates{}

class MainGetAboutUsErrorState extends MainCubitStates{}

class MainSaveAdLoadingState extends MainCubitStates{}

class MainSaveAdSuccessState extends MainCubitStates{}

class MainSaveAdErrorState extends MainCubitStates{}

class MainGetSavedAdsLoadingState extends MainCubitStates{}

class MainUnSaveAdLoadingState extends MainCubitStates{}

class MainUnSaveAdSuccessState extends MainCubitStates{}

class MainUnSaveAdErrorState extends MainCubitStates{}

class MainGetSavedAdsSuccessState extends MainCubitStates{}

class MainGetSavedAdsErrorState extends MainCubitStates{}

class MainGetAuctionsForAdLoadingState extends MainCubitStates{}

class MainGetAuctionsForAdSuccessState extends MainCubitStates{}

class MainGetAuctionsForAdErrorState extends MainCubitStates{}

class MainSaveAuctionLoadingState extends MainCubitStates{}

class MainSaveAuctionSuccessState extends MainCubitStates{}

class MainSaveAuctionErrorState extends MainCubitStates{}

class MainFollowLoadingState extends MainCubitStates{}

class MainFollowSuccessState extends MainCubitStates{}

class MainFollowErrorState extends MainCubitStates{}

class MainUnfollowLoadingState extends MainCubitStates{}

class MainUnfollowSuccessState extends MainCubitStates{}

class MainUnfollowErrorState extends MainCubitStates{}

class MainGetFollowingLoadingState extends MainCubitStates{}

class MainGetFollowingSuccessState extends MainCubitStates{}

class MainGetFollowingErrorState extends MainCubitStates{}

class MainGetChatsLoadingState extends MainCubitStates{}

class MainGetChatsSuccessState extends MainCubitStates{}

class MainGetChatsErrorState extends MainCubitStates{}

class MainSendMessageLoadingState extends MainCubitStates{}

class MainSendMessageSuccessState extends MainCubitStates{}

class MainSendMessageErrorState extends MainCubitStates{}

class MainDeleteMessageLoadingState extends MainCubitStates{}

class MainDeleteMessageSuccessState extends MainCubitStates{}

class MainDeleteMessageErrorState extends MainCubitStates{}

class MainPickChatFilesLoadingState extends MainCubitStates{}

class MainPickChatFilesSuccessState extends MainCubitStates{}

class MainPickChatFilesErrorState extends MainCubitStates{}

class MainAddToRecentlyViewedLoadingState extends MainCubitStates{}

class MainAddToRecentlyViewedSuccessState extends MainCubitStates{}

class MainAddToRecentlyViewedErrorState extends MainCubitStates{}

class MainDeleteAddressLoadingState extends MainCubitStates{}

class MainDeleteAddressSuccessState extends MainCubitStates{}

class MainDeleteAddressErrorState extends MainCubitStates{}

class MainAddAddressLoadingState extends MainCubitStates{}

class MainAddAddressSuccessState extends MainCubitStates{}

class MainAddAddressErrorState extends MainCubitStates{}

class MainPostAdLoadingState extends MainCubitStates{}

class MainPostAdSuccessState extends MainCubitStates{}

class MainPostAdErrorState extends MainCubitStates{}

class MainHideAdLoadingState extends MainCubitStates{}

class MainHideAdSuccessState extends MainCubitStates{}

class MainHideAdErrorState extends MainCubitStates{}

class MainReportLoadingState extends MainCubitStates{}

class MainReportSuccessState extends MainCubitStates{}

class MainReportErrorState extends MainCubitStates{}

class MainGetReportLoadingState extends MainCubitStates{}

class MainGetReportSuccessState extends MainCubitStates{}

class MainGetReportErrorState extends MainCubitStates{}

