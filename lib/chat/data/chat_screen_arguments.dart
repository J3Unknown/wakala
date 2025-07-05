import 'package:wakala/chat/data/chats_data_model.dart';

class ChatScreenArgument{
  int id;
  String name;
  String? image;
  Chat? chat;

  ChatScreenArgument(this.id, this.name, this.image, this.chat);
}