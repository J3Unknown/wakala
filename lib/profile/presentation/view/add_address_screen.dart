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

  late final TextEditingController _streetController;
  late final TextEditingController _blockNoController;
  late final TextEditingController _buildingNoController;
  late final TextEditingController _flatNoController;
  late final TextEditingController _floorNoController;
  late final TextEditingController _noteController;

  @override
  void initState() {
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
    AddAddressArguments? args = ModalRoute.of(context)!.settings.arguments as AddAddressArguments?;
    if(args != null){
      isEdit = args.isEdit;
      if(args.address != null){
        id = args.address?.id;
        _streetController = TextEditingController(text: args.address?.street);
        selectedCity = args.address?.regionParent!.id;
        selectedRegion = args.address?.region!.id;
        _blockNoController = TextEditingController(text: args.address?.blockNo);
        _buildingNoController = TextEditingController(text: args.address?.buildingNo);
        _flatNoController = TextEditingController(text: args.address?.flatNo);
        _floorNoController = TextEditingController(text: args.address?.floorNo);
        _noteController = TextEditingController(text: args.address?.notes);
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
          if(state is MainGetCitiesSuccessState && isEdit){
            MainCubit.get(context).getRegions(selectedCity!);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s20),
          child: Column(
            children: [
              cubit.cities != null?
              DefaultPairDropDownMenu(
                title: StringsManager.cities,
                items: cubit.cities!.result,
                selectedItem: selectedCity,
                onChanged: (value){
                  setState(() {
                    selectedCity = value;
                  });
                  cubit.getRegions(selectedCity!);
                }
              ) :
              Center(child: CircularProgressIndicator(),),
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
                ):
                Center(child: CircularProgressIndicator(),),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _blockNoController,
                obscured: false,
                hintText: 'Block Number',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _streetController,
                obscured: false,
                hintText: 'Street',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _buildingNoController,
                obscured: false,
                hintText: 'Building Number',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _floorNoController,
                obscured: false,
                hintText: 'Floor Number',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _flatNoController,
                obscured: false,
                hintText: 'Flat Number',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultTextInputField(
                controller: _noteController,
                obscured: false,
                maxLines: 5,
                hintText: 'Notes',
                borderColor: ColorsManager.grey3,
                isOutlined: true,
              ),
              SizedBox(height: AppSizesDouble.s10,),
              DefaultAuthButton(
                onPressed: (){ //TODO: Add the EDIT functionalities
                  if(isEdit){
                    cubit.editAddress(
                      regionId: selectedRegion!,
                      id: id!,
                      blockNo: _blockNoController.text.isNotEmpty?int.parse(_blockNoController.text):null,
                      buildingNo: _buildingNoController.text.isNotEmpty?int.parse(_buildingNoController.text):null,
                      flatNo: _flatNoController.text.isNotEmpty?int.parse(_flatNoController.text):null,
                      floorNo: _floorNoController.text.isNotEmpty?int.parse(_floorNoController.text):null,
                      street: _streetController.text,
                      notes: _noteController.text
                    );
                  } else{
                    if(selectedCity != null && selectedRegion != null){
                      cubit.addAddress(
                        cityId: selectedCity!,
                        regionId: selectedRegion!,
                        blockNo: _blockNoController.text.isNotEmpty?int.parse(_blockNoController.text):null,
                        buildingNo: _buildingNoController.text.isNotEmpty?int.parse(_buildingNoController.text):null,
                        flatNo: _flatNoController.text.isNotEmpty?int.parse(_flatNoController.text):null,
                        floorNo: _floorNoController.text.isNotEmpty?int.parse(_floorNoController.text):null,
                        street: _streetController.text,
                        notes: _noteController.text
                      );
                    } else{
                      if(selectedCity == null){
                        showToastMessage(msg: 'select a city first', toastState: ToastState.warning);
                      } else {
                        showToastMessage(msg: 'select a region first', toastState: ToastState.warning);
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
        ),
      ),
    );
  }
}
