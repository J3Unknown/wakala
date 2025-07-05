import 'package:wakala/home/data/commercial_ad_data_model.dart';

class ProfileDataModel {
  late bool success;
  Result? result;
  String? msg;

  ProfileDataModel({success, result, msg});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
    msg = json['msg'];
  }

}

class Result {
  late int id;
  late String name;
  String? email;
  String? bio;
  String? dateOfBirth;
  late String phone;
  String? image;
  String? deviceId;
  String? providerId;
  String? providerName;
  late String lang;
  late int followersCount;
  late List<Address?> address;
  String? token;
  int? type;

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    bio = json['bio'];
    dateOfBirth = json['date_of_birth'];
    phone = json['phone'];
    image = json['image'];
    deviceId = json['device_id'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    lang = json['lang'];
    followersCount = json['followers_count'];
    token = json['token'];
    type = json['type'];
    if(json['address'] != null){
      address = [];
      json['address'].forEach((e){
        address.add(Address.fromJson(e));
      });
    }
  }
}

class Address{
  int? id;
  String? floorNo;
  String? flatNo;
  String? buildingNo;
  String? blockNo;
  String? street;
  String? notes;
  PairOfIdAndName? region;
  PairOfIdAndName? regionParent;

  Address.fromJson(Map<String, dynamic> json){
    id = json['id'];
    floorNo = json['floor_no'];
    flatNo = json['flat_no'];
    buildingNo = json['building_no'];
    blockNo = json['block_no'];
    street = json['street'];
    notes = json['notes'];
    region = PairOfIdAndName.fromJson(json['region']??{});
    regionParent = PairOfIdAndName.fromJson(json['region_parent']??{});
  }
}