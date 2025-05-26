import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';

import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(StringsManager.chat, style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: AppMargins.m15),
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ColorsManager.grey))
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name Very Long', style: Theme.of(context).textTheme.titleMedium),
                      Text('Name Very Long', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name Very Long', style: Theme.of(context).textTheme.titleMedium),
                      IntrinsicWidth(
                        child: IntrinsicHeight(
                          child: Container(
                            padding: EdgeInsets.all(AppPaddings.p10),
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryColor,
                              borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('This is a new measage', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('03:45', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorsManager.grey))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}