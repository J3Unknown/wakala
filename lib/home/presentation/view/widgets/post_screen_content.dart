import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;

import '../../../../utilities/local/localization_services.dart';
import '../../../../utilities/resources/assets_manager.dart';
import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/components.dart';
import '../../../../utilities/resources/icons_manager.dart';
import '../../../../utilities/resources/repo.dart';
import '../../../../utilities/resources/routes_manager.dart';
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../../../cubit/main_cubit.dart';

class PostScreenContent extends StatefulWidget {
  const PostScreenContent({super.key});

  @override
  State<PostScreenContent> createState() => _PostScreenContentState();
}
class _PostScreenContentState extends State<PostScreenContent> {
  int? categorySelectedItem;
  int? typeSelectedItem;
  int? paymentSelectedItem;

  bool negotiable = false;
  bool phoneIncluded = false;
  bool chatIncluded = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    if(context.read<MainCubit>().categoriesDataModel == null){
      context.read<MainCubit>().getCategories();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: MainCubit.get(context),
      builder: (context, state) => ConditionalBuilder(
        condition: MainCubit.get(context).categoriesDataModel != null,
        fallback: (context) => Center(child: CircularProgressIndicator(),),
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: AppPaddings.p20, horizontal: AppPaddings.p15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
                width: double.infinity,
                height: AppSizesDouble.s60,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSizesDouble.s25,
                      backgroundImage: Repo.profileDataModel!.result!.image != null?NetworkImage(Repo.profileDataModel!.result!.image!): svg_provider.Svg(AssetsManager.defaultAvatar),
                    ),
                    SizedBox(width: AppSizesDouble.s5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Repo.profileDataModel!.result!.name, style: Theme.of(context).textTheme.titleMedium),
                        if(Repo.profileDataModel!.result!.bio!= null)
                        Text(Repo.profileDataModel!.result!.bio!, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () async{
                          await MainCubit.get(context).logOut();
                          navigateToAuthLayout(context);
                        },
                        child: Text('Change\nAccount', style: TextStyle(color: ColorsManager.primaryColor),)
                    )
                  ],
                ),
              ),
              SizedBox(height: AppSizesDouble.s10,),
              ItemsDropDownMenu(
                title: 'Category',
                items: MainCubit.get(context).categoriesDataModel!.result!.categories[0].subCategories!,
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
                items: MainCubit.get(context).categoriesDataModel!.result!.categories[0].subCategories![0].subCategories!,
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
                  radius: Radius.circular(AppSizesDouble.s8),
                  borderType: BorderType.RRect,
                  dashPattern: [AppSizesDouble.s8, AppSizesDouble.s4],
                  strokeWidth: AppSizesDouble.s2,
                  child: Container(
                    width: double.infinity,
                    height: AppSizesDouble.s200,
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
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _titleController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                hintText: 'Title',
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _descriptionController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                hintText: 'Description',
                obscured: false,
                maxLines: 5,
              ),
              SizedBox(height: AppSizesDouble.s15,),
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 8,
                spacing: 5,
                children: [
                  ItemsDropDownMenu(isExpanded: false, title: 'Condition', items: [], selectedItem: null, onChange: (value){}),
                  ItemsDropDownMenu(isExpanded: false, title: 'Add Type', items: [], selectedItem: null, onChange: (value){}),
                  ItemsDropDownMenu(isExpanded: false, title: 'Warranty', items: [], selectedItem: null, onChange: (value){}),
                  ItemsDropDownMenu(isExpanded: false, title: 'Payment Option', items: [], selectedItem: null, onChange: (value){}),
                  ItemsDropDownMenu(isExpanded: false, title: 'Sale', items: [], selectedItem: null, onChange: (value){}),
                ],
              ),
              SizedBox(height: AppSizesDouble.s15,),
              TextButton(
                onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addressesList))),
                child: Row(
                  children: [
                    SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                    Text(LocalizationService.translate(StringsManager.addAddress), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),)
                  ],
                ),
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _titleController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                hintText: 'Price',
              ),
              SizedBox(height: AppSizesDouble.s15,),
              ItemsDropDownMenu(title: 'Payment Method', items: [], selectedItem: paymentSelectedItem, onChange: (value){}),
              DefaultCheckBox(
                value: negotiable,
                title: 'Negotiable',
                onChanged: (value){
                  setState(() {
                    negotiable = value!;
                  });
                },
              ),
              SizedBox(height: AppSizesDouble.s15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Contact Method', style: Theme.of(context).textTheme.titleMedium,)
              ),
              DefaultCheckBox(
                value: chatIncluded,
                title: 'Phone',
                onChanged: (value){
                  setState(() {
                    chatIncluded = value!;
                  });
                },
              ),
              DefaultCheckBox(
                value: phoneIncluded,
                title: 'Chat',
                onChanged: (value){
                  setState(() {
                    phoneIncluded = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
