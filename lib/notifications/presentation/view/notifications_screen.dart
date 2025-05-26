import 'package:flutter/material.dart';
import 'package:wakala/notifications/presentation/view/widgets/notification_card.dart';

import '../../../utilities/resources/values_manager.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10, vertical: AppPaddings.p15),
      itemBuilder: (context, index) => NotificationCard(),
      separatorBuilder: (context, index) => SizedBox(height: AppSizesDouble.s10,),
      itemCount: 10
    );
  }
}
