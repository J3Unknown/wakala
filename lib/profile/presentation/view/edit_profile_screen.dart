import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/data/create_password_screen_arguments.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
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
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _fullNameController = TextEditingController();
    _bioController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _formKey = GlobalKey();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: InkWell(
                splashColor: ColorsManager.transparent,
                onTap: (){},
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    SizedBox(
                      width: AppSizesDouble.s100,
                      height: AppSizesDouble.s100,
                      child: ClipOval(
                        child: Repo.profileDataModel!.result!.image != null? Image.network(Repo.profileDataModel!.result!.image!, fit: BoxFit.cover,):SvgPicture.asset(AssetsManager.defaultAvatar)
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
            SizedBox(height: AppSizesDouble.s15,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DefaultTextInputField(
                    controller: _fullNameController,
                    hintText: StringsManager.fullName,
                    validator: (String? value){
                      if(value!.isEmpty) {
                        return LocalizationService.translate(StringsManager.emptyFieldMessage);
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizesDouble.s20,),
                  DefaultTextInputField(
                    controller: _bioController,
                    hintText: StringsManager.bio,
                  ),
                  SizedBox(height: AppSizesDouble.s20,),
                  DefaultTextInputField(
                    controller: _dateOfBirthController,
                    hintText: StringsManager.dateOfBirth,
                  ),
                  SizedBox(height: AppSizesDouble.s20,),
                  DefaultTextInputField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: StringsManager.hintText,
                    validator: (String? value){
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizesDouble.s10,),
                  DefaultTextInputField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: StringsManager.email,
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
