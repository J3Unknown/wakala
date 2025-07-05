class ReportOptionsDataModel{
  late bool success;
  String? message;
  late List<ReportOption> options;

  ReportOptionsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    options = <ReportOption>[];
    json['result'].forEach((e) => options.add(ReportOption.fromJson(e)));
    message = json['message'];
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