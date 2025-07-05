import 'package:wakala/home/data/specific_ad_data_model.dart';

class ChatsDataModel{
  late bool success;
  String? message;
  Result? result;

  ChatsDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['msg'];
    result = Result.fromJson(json['result']);
  }
}

class Result{
  late List<Chat> chats;
  Result.fromJson(Map<String, dynamic> json){
    chats = [];
    if(json['chats'] != null){
      json['chats'].forEach((e){
        chats.add(Chat.fromJson(e));
      });
    }
  }
}

class Chat{
  User? sender;
  User? receiver;
  late List<Message> messages;

  Chat({this.messages = const [], this.receiver, this.sender});

  Chat.fromJson(Map<String, dynamic> json){
    messages = [];
    if(json['messages'] != null){
      json['messages'].forEach((e){
        messages.add(Message.fromJson(e));
      });
    }
    if(json['sender'] != null){
      sender = User.fromJson(json['sender']);
    }
    if(json['receiver'] != null){
      receiver = User.fromJson(json['receiver']);
    }
  }
}

class Message{
  late int id;
  late int senderId;
  late int receiverId;
  late String message;
  late String messageType;
  late String createdAt;
  late String updatedAt;
  User? sender;
  User? receiver;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    required this.receiver,
  });

  Message.fromJson(Map<String, dynamic> json){
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    messageType = json['message_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sender = User.fromJson(json['sender']);
    receiver = User.fromJson(json['receiver']);
  }
}