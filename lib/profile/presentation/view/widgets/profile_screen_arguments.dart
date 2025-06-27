import 'package:wakala/auth/data/profile_data_model.dart';

class ProfileScreenArguments{
  bool isOthers;
  ProfileDataModel? profileDataModel;
  int? id;
  ProfileScreenArguments({
    this.profileDataModel,
    this.isOthers = false,
    this.id
  });
}