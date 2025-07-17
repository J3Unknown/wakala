import 'dart:developer';

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
import '../../../../utilities/resources/strings_manager.dart';
import '../../../../utilities/resources/values_manager.dart';
import '../../../cubit/main_cubit.dart';
import '../../../cubit/main_cubit_states.dart';
import '../../../data/categories_data_model.dart';

class PostScreenContent extends StatefulWidget {
  const PostScreenContent({super.key, this.item});
  final CommercialAdItem? item;
  @override
  State<PostScreenContent> createState() => _PostScreenContentState();
}
class _PostScreenContentState extends State<PostScreenContent> {
  int? typeSelectedItem;
  int? paymentSelectedItem;


  Address? selectedAddress;
  List<int?> selections = [];
  List<List<Categories>> subCategoryLevels = [];

  String typeHint = '';
  TextInputType typeKeyboard = TextInputType.number;

  late final MainCubit cubit;

  bool negotiable = false;
  int isPhoneContact = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    if(widget.item != null){
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description!;
      _priceController.text = widget.item!.price.toString();
      negotiable = widget.item!.negotiable == 1;
      isPhoneContact = widget.item!.contactMethod == 'phone'?0:1;
      typeSelectedItem = widget.item!.adsType!.id;

    }
    selections = [];
    subCategoryLevels = [];
    cubit = MainCubit.get(context);
    cubit.adImagesList = [];
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
  void didChangeDependencies() {

    super.didChangeDependencies();
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
                child: ConditionalBuilder(
                  condition: Repo.profileDataModel != null,
                  fallback: (context) => Center(child: CircularProgressIndicator(),),
                  builder: (context) => Row(
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
                        child: Text(LocalizationService.translate(StringsManager.changeAccount), style: TextStyle(color: ColorsManager.primaryColor),)
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizesDouble.s10,),
              ...List.generate(
                subCategoryLevels.length,
                (level){
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppPaddings.p20),
                    child: ItemsDropDownMenu(
                      isEnabled: state is !MainGetSubCategoriesLoadingState,
                      items: subCategoryLevels[level],
                      selectedItem: selections[level],
                      onChange: (newId) => _onCategorySelected(level, newId),
                    ),
                  );
                }
              ),
              Text(LocalizationService.translate(StringsManager.editWarning), style: Theme.of(context).textTheme.labelSmall!.copyWith(color: ColorsManager.deepRed),),
              SizedBox(height: AppSizesDouble.s20,),
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
                        Text(LocalizationService.translate(StringsManager.imagePickingWarning), textAlign: TextAlign.center, style: TextStyle(color: ColorsManager.grey2),),
                        SizedBox(height: AppSizesDouble.s15,),
                        Text(LocalizationService.translate(StringsManager.editWarning), style: Theme.of(context).textTheme.labelSmall!.copyWith(color: ColorsManager.deepRed), textAlign: TextAlign.center,),
                        ElevatedButton.icon(
                          icon: Icon(IconsManager.addIcon, color: ColorsManager.white,),
                          onPressed: () => cubit.pickAdsImages(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                            )
                          ),
                          label: Text(LocalizationService.translate(StringsManager.add), style: TextStyle(color: ColorsManager.white),),
                        )
                      ],
                    ):
                    Column(
                      children: [
                        Wrap(
                          runSpacing: AppSizesDouble.s8,
                          spacing: AppSizesDouble.s8,
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
                                child: Image.file(cubit.adImagesList[index], fit: BoxFit.cover, height: AppSizesDouble.s70, width: AppSizesDouble.s70,),
                              ),
                            )
                          ),
                        ),
                        SizedBox(height: AppSizesDouble.s10,),
                        Text(LocalizationService.translate(StringsManager.clickOnImageToDelete), textAlign: TextAlign.center, style: TextStyle(color: ColorsManager.grey2),),
                        SizedBox(height: AppSizesDouble.s5,),
                        if(cubit.adImagesList.length < AppSizesDouble.s8)
                        ElevatedButton.icon(
                          icon: Icon(IconsManager.addIcon, color: ColorsManager.white,),
                          onPressed: () => cubit.pickAdsImages(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizesDouble.s8)
                            )
                          ),
                          label: Text(LocalizationService.translate(StringsManager.add), style: TextStyle(color: ColorsManager.white),),
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
                hintText: StringsManager.title,
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultTextInputField(
                controller: _descriptionController,
                isOutlined: true,
                borderColor: ColorsManager.grey5,
                hintText: StringsManager.description,
                obscured: false,
                maxLines: 5,
              ),
              SizedBox(height: AppSizesDouble.s15,),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 8,
                  spacing: 5,
                  children: [
                    //ItemsDropDownMenu(isExpanded: false, title: 'Condition', items: [], selectedItem: null, onChange: (value){}),
                    //ItemsDropDownMenu(isExpanded: false, title: 'Warranty', items: [], selectedItem: null, onChange: (value){}),
                    //ItemsDropDownMenu(isExpanded: false, title: 'Payment Option', items: [], selectedItem: null, onChange: (value){}),
                    // DefaultPairDropDownMenu(
                    //   title: StringsManager.addType,
                    //   items: [],
                    //   onChanged: (value){
                    //
                    //   },
                    //   isExpanded: false,
                    //   borderColor: ColorsManager.grey5,
                    // ),
                    DefaultPairDropDownMenu(
                      title: StringsManager.productType,
                      selectedItem: typeSelectedItem,
                      isExpanded: false,
                      borderColor: ColorsManager.grey5,
                      items: productsTypes,
                      onChanged: (value){
                        setState(() {
                          typeSelectedItem = value;
                          if(typeSelectedItem == AppSizes.s1){
                            _priceController.clear();
                            typeHint = StringsManager.exchangeItem;
                            typeKeyboard = TextInputType.text;
                          } else if(typeSelectedItem == AppSizes.s2){
                            _priceController.clear();
                            typeHint = StringsManager.lowestAuctionPrice;
                            typeKeyboard = TextInputType.number;
                          } else{
                            _priceController.clear();
                            typeHint = StringsManager.price;
                            typeKeyboard = TextInputType.number;
                          }
                        });
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizesDouble.s15,),
              if(selectedAddress == null)
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
              ),
              if(selectedAddress == null)
              Text(LocalizationService.translate(StringsManager.editWarning), style: Theme.of(context).textTheme.labelSmall!.copyWith(color: ColorsManager.deepRed), textAlign: TextAlign.center,),
              if(selectedAddress != null)
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
                items: AppConstants.paymentOptions,
                onChanged: (value){},
                selectedItem: AppConstants.paymentOptions.first.id,
                borderColor: ColorsManager.grey5,
              ),
              DefaultCheckBox(
                value: negotiable,
                title: StringsManager.negotiable,
                onChanged: (value){
                  setState(() {
                    negotiable = value!;
                  });
                },
              ),
              SizedBox(height: AppSizesDouble.s15,),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(LocalizationService.translate(StringsManager.contactMethod), style: Theme.of(context).textTheme.titleMedium,)
              ),
              RadioListTile.adaptive(
                value: AppSizes.s0,
                title: Text(LocalizationService.translate(StringsManager.phone)),
                activeColor: ColorsManager.primaryColor,
                contentPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p5),
                onChanged: (value){
                  setState(() {
                    isPhoneContact = 0;
                  });
                },
                groupValue: isPhoneContact,
              ),
              RadioListTile.adaptive(
                value: AppSizes.s1,
                contentPadding: EdgeInsets.symmetric(horizontal: AppPaddings.p5),
                title: Text(LocalizationService.translate(StringsManager.chat)),
                activeColor: ColorsManager.primaryColor,
                onChanged: (value){
                  setState(() {
                    isPhoneContact = 1;
                  });
                },
                groupValue: isPhoneContact,
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultAuthButton(
                onPressed: (){
                  if(
                 ( selections.length == 1 && selections.first == null ||
                  cubit.adImagesList.length < 2 ||
                  _titleController.text.isEmpty ||
                  typeSelectedItem == null ||
                  _descriptionController.text.isEmpty ||
                  selectedAddress == null ||
                  _priceController.text.isEmpty) &&
                   widget.item == null
                  ){
                    if(selections.length == 1 && selections.first == null && widget.item == null){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.oneCategorySelectionWarning),
                      );
                    } else if(cubit.adImagesList.length < 2 && widget.item == null){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.twoImagesWarning),
                      );
                    } else if(_titleController.text.isEmpty){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.titleMustBeAdded),
                      );
                    } else if(_descriptionController.text.isEmpty){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.descriptionMustBeAdded),
                      );
                    } else if(selectedAddress == null && widget.item == null){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.selectYourAddress),
                      );
                    }else if(typeSelectedItem == null){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.selectAdType),
                      );
                    } else if(_priceController.text.isEmpty){
                      if(typeSelectedItem == 1){
                        showToastMessage(
                          msg: LocalizationService.translate(StringsManager.addExchangeItem),
                        );
                      } else if(typeSelectedItem == 2){
                        showToastMessage(
                          msg: LocalizationService.translate(StringsManager.addLowestAuctionPrice),
                        );
                      } else{
                        showToastMessage(
                          msg: LocalizationService.translate(StringsManager.addProductPrice),
                        );
                      }
                    } else if(typeSelectedItem == 3 && !(int.parse(_priceController.text) > 0)){
                      showToastMessage(
                        msg: LocalizationService.translate(StringsManager.zeroPriceWarning),
                        toastState: ToastState.warning
                      );
                    }
                  } else {
                    if(widget.item == null){
                      cubit.postAd(
                        categoryId: selections.last!,
                        typeId: typeSelectedItem!,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        contactMethod: isPhoneContact == 0?StringsManager.phone:StringsManager.chat,
                        mainImage: cubit.adImagesList.first,
                        images: cubit.adImagesList.sublist(1),
                        cityId: selectedAddress!.regionParent!.id??13,
                        regionId: selectedAddress!.region!.id??14,
                        endDate: DateTime.now().toString(),
                        startDate: DateTime.now().toString(),
                        exchangeItem: typeSelectedItem == 0?_priceController.text:null,
                        lowestAuction: typeSelectedItem == 1?_priceController.text:null,
                        negotiable: negotiable?1:0,
                        price: typeSelectedItem == 2?_priceController.text:null
                      );
                    } else {
                      log(widget.item!.id.toString());
                      cubit.editAd(
                        id: widget.item!.id,
                        categoryId: selections.last??widget.item!.categoryId,
                        typeId: typeSelectedItem!,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        contactMethod: isPhoneContact == 0?StringsManager.phone:StringsManager.chat,
                        mainImage: cubit.adImagesList.isNotEmpty?cubit.adImagesList.first:null,
                        images:  cubit.adImagesList.isNotEmpty?cubit.adImagesList.sublist(1):null,
                        cityId: selectedAddress!= null? selectedAddress!.regionParent!.id!:widget.item!.cityId,
                        regionId: selectedAddress != null? selectedAddress!.region!.id!:widget.item!.regionId,
                        endDate: widget.item!.endDate,
                        startDate: widget.item!.startDate,
                        exchangeItem: typeSelectedItem == 0?_priceController.text:null,
                        lowestAuction: typeSelectedItem == 1?_priceController.text:null,
                        negotiable: negotiable?1:0,
                        price: typeSelectedItem == 2?_priceController.text:null
                      );
                    }
                  }
                },
                title: StringsManager.save,
                hasBorder: false,
                backgroundColor: ColorsManager.primaryColor,
                foregroundColor: ColorsManager.white,
                height: AppSizesDouble.s60,
                pressCondition: state is MainPostAdLoadingState,
              )
            ],
          ),
        ),
      ),
    );
  }
}
