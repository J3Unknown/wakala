import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/profile/data/add_address_arguments.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';

import '../../../utilities/local/localization_services.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key,});
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  int? selectedRegion;
  int? selectedCity;
  int? id;
  late bool isEdit;
  AddAddressArguments? args;

  bool _shouldLoadRegions = false;

  late GlobalKey<FormState> _formKey;
  late final TextEditingController _streetController;
  late final TextEditingController _blockNoController;
  late final TextEditingController _buildingNoController;
  late final TextEditingController _flatNoController;
  late final TextEditingController _floorNoController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _streetController = TextEditingController();
    _blockNoController = TextEditingController();
    _buildingNoController = TextEditingController();
    _flatNoController = TextEditingController();
    _floorNoController = TextEditingController();
    _noteController = TextEditingController();
    if(context.read<MainCubit>().cities == null){
      context.read<MainCubit>().getCities();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context)!.settings.arguments as AddAddressArguments?;
    if(args != null) {
      isEdit = args!.isEdit;
      final address = args!.address;
      if (address != null) {
        id = address.id;
        _streetController.text = address.street ?? '';
        _blockNoController.text = address.blockNo ?? '';
        _buildingNoController.text = address.buildingNo ?? '';
        _flatNoController.text = address.flatNo ?? '';
        _floorNoController.text = address.floorNo ?? '';
        _noteController.text = address.notes ?? '';
        selectedCity = address.regionParent?.id;
        selectedRegion = address.region?.id;

        if (selectedCity != null) {
          _shouldLoadRegions = true;
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _blockNoController.dispose();
    _buildingNoController.dispose();
    _flatNoController.dispose();
    _floorNoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    if (_shouldLoadRegions && cubit.cities != null) {
      _shouldLoadRegions = false;
      cubit.getRegions(selectedCity!);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
            child: Text(LocalizationService.translate(StringsManager.addressInformation), style: Theme.of(context).textTheme.titleLarge,),
          ),
        ],
      ),
      body: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state){
          if(state is MainAddAddressSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s20),
            child: Column(
              children: [
                cubit.cities != null && state is !MainGetCitiesLoadingState?
                DefaultPairDropDownMenu(
                  title: StringsManager.cities,
                  items: cubit.cities!.result,
                  selectedItem: selectedCity,
                  onChanged: (value){
                    setState(() {
                      selectedCity = value;
                      selectedRegion = null;
                    });
                    cubit.getRegions(selectedCity!);
                  }
                ) : Center(child: CircularProgressIndicator(),),
                if(selectedCity != null)
                SizedBox(height: AppSizesDouble.s10,),
                if(selectedCity != null)
                  cubit.regions != null?
                  DefaultPairDropDownMenu(
                    selectedItem: selectedRegion,
                    items: cubit.regions!.result,
                    title: StringsManager.region,
                    onChanged: (value) {
                      setState(() {
                        selectedRegion = value;
                      });
                    }
                  ): Center(child: CircularProgressIndicator(),),
                SizedBox(height: AppSizesDouble.s10,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DefaultTextInputField(
                        controller: _blockNoController,
                        obscured: false,
                        hintText: StringsManager.blockNumber,
                        borderColor: ColorsManager.grey3,
                        isOutlined: true,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value != null && value.isEmpty){
                            return LocalizationService.translate(StringsManager.emptyFieldMessage);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      DefaultTextInputField(
                        controller: _streetController,
                        obscured: false,
                        hintText: StringsManager.street,
                        borderColor: ColorsManager.grey3,
                        isOutlined: true,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value != null && value.isEmpty){
                            return LocalizationService.translate(StringsManager.emptyFieldMessage);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      DefaultTextInputField(
                        controller: _buildingNoController,
                        obscured: false,
                        hintText: StringsManager.buildingNumber,
                        borderColor: ColorsManager.grey3,
                        isOutlined: true,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value != null && value.isEmpty){
                            return LocalizationService.translate(StringsManager.emptyFieldMessage);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      DefaultTextInputField(
                        controller: _floorNoController,
                        obscured: false,
                        hintText: StringsManager.floorNumber,
                        borderColor: ColorsManager.grey3,
                        isOutlined: true,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value != null && value.isEmpty){
                            return LocalizationService.translate(StringsManager.emptyFieldMessage);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizesDouble.s10,),
                      DefaultTextInputField(
                        controller: _flatNoController,
                        obscured: false,
                        hintText: StringsManager.flatNumber,
                        borderColor: ColorsManager.grey3,
                        isOutlined: true,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value != null && value.isEmpty){
                            return LocalizationService.translate(StringsManager.emptyFieldMessage);
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                ),
                SizedBox(height: AppSizesDouble.s10,),
                DefaultTextInputField(
                  controller: _noteController,
                  obscured: false,
                  maxLines: 5,
                  hintText: StringsManager.notes,
                  borderColor: ColorsManager.grey3,
                  isOutlined: true,
                ),
                SizedBox(height: AppSizesDouble.s10,),
                DefaultAuthButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      if(isEdit){
                        cubit.editAddress(
                          regionId: selectedRegion!,
                          id: id!,
                          blockNo: _blockNoController.text.trim(),
                          buildingNo: _buildingNoController.text.trim(),
                          flatNo: _flatNoController.text.trim(),
                          floorNo: _floorNoController.text.trim(),
                          street: _streetController.text.trim(),
                          notes: _noteController.text.trim()
                        );
                      } else{
                        if(selectedCity != null && selectedRegion != null){
                          log(selectedRegion.toString());
                          cubit.addAddress(
                            regionId: selectedRegion!,
                            cityId: selectedCity!,
                            blockNo:_blockNoController.text.trim(),
                            buildingNo: _buildingNoController.text.trim(),
                            flatNo: _flatNoController.text.trim(),
                            floorNo: _floorNoController.text.trim(),
                            street: _streetController.text.trim(),
                            notes: _noteController.text.trim()
                          );
                        } else{
                          if(selectedCity == null){
                            showToastMessage(msg: 'select a city first', toastState: ToastState.warning);
                          } else {
                            showToastMessage(msg: 'select a region first', toastState: ToastState.warning);
                          }
                        }
                      }
                    }
                  },
                  title: 'Save Address',
                  hasBorder: false,
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: ColorsManager.white,
                  height: AppSizesDouble.s60,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
