class EndPoints{
  //* Auth End Points
  static const String resetPassword = 'resetPassword';
  static const String sendOtp = 'send_otp_password';
  static const String login = 'login';
  static const String register = 'register';
  static const String socialLogin = 'login/redirect';
  static const String logout = 'logout';
  static const String sendOtpRegister = 'send_otp_register';

  //*About US
  static const String aboutUs = 'about_us';

  //*Profile
  static const String updateLang = 'edit_lang';
  static const String createPassword = 'create-password';
  static const String editProfile = 'edit_profile';
  static const String getAndDeleteProfile = 'profile';

  //*City And Regions
  static const String cities = 'cities';
  static const String regions = 'regions';
  static const String editMyRegion = 'edit_client_region';
  static const String deleteMyRegion = 'delete_client_region';
  static const String addMyRegion = 'select_main_address';
  static const String addMainAddress = 'select_main_address';

  //*attributes
  static const String attributes = 'attributes_by_category';

  //*Followings
  static const String followAndUnfollow = 'follow/67';
  static const String following = 'follow/following/68';
  static const String followers = 'follow/followers/69';

  //*home
  static const String home = 'home';

  //*adds
  static const String saveAdd = 'ads';

  //*chat
  static const String getChatsAndSendMessage = 'chats';
  static const String deleteChat = 'chats/2';

  //*Save Ads
  static const String savedAds = 'saved-ads';

  //*Favorite Chats
  static const String getAndAddFavorite = 'favorite-ads';
  static const String deleteFavorite = 'favorite-ads';

  //*notifications
  static const String notifications = 'favorite-ads';

  //*categories
  static const String categories = 'categories';
  static const String subCategories = 'get_sub_categories';

  //*commercial
  static const String getCommercialAd = 'ads';

}