import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/home/presentation/view/widgets/select_address_dialog.dart';
import 'package:wakala/profile/presentation/view/widgets/default_address_list_element.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';

import '../../../../auth/data/profile_data_model.dart';
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
import '../../../cubit/main_cubit_states.dart';
import '../../../data/categories_data_model.dart';

class PostScreenContent extends StatefulWidget {
  const PostScreenContent({super.key});

  @override
  State<PostScreenContent> createState() => _PostScreenContentState();
}
class _PostScreenContentState extends State<PostScreenContent> {
  int? categorySelectedItem;
  int? typeSelectedItem;
  int? paymentSelectedItem;


  Address? selectedAddress;
  List<int?> selections = [];
  List<List<Categories>> subCategoryLevels = [];

  String typeHint = StringsManager.price;
  TextInputType typeKeyboard = TextInputType.number;

  late final MainCubit cubit;

  bool negotiable = false;
  bool phoneIncluded = false;
  bool chatIncluded = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    selections = [];
    subCategoryLevels = [];
    cubit = MainCubit.get(context);

    if(context.read<MainCubit>().categoriesDataModel == null){
      context.read<MainCubit>().getCategories();
    } else {
      setState(() {
        selections.add(null);
        subCategoryLevels.add(cubit.categoriesDataModel!.result!.categories);
      });
    }
    super.initState();
  }

  Future<void> _fetchSubCategories(int categoryId) async {
    await cubit.getSubCategories(categoryId);
    final subs = cubit.specificCategoriesDataModel?.subCategories;
    if (subs != null && subs.isNotEmpty) {
      setState(() {
        subCategoryLevels.add(subs);
        selections.add(null);
      });
    }
  }

  void _onCategorySelected(int level, int? categoryId) async {
    setState(() {
      subCategoryLevels = subCategoryLevels.sublist(0, level + 1);
      selections = selections.sublist(0, level + 1);

      selections[level] = categoryId;
    });

    if (categoryId != null) {
      await _fetchSubCategories(categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state){
        if (state is MainGetSubCategoriesSuccessState) {
          final subs = state.specificCategoriesDataModel?.subCategories;
          if (subs != null && subs.isNotEmpty) {
            setState(() {
              subCategoryLevels.add(subs);
              selections.add(null);
            });
          }
        }
        if(state is MainGetCategoriesSuccessState){
          setState(() {
            selections.add(null);
            subCategoryLevels.add(cubit.categoriesDataModel!.result!.categories);
          });
        }
      },
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
              ...List.generate(
                subCategoryLevels.length,
                (level){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ItemsDropDownMenu(
                      isEnabled: state is !MainGetSubCategoriesLoadingState,
                      items: subCategoryLevels[level],
                      selectedItem: selections[level],
                      onChange: (newId) => _onCategorySelected(level, newId),
                    ),
                  );
                }
              ),
              SizedBox(height: AppSizesDouble.s15,),
              IntrinsicHeight(
                child: DottedBorder(
                  color: ColorsManager.grey,
                  padding: EdgeInsets.symmetric(horizontal: AppPaddings.p5, vertical: AppPaddings.p10),
                  radius: Radius.circular(AppSizesDouble.s8),
                  borderType: BorderType.RRect,
                  dashPattern: [AppSizesDouble.s8, AppSizesDouble.s4],
                  strokeWidth: AppSizesDouble.s2,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: cubit.adImagesList.isEmpty? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetsManager.addImage),
                        Text('The maximum file size accepted is 1MB, \nand the accepted formats are JPG, PNG, and WEBP.\n\nNote: the first image is the Main Preview Image', textAlign: TextAlign.center, style: TextStyle(color: ColorsManager.grey2),),
                        SizedBox(height: AppSizesDouble.s15,),
                        ElevatedButton.icon(
                          icon: Icon(IconsManager.addIcon, color: ColorsManager.white,),
                          onPressed: () => cubit.pickAdsImages(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                            )
                          ),
                          label: Text('Add', style: TextStyle(color: ColorsManager.white),),
                        )
                      ],
                    ):
                    Column(
                      children: [
                        Wrap(
                          runSpacing: 8,
                          spacing: 8,
                          children: List.generate(
                            cubit.adImagesList.length,
                            (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  cubit.adImagesList.removeAt(index);
                                });
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSizesDouble.s8),
                                  border: Border.all(color: ColorsManager.primaryColor)
                                ),
                                child: Image.file(cubit.adImagesList[index], fit: BoxFit.cover, height: 70, width: 70,),
                              ),
                            )
                          ),
                        ),
                        SizedBox(height: AppSizesDouble.s10,),
                        Text('Click on the image to delete', textAlign: TextAlign.center, style: TextStyle(color: ColorsManager.grey2),),
                        SizedBox(height: AppSizesDouble.s5,),
                        if(cubit.adImagesList.length < 8)
                        ElevatedButton.icon(
                          icon: Icon(IconsManager.addIcon, color: ColorsManager.white,),
                          onPressed: () => cubit.pickAdsImages(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                            )
                          ),
                          label: Text('Add', style: TextStyle(color: ColorsManager.white),),
                        ),
                      ],
                    ),
                  )
                ),
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _titleController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                obscured: false,
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
                  //ItemsDropDownMenu(isExpanded: false, title: 'Condition', items: [], selectedItem: null, onChange: (value){}),
                  //ItemsDropDownMenu(isExpanded: false, title: 'Warranty', items: [], selectedItem: null, onChange: (value){}),
                  //ItemsDropDownMenu(isExpanded: false, title: 'Payment Option', items: [], selectedItem: null, onChange: (value){}),
                  DefaultPairDropDownMenu(
                    title: StringsManager.addType,
                    items: [],
                    onChanged: (value){

                    },
                    isExpanded: false,
                    borderColor: ColorsManager.grey5,
                  ),
                  DefaultPairDropDownMenu(
                    title: StringsManager.productType,
                    selectedItem: typeSelectedItem,
                    isExpanded: false,
                    borderColor: ColorsManager.grey5,
                    items: productsTypes,
                    onChanged: (value){
                      setState(() {
                        typeSelectedItem = value;
                        if(typeSelectedItem == 1){
                          typeHint = StringsManager.exchangeItem;
                          typeKeyboard = TextInputType.text;
                        } else if(typeSelectedItem == 2){
                          typeHint = StringsManager.lowestAuctionPrice;
                          typeKeyboard = TextInputType.number;
                        } else{
                          typeHint = StringsManager.price;
                          typeKeyboard = TextInputType.number;
                        }
                      });
                    }
                  ),
                ],
              ),
              SizedBox(height: AppSizesDouble.s15,),
              selectedAddress == null?
              TextButton(
                onPressed: () async{
                  final Address? address = await showDialog(
                    context: context,
                    builder: (context) => SelectAddressDialog()
                  );
                  if(address != null){
                    setState(() {
                      selectedAddress = address;
                    });
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                    Text(LocalizationService.translate(StringsManager.addAddress), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),)
                  ],
                ),
              ):
              Row(
                children: [
                  Expanded(child: DefaultAddressListElement(address: selectedAddress!, canEdit: false,)),
                  IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                      ),
                      side: BorderSide(color: ColorsManager.deepRed),
                      padding: EdgeInsets.symmetric(vertical: AppPaddings.p15)
                    ),
                    onPressed: (){
                      setState(() {
                        selectedAddress = null;
                      });
                    },
                    icon: SvgPicture.asset(AssetsManager.trash)
                  )
                ],
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _priceController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                keyboardType: typeKeyboard,
                obscured: false,
                hintText: typeHint,
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultPairDropDownMenu(
                title: StringsManager.cashOptions,
                items: [PairOfIdAndName.fromJson({'id':1,'name':'Cash'})],
                onChanged: (value) => null,
                borderColor: ColorsManager.grey5,
              ),
              //ItemsDropDownMenu(title: 'Payment Method', items: ['Cash'], selectedItem: paymentSelectedItem, onChange: (value){}),
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
