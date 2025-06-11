import 'package:flutter/material.dart';
import 'package:wakala/home/presentation/view/widgets/post_screen_content.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppPaddings.p15),
      child: PostScreenContent(),
    );
  }
}
