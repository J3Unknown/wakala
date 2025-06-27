class ReportOptionsDataModel{
  late bool success;
  String? message;
  Result? result;

  ReportOptionsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    if(json['result'] != null){
      result = Result.fromJson(json['result']);
    }
    message = json['message'];
  }
}

class Result{
  late List<ReportOption> options;
  Result.fromJson(Map<String, dynamic> json){
    options = <ReportOption>[];
    json['result'].forEach((e) => options.add(ReportOption.fromJson(e)));
  }
}

class ReportOption{
  late int id;
  late int enable;
  late String titleAR;
  late String titleEn;
  late String createdAt;
  late String updatedAt;

  ReportOption.fromJson(Map<String, dynamic> json){
    id = json['id'];
    enable = json['enable'];
    titleAR = json['title_ar'];
    titleEn = json['title_en'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}