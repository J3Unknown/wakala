import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_picture;
import 'package:url_launcher/url_launcher.dart';
import 'package:wakala/chat/data/chat_screen_arguments.dart';
import 'package:wakala/chat/data/chats_data_model.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:intl/intl.dart';
import 'package:wakala/utilities/resources/repo.dart';

import '../../../../home/data/specific_ad_data_model.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../widgets/default_user_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late int _receiverId;
  late String _receiverName;
  String? _receiverImage;
  Chat? _chat;

  //TODO: Update it to receive the full chat not only _chat.messages list
  @override
  void didChangeDependencies() {
    ChatScreenArgument? args = ModalRoute.of(context)!.settings.arguments as ChatScreenArgument?;
    if(args != null) {
      _receiverId = args.id;
      _receiverName = args.name;
      _receiverImage = args.image;
      _chat = args.chat??Chat(
          sender: User(
            id: Repo.profileDataModel!.result!.id,
            name: Repo.profileDataModel!.result!.name,
            phone: Repo.profileDataModel!.result!.phone,
            image: Repo.profileDataModel!.result!.image
          ),
          receiver: User(id: args.id, name: args.name, image: args.image),
          messages: []
      );;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    context.read<MainCubit>().pickedFiles = null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
              child: Text(StringsManager.chat, style: Theme.of(context).textTheme.titleLarge,),
            ),
          ],
        ),
        body: Column(
          children: [
            DefaultUserCard(
              id: _receiverId,
              name: _receiverName,
              image: _receiverImage,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  User user = Repo.profileDataModel!.result!.id == _chat!.messages[index].receiverId?_chat!.messages[index].receiver!:_chat!.messages[index].sender!;
                  return _chat!.messages[index].receiverId == Repo.profileDataModel!.result!.id?
                  ReceiverChatCard(message: _chat!.messages[index], user: user):
                  SenderChatCard(
                    message: _chat!.messages[index],
                    onDelete: (id){
                      MainCubit.get(context).deleteMessage(id);
                      _chat!.messages.removeWhere((e) => e.id == id);
                    },
                  );
                },
                itemCount: _chat != null?_chat!.messages.length:0,
              ),
            ),
            DefaultChatSendButton(receiverId: _receiverId, chat: _chat!,)
          ],
        ),
      ),
    );
  }
}

class DefaultChatSendButton extends StatefulWidget {
  const DefaultChatSendButton({
    super.key,
    required this.receiverId,
    required this.chat,
  });
  final int receiverId;
  final Chat chat;

  @override
  State<DefaultChatSendButton> createState() => _DefaultChatSendButtonState();
}

class _DefaultChatSendButtonState extends State<DefaultChatSendButton> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){
        //TODO: Change the state into the correct state after finishing the check
        if(state is MainSendMessageErrorState || state is MainSendMessageSuccessState){
          bool isValid = widget.chat.messages.isNotEmpty;
          widget.chat.messages.add(
            Message(
              id:isValid?widget.chat.messages.last.id+1:0,
              senderId: Repo.profileDataModel!.result!.id,
              receiverId: widget.receiverId,
              message: MainCubit.get(context).pickedFiles != null?MainCubit.get(context).pickedFiles!.name:_messageController.text,
              messageType: MainCubit.get(context).pickedFiles == null?'Text':'File',
              createdAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
              sender: isValid?(widget.chat.messages.last.receiverId == Repo.profileDataModel!.result!.id?widget.chat.messages.last.sender:widget.chat.messages.last.receiver):widget.chat.sender,
              receiver: isValid?(widget.chat.messages.last.receiverId == Repo.profileDataModel!.result!.id?widget.chat.messages.last.receiver:widget.chat.messages.last.sender):widget.chat.receiver
            )
          );
          _messageController.clear();
          MainCubit.get(context).pickedFiles = null;
        }
      },
      builder: (context, state) => Padding(
        padding: EdgeInsets.symmetric(vertical: AppPaddings.p15, horizontal: AppPaddings.p20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if(MainCubit.get(context).pickedFiles != null)
            Expanded(child: DefaultChatFile(file: MainCubit.get(context).pickedFiles!.name),
            ),
            if(MainCubit.get(context).pickedFiles == null)
            Expanded(
              child: DefaultTextInputField(
                controller: _messageController,
                isOutlined: true,
                obscured: false,
                minLines: 1,
                maxLines: 5,
                hintText: 'Type something...',
                suffixIcon: AssetsManager.attachment,
                onSuffixPressed: () => MainCubit.get(context).getChatAttachment(),
              )
            ),
            SizedBox(width: 10,),
            SizedBox(
              height: 57,
              width: 57,
              child: IconButton.filled(
                onPressed: (){
                  if(_messageController.text.trim().isNotEmpty || MainCubit.get(context).pickedFiles != null){
                    MainCubit.get(context).sendMessage(
                      widget.receiverId,
                      MainCubit.get(context).pickedFiles?? _messageController.text,
                      MainCubit.get(context).pickedFiles == null? 'Text':'File'
                    );
                  }
                },
                icon: SvgPicture.asset(AssetsManager.send),
                style: IconButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultChatFile extends StatefulWidget {
  const DefaultChatFile({super.key, required this.file});
  final String file;
  @override
  State<DefaultChatFile> createState() => _DefaultChatFileState();
}
class _DefaultChatFileState extends State<DefaultChatFile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Uri uri = Uri.parse(widget.file);
        if(await canLaunchUrl(uri)) {
          launchUrl(uri);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppMargins.m5),
        padding: EdgeInsets.all(AppPaddings.p5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
          color: ColorsManager.loginButtonBackgroundColor,
          border: Border.all(color: ColorsManager.grey4)
        ),
        child: Text(widget.file, maxLines: AppSizes.s1,overflow: TextOverflow.ellipsis,),
      ),
    );
  }
}


class ReceiverChatCard extends StatelessWidget {
  const ReceiverChatCard({
    super.key,
    required Message message,
    required User user
  }) : _message = message, _user = user;

  final Message _message;
  final User _user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: _user.image != null? NetworkImage(AppConstants.baseImageUrl + _user.image!):svg_picture.Svg(AssetsManager.defaultAvatar),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_user.name, style: Theme.of(context).textTheme.titleMedium),
              IntrinsicHeight(
                child: IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - AppSizesDouble.s130,
                      minWidth: AppSizesDouble.s20,
                    ),
                    padding: EdgeInsets.all(AppPaddings.p10),
                    decoration: BoxDecoration(
                      color: ColorsManager.grey5,
                      borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                    ),
                    width: double.infinity,
                    child: _message.messageType != 'File'?
                    Text(_message.message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.black),)
                    : DefaultChatFile(file: _message.message,),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(DateFormat(StringsManager.dateFormat).format(DateTime.parse(_message.createdAt)), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.grey))
            ],
          ),
        ],
      ),
    );
  }
}
class SenderChatCard extends StatelessWidget {
  const SenderChatCard({
    super.key,
    required Message message,
    required void Function(int) onDelete

  }) : _message = message, _onDelete = onDelete;

  final Message _message;
  final void Function(int) _onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => _onDelete(_message.id),
            icon: SvgPicture.asset(AssetsManager.trash)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IntrinsicHeight(
                child: IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - AppSizesDouble.s130,
                      minWidth: AppSizesDouble.s20,
                    ),
                    padding: EdgeInsets.all(AppPaddings.p10),
                    decoration: BoxDecoration(
                        color: ColorsManager.primaryColor,
                        borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                    ),
                    width: double.infinity,
                    child: _message.messageType != 'File'?
                    Text(_message.message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.white),) :
                    DefaultChatFile(file: _message.message,),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(DateFormat(StringsManager.dateFormat).format(DateTime.parse(_message.createdAt)), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.grey))
            ],
          ),
        ],
      ),
    );
  }
}