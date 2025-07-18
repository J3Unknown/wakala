import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:intl/intl.dart';
import 'package:wakala/chat/data/chat_screen_arguments.dart';
import 'package:wakala/chat/data/chats_data_model.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';

import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat
  });

  final Chat chat;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.chat, arguments: ChatScreenArgument(chat.receiver!.id, chat.receiver!.name, chat.receiver!.image, chat)))),
      child: Card(
        shadowColor: ColorsManager.shadowColor,
        elevation: AppSizesDouble.s2,
        color: ColorsManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
          side: BorderSide(color: ColorsManager.grey4)
        ),
        child: Padding(
          padding: EdgeInsets.all(AppPaddings.p5),
          child: SizedBox(
            height: AppSizesDouble.s60,
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppSizesDouble.s25,
                  backgroundImage: chat.receiver!.image != null? NetworkImage(AppConstants.baseImageUrl + chat.receiver!.image!):Svg(AssetsManager.defaultAvatar),
                ),
                SizedBox(width: AppSizesDouble.s10,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat.receiver!.name, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                      if(chat.messages.isNotEmpty)
                      Text(chat.messages.last.message, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.grey),  maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
                    ],
                  )
                ),
                if(chat.messages.isNotEmpty)
                Text(DateFormat(' hh:mm \n dd - MM').format(DateTime.parse(chat.messages.last.createdAt)), style: Theme.of(context).textTheme.labelLarge!.copyWith(color: ColorsManager.grey2),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}