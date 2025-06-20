import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/data/categories_data_model.dart';
import 'package:wakala/search_screen/presentation/view/widgets/horizontal_category_button.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../../utilities/resources/colors_manager.dart';
import '../../../../utilities/resources/constants_manager.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, required this.categories});
  final Categories categories;
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  List<List<Categories?>> subCategories = [];
  List<int?> selections = [];
  int maxLevel = 0;
  int currentLevel = 0;
  Categories? currentCategory;
  final GlobalKey<FormState> _formKey = GlobalKey();
  int? lastSelectedSubCategory;
  int selectedTypeIndex = 0;
  int selectedCashOptionIndex = 0;
  int selectedWarrantyOptionsIndex = 0;

  bool isActivated = false;

  List<String> types = [
    'Any',
    'For Sale',
    'Wanted Item'
  ];

  List<String> cashOptions = [
    'Any',
    'Cash',
    'Installment'
  ];

  List<String> warrantyOptions = [
    'Any',
    'Yes',
    'No'
  ];

  @override
  void initState() {
    log((widget.categories.endPoint != 1 && widget.categories.subCategories != null).toString());
    log((widget.categories.name.toString()));
    log((widget.categories.subCategories).toString());
    if (widget.categories.endPoint != 1 && widget.categories.subCategories != null) {
        subCategories.add(widget.categories.subCategories!);
    }
    //_init();
    super.initState();
  }

  // Categories _findCategories(context, Categories category){
  //   for (var e in MainCubit.get(context).categoriesDataModel!.result!.categories) {
  //     if(e.id == category.id){
  //       return e;
  //     }
  //   }
  //   return category;
  // }

  void _init(){
  }

  // void _handleDropdownChange(int level, int? selectedId) {
  //   setState(() {
  //     // Update selectedPath for this level
  //     if (level < selectedPath.length) {
  //       selectedPath[level] = selectedId == null ? null :
  //       dropdownLevels[level].firstWhere((e) => e.id == selectedId);
  //     } else {
  //       selectedPath.add(selectedId == null ? null :
  //       dropdownLevels[level].firstWhere((e) => e.id == selectedId));
  //     }
  //
  //     // Truncate subsequent levels
  //     if (selectedPath.length > level + 1) {
  //       selectedPath = selectedPath.sublist(0, level + 1);
  //       dropdownLevels = dropdownLevels.sublist(0, level + 1);
  //     }
  //
  //     // Add next level if selected subcategory is not endpoint
  //     if (selectedId != null) {
  //       final selectedSub = dropdownLevels[level].firstWhere((e) => e.id == selectedId);
  //       if (selectedSub.endPoint != 1 && selectedSub.subCategories.isNotEmpty) {
  //         dropdownLevels.add(selectedSub.subCategories);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsManager.white,
      elevation: AppSizesDouble.s10,
      shadowColor: ColorsManager.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s8)
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPaddings.p15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HorizontalCategoryButton(title: widget.categories.name, image: AppConstants.baseImageUrl + widget.categories.image,),
              SizedBox(height: AppSizesDouble.s15,),
              ...List.generate(subCategories.length, (index){
                log(subCategories[maxLevel].toString());
                return Column(
                  children: [
                    ItemsDropDownMenu(
                      items: subCategories[currentLevel],
                      selectedItem: selections[currentLevel],
                      onChange: (value){},
                    ),
                    SizedBox(height: AppSizesDouble.s20,)
                  ],
                );
              }),
              SizedBox(height: AppSizesDouble.s20,),
              Text('Price', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
              SizedBox(height: AppSizesDouble.s10,),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultFilterInputField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        hint: 'Min',
                        validator: (String? value){
                          if(int.parse(value!) > int.parse(_maxPriceController.text)){
                            return 'Minimum Price can\'t be greater than the Maximum Price!!';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: AppSizesDouble.s5,),
                    Expanded(child: DefaultFilterInputField(controller: _maxPriceController, keyboardType: TextInputType.number, hint: 'Max',))
                  ],
                ),
              ),
              DefaultFilterOptions(
                title: 'Add Type',
                types: types,
                onChanged: (int selected) {
                  setState(() {
                    selectedTypeIndex = selected;
                  });
                },
                selectedOption: selectedTypeIndex
              ),
              DefaultFilterOptions(
                title: 'Payment Options',
                types: cashOptions,
                onChanged: (int selected) {
                  setState(() {
                    selectedCashOptionIndex = selected;
                  });
                },
                selectedOption: selectedCashOptionIndex
              ),
              DefaultFilterOptions(
                title: 'Warranty',
                types: warrantyOptions,
                onChanged: (int selected) {
                  setState(() {
                    selectedWarrantyOptionsIndex = selected;
                  });
                },
                selectedOption: selectedWarrantyOptionsIndex
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultSwitch(
                isOutlined: false,
                backgroundColor: ColorsManager.transparent,
                title: StringsManager.showVerifiedAccountsFirst,
                isActivated: isActivated,
                onChanged: (value){
                  setState(() {
                    isActivated = value;
                  });
                }
              ),
              SizedBox(height: AppSizesDouble.s15,),
              DefaultAuthButton(
                height: AppSizesDouble.s50,
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.of(context).pop();
                  }
                },
                title: LocalizationService.translate(StringsManager.confirm),
                backgroundColor: ColorsManager.primaryColor,
                hasBorder: false,
                foregroundColor: ColorsManager.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultFilterOptions extends StatefulWidget {
  const DefaultFilterOptions({super.key, required this.title, required this.types, required this.onChanged, required this.selectedOption});

  final String title;
  final List<String> types;
  final ValueChanged<int> onChanged;
  final int selectedOption;

  @override
  State<DefaultFilterOptions> createState() => _DefaultFilterOptionsState();
}
class _DefaultFilterOptionsState extends State<DefaultFilterOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSizesDouble.s20,),
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
        SizedBox(height: AppSizesDouble.s10,),
        DefaultFilterWrap(
          items: widget.types,
          selectedIndex: widget.selectedOption,
          onChanged: (int selected) => widget.onChanged(selected)
        )
      ],
    );
  }
}

class DefaultFilterWrap extends StatefulWidget {
  const DefaultFilterWrap({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged
  });
  final List<String> items;
  final int? selectedIndex;
  final ValueChanged<int> onChanged;
  @override
  State<DefaultFilterWrap> createState() => _DefaultFilterWrapState();
}
class _DefaultFilterWrapState extends State<DefaultFilterWrap> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizesDouble.s5,
      children: List.generate(widget.items.length, (index) =>
        ChoiceChip(
          label: Text(widget.items[index]),
          selected: widget.selectedIndex == index,
          backgroundColor: ColorsManager.white,
          selectedColor: ColorsManager.primaryColor,
          labelStyle: TextStyle(color: widget.selectedIndex == index ? ColorsManager.white : ColorsManager.black),
          checkmarkColor: widget.selectedIndex == index ? ColorsManager.white : null,
          onSelected: (bool selected) => widget.onChanged(selected?index:widget.selectedIndex!),
        ),
      )
    );
  }
}
