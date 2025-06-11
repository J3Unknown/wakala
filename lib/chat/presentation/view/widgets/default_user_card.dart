import 'package:flutter/material.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class DefaultUserCard extends StatelessWidget {
  const DefaultUserCard({
    super.key,
    this.hasMargin = true,
    this.hasUnderline = true,
  });

  final bool hasMargin;
  final bool hasUnderline;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: hasMargin?EdgeInsets.only(bottom: AppMargins.m15):null,
      padding: hasMargin?EdgeInsets.symmetric(horizontal: AppPaddings.p10):null,
      width: double.infinity,
      height: AppSizesDouble.s60,
      decoration: hasUnderline?BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorsManager.grey))
      ):null,

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
    );
  }
}