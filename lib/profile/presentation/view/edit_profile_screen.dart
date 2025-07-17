import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';
import '../../../utilities/resources/colors_manager.dart';
import '../../../utilities/resources/components.dart';
import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _bioController;
  String? _dateOfBirth;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final GlobalKey<FormState> _formKey;
  bool isInserted = false;
  @override
  void initState() {
    _formKey = GlobalKey();
    _fullNameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final ProfileDataModel? args = ModalRoute.of(context)!.settings.arguments! as ProfileDataModel?;
    if(args != null && !isInserted){
      _fullNameController.text = args.result!.name;
      _bioController.text =  args.result!.bio??'';
      _dateOfBirth =  DateFormat('yyyy-MM-dd').format(DateTime.parse(args.result!.dateOfBirth??''));
      _phoneController.text = args.result!.phone;
      _emailController.text = args.result!.email??'';
      isInserted = true;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (pop, value){
        MainCubit.get(context).profileImage = null;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
              child: Text(StringsManager.editProfile, style: Theme.of(context).textTheme.titleLarge,),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<MainCubit, MainCubitStates>(
                listener: (context, state){
                  if(state is MainEditAccountSuccessState){
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) => Center(
                  child: InkWell(
                    splashColor: ColorsManager.transparent,
                    onTap: (){
                      MainCubit.get(context).getProfilePhoto();
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        SizedBox(
                          width: AppSizesDouble.s100,
                          height: AppSizesDouble.s100,
                          child: ClipOval(
                            child: Repo.profileDataModel!.result!.image != null || MainCubit.get(context).profileImage != null?
                            (Repo.profileDataModel!.result!.image != null?Image.network(AppConstants.baseImageUrl + Repo.profileDataModel!.result!.image!, fit: BoxFit.cover,):Image.file(MainCubit.get(context).profileImage!, fit: BoxFit.cover,)):
                            SvgPicture.asset(AssetsManager.defaultAvatar)
                          ),
                        ),
                        Positioned(
                          bottom: AppSizesDouble.s5,
                          left: AppSizesDouble.s5,
                          child: CircleAvatar(
                            radius: AppSizesDouble.s12,
                            backgroundColor: ColorsManager.white,
                            child: CircleAvatar(
                              radius: AppSizesDouble.s10,
                              backgroundColor: ColorsManager.primaryColor,
                              child: SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.white, BlendMode.srcIn),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizesDouble.s15,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DefaultTextInputField(
                      controller: _fullNameController,
                      hintText: StringsManager.fullName,
                      obscured: false,
                      validator: (String? value){
                        if(value!.isEmpty) {
                          return LocalizationService.translate(StringsManager.emptyFieldMessage);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizesDouble.s20,),
                    DefaultTextInputField(
                      obscured: false,
                      controller: _bioController,
                      hintText: StringsManager.bio,
                      validator: (value){
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizesDouble.s20,),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now()
                        ).then((value){
                          if(value != null){
                            setState(() {
                              _dateOfBirth = '';
                              _dateOfBirth = DateFormat('yyyy-MM-dd').format(value);
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(AppPaddings.p10),
                        alignment: AlignmentDirectional.centerStart,
                        height: AppSizesDouble.s57,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizesDouble.s8),
                          color: ColorsManager.loginButtonBackgroundColor
                        ),
                        child: Text(
                          _dateOfBirth??LocalizationService.translate(StringsManager.dateOfBirth),
                          style: TextStyle(color: _dateOfBirth == null?ColorsManager.grey2:ColorsManager.black),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizesDouble.s20,),
                    DefaultTextInputField(
                      obscured: false,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      hintText: StringsManager.hintText,
                      validator: (String? value){
                        if(value == null || value.isEmpty){
                          return LocalizationService.translate(StringsManager.emptyFieldMessage);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizesDouble.s10,),
                    DefaultTextInputField(
                      obscured: false,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: StringsManager.emailPlaceholder,
                      validator: (value){
                        if(value != null && !value.contains(AppConstants.emailRegex)){
                          return '${LocalizationService.translate(StringsManager.emailFormatWarning)} ${StringsManager.emailPlaceholder}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: TextButton(
                  onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.addressesList))),
                  child: Row(
                    children: [
                      SvgPicture.asset(AssetsManager.add, colorFilter: ColorFilter.mode(ColorsManager.primaryColor, BlendMode.srcIn),),
                      Text(LocalizationService.translate(StringsManager.addAddress), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.primaryColor),)
                    ],
                  )
                ),
              ),
              DefaultAuthButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    MainCubit.get(context).editProfile(
                      name: _fullNameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      image: MainCubit.get(context).profileImage,
                      bio: _bioController.text,
                      dateOfBirth: _dateOfBirth!
                    );
                  }
                },
                title: StringsManager.save,
                height: AppSizesDouble.s60,
                hasBorder: false,
                backgroundColor: ColorsManager.primaryColor,
                foregroundColor: ColorsManager.white,
              ),
              SizedBox(height: AppSizesDouble.s20,),
              _buildCreatePasswordButton(context),
              IntrinsicWidth(
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DeleteAccountAlert()
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AssetsManager.trash,),
                      Text(LocalizationService.translate(StringsManager.deleteMyAccount), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: ColorsManager.red),)
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildCreatePasswordButton(BuildContext context) {
    return SizedBox(
      height: AppSizesDouble.s60,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context, RoutesGenerator.getRoute(
            RouteSettings(
              name: Routes.createPassword,
            )
          )
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizesDouble.s10),
            side: BorderSide(color: ColorsManager.grey2, width: AppSizesDouble.s2),
          ),
          backgroundColor: ColorsManager.white,
          elevation: AppSizesDouble.s0,
          padding: EdgeInsets.all(AppPaddings.p15)
        ),
        child: Row(
          children: [
            SvgPicture.asset(AssetsManager.eyeVisibilityOff),
            SizedBox(width: AppSizesDouble.s8,),
            FittedBox(child: Text(LocalizationService.translate(StringsManager.createPassword), style: Theme.of(context).textTheme.titleMedium,)),
            Spacer(),
            Icon(IconsManager.rightArrow),
          ],
        ),
      ),
    );
  }
}
