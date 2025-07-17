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
  static const String getOtherProfile = 'profile/show';

  //*City And Regions
  static const String cities = 'cities';
  static const String regions = 'regions';
  static const String editMyRegion = 'edit_client_region';
  static const String deleteMyRegion = 'delete_client_region';
  static const String addMyRegion = 'add_client_region';

  //*attributes
  static const String attributes = 'attributes_by_category';

  //*recently viewed
  static const String recentlyViewed = 'recently-viewed-ads';

  //*Followings
  static const String followAndUnfollow = 'follow';
  static const String following = 'follow/following';

  //*home
  static const String home = 'home';

  //*ads
  static const String saveAd = 'ads';
  static const String hideAd = 'ads/hide';
  static const String getAuctionsForAd = 'auction/ad';
  static const String saveAdAuction = 'auction/store';

  //*chat
  static const String chat = 'chats';

  //*Save Ads
  static const String savedAds = 'saved-ads';

  //*Favorite Chats
  static const String favorites = 'favorite-ads';

  //*notifications
  static const String notifications = 'notifications';

  //*categories
  static const String categories = 'categories';
  static const String subCategories = 'get_subCategories';

  //*commercial
  static const String getCommercialAd = 'ads';
  static const String getMyAds = 'ads/my_ads/index';
  static const String getUserAds = 'ads/user';

  //*report
  static const String report = 'reports/store';
  static const String reportOptions = 'reports/reportOption';

}