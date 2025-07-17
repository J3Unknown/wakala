import 'package:flutter/material.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';

import '../../../../utilities/local/localization_services.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../widgets/post_screen_content.dart';

class FullPostScreen extends StatefulWidget {
  const FullPostScreen({super.key, this.ad});
  final CommercialAdItem? ad;
  @override
  State<FullPostScreen> createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.editProduct), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: PostScreenContent(item: widget.ad,),
    );
  }
}
