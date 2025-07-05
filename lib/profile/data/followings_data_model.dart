class FollowingsDataModel{
  late int id;
  late int userId;
  late int followerId;
  late String createdAt;
  late String updatedAt;
  
  FollowingsDataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    followerId = json['follower_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}