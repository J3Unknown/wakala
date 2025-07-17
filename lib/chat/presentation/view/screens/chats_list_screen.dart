import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/chat/presentation/view/widgets/ChatCard.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/values_manager.dart';


class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {

  @override
  void initState() {
    context.read<MainCubit>().getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){},
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.chatsDataModel != null && cubit.chatsDataModel!.result!.chats.isNotEmpty && state is !MainGetChatsLoadingState,
        fallback: (context){
          if(cubit.chatsDataModel == null && state is MainGetChatsLoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox();
        },
        builder: (context) => ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10, vertical: AppPaddings.p15),
          itemBuilder: (context, index) => ChatCard(chat: cubit.chatsDataModel!.result!.chats[index],),
          separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
          itemCount: cubit.chatsDataModel!.result!.chats.length
        ),
      ),
    );
  }
}


