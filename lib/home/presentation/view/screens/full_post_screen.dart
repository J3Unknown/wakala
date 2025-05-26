import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/values_manager.dart';

class FullPostScreen extends StatefulWidget {
  const FullPostScreen({super.key});

  @override
  State<FullPostScreen> createState() => _FullPostScreenState();
}

class _FullPostScreenState extends State<FullPostScreen> {
  String? categorySelectedItem;
  String? typeSelectedItem;

  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: 'property0', child: Text('property1', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property1', child: Text('property2', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property2', child: Text('property3', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property3', child: Text('property4', style: TextStyle(color: ColorsManager.black))),
    DropdownMenuItem(value: 'property4', child: Text('property5', style: TextStyle(color: ColorsManager.black))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
              width: double.infinity,
              height: 60,
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
                      Text('Account Type', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => navigateToAuthLayout(context),
                    child: Text('Change\nAccount', style: TextStyle(color: ColorsManager.primaryColor),)
                  )
                ],
              ),
            ),
            SizedBox(height: AppSizesDouble.s10,),
            ItemsDropDownMenu(
              title: 'Category',
              items: items,
              selectedItem: categorySelectedItem,
              onChange: (value){
                setState(() {
                  categorySelectedItem = value;
                });
              },
            ),
            SizedBox(height: AppSizesDouble.s10,),
            ItemsDropDownMenu(
              title: 'type',
              items: items,
              selectedItem: typeSelectedItem,
              onChange: (value){
                setState(() {
                  typeSelectedItem = value;
                });
              },
            ),
            SizedBox(height: AppSizesDouble.s15,),
            DottedBorder(
              color: ColorsManager.grey,
              padding: EdgeInsets.all(AppPaddings.p5),
              radius: Radius.circular(8),
              borderType: BorderType.RRect,
              dashPattern: [8, 4],
              strokeWidth: 2,
              child: Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetsManager.addImage),
                    Text('The maximum file size accepted is 1MB, \nand the accepted formats are JPG, PNG, and JPEG.', textAlign: TextAlign.center, style: TextStyle(color: ColorsManager.grey2),),
                    SizedBox(height: AppSizesDouble.s15,),
                    ElevatedButton.icon(
                      icon: Icon(IconsManager.addIcon, color: ColorsManager.white,),
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                        )
                      ),
                      label: Text('Add', style: TextStyle(color: ColorsManager.white),),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
