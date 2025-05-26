import 'package:flutter/material.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.chat))),
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
                  backgroundImage: NetworkImage('https://s3.eu-central-1.amazonaws.com/uploads.mangoweb.org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'),
                ),
                SizedBox(width: AppSizesDouble.s10,),
                Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('This is the longest name ever made', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
                        Text('Preview of the last sent Message', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.grey),  maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,)
                      ],
                    )
                ),
                Text('13:50', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: ColorsManager.grey2),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}