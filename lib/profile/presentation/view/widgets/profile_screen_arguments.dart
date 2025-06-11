import 'package:wakala/auth/data/profile_data_model.dart';

class ProfileScreenArguments{
  bool isOthers;
  ProfileDataModel profileDataModel;
  ProfileScreenArguments({
    required this.profileDataModel,
    this.isOthers = false,
  });
}