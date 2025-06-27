import 'package:wakala/home/data/commercial_ad_data_model.dart';

class CitiesAndRegionsDataModel{
  late bool success;
  late List<PairOfIdAndName> result;
  String? message;

  CitiesAndRegionsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    if(json['result'] != null){
      result = [];
      json['result'].forEach((e){
        result.add(PairOfIdAndName.fromJson(e));
      });
    }
  }
}