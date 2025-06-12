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

class MainGetCommercialAdByIDLoadingState extends MainCubitStates{}

class MainGetCommercialAdByIDSuccessState extends MainCubitStates{
  final SpecificAdDataModel specificAdDataModel;
  MainGetCommercialAdByIDSuccessState(this.specificAdDataModel);

}

class MainGetCommercialAdByIDErrorState extends MainCubitStates{}

class MainLogOutLoadingState extends MainCubitStates{}

class MainLogOutSuccessState extends MainCubitStates{}

class MainLogOutErrorState extends MainCubitStates{}

class MainCreatePasswordLoadingState extends MainCubitStates{}

class MainCreatePasswordSuccessState extends MainCubitStates{}

class MainCreatePasswordErrorState extends MainCubitStates{}

