class AboutUsDataModel{
  late bool success;
  Result? result;
  String? message;

  AboutUsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    result = Result.fromJson(json['result']);
    message = json['msg'];
  }
}

class Result{
  late int id;
  String? whatsappNumber;
  String? facebook;
  String? instagram;
  String? youtube;
  String? description;
  String? privacy;
  String? terms;
  Result.fromJson(Map<String, dynamic> json){
    id = json['id'];
    whatsappNumber = json['whatsapp_number'];
    facebook = json['facebook'];
    instagram = json['insta'];
    youtube = json['youtube'];
    description = json['description'];
    privacy = json['privacy'];
    terms = json['terms'];
  }
}