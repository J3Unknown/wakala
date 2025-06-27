import 'package:wakala/auth/data/profile_data_model.dart';

class AddAddressArguments{
  Address? address;
  bool isEdit;
  AddAddressArguments({this.address, this.isEdit = false});
}