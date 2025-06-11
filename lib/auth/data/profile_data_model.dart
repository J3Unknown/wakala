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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['msg'] = msg;
    return data;
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
  List<dynamic>? address;
  String? token;
  int? type;

  Result(
      {id,
        name,
        email,
        bio,
        dateOfBirth,
        phone,
        image,
        deviceId,
        providerId,
        providerName,
        lang,
        followersCount,
        token,
        type,
        address = const []});

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
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['bio'] = bio;
    data['date_of_birth'] = dateOfBirth;
    data['phone'] = phone;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['lang'] = lang;
    data['followers_count'] = followersCount;
    data['token'] = token;
    data['type'] = type;
    data['address'] = address;
    return data;
  }
}
