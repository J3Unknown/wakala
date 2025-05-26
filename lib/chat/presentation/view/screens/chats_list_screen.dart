import 'package:flutter/material.dart';
import 'package:wakala/chat/presentation/view/widgets/ChatCard.dart';
import 'package:wakala/utilities/resources/values_manager.dart';


class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10, vertical: AppPaddings.p15),
      itemBuilder: (context, index) => ChatCard(),
      separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
      itemCount: 10
    );
  }
}


