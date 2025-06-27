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

class MainGetAuctionsForAdLoadingState extends MainCubitStates{}

class MainGetAuctionsForAdSuccessState extends MainCubitStates{}

class MainGetAuctionsForAdErrorState extends MainCubitStates{}

class MainSaveAuctionLoadingState extends MainCubitStates{}

class MainSaveAuctionSuccessState extends MainCubitStates{}

class MainSaveAuctionErrorState extends MainCubitStates{}

