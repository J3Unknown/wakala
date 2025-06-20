import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/utilities/local/locale_changer.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'colors_manager.dart';

class LoginAlert extends StatelessWidget {
  const LoginAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.white,
      insetPadding: EdgeInsets.all(AppPaddings.p10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s20)
      ),
      title: Text(LocalizationService.translate(StringsManager.login), style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center,),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Text(LocalizationService.translate(StringsManager.loginMessage), style: Theme.of(context).textTheme.headlineSmall,),
          ],
        ),
      ),
      actions: [
        DefaultAuthButton(
          onPressed: () => navigateToAuthLayout(context),
          title: StringsManager.login,
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: ColorsManager.white,
          hasBorder: false,
        ),
        SizedBox(height: AppSizesDouble.s20,),
        DefaultAuthButton(
          onPressed: () => Navigator.of(context).pop(),
          title: StringsManager.cancel,
        ),
      ],
    );
  }
}

/// This Widget is Already done and ready to use
class LanguageAlert extends StatelessWidget {
  const LanguageAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
  final localeModel = Provider.of<LocaleChanger>(context);
  final currentLocale = localeModel.getLanguage;

    return AlertDialog(
      backgroundColor: ColorsManager.white,
      insetPadding: EdgeInsets.all(AppPaddings.p10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s20)
      ),
      content: IntrinsicHeight(
        child: Column(
          children: [
            DefaultLocaleRadioGroupButton(
              value: KeysManager.en,
              title: StringsManager.english,
              currentLocale: currentLocale,
              onChanged: (value) async {
                await MainCubit.get(context).updateLang(KeysManager.en);
                localeModel.changeLocale(KeysManager.en);
              }
            ),
            SizedBox(
              height: AppSizesDouble.s15,
            ),
           DefaultLocaleRadioGroupButton(
             value: KeysManager.ar,
             title: StringsManager.arabic,
             currentLocale: currentLocale,
             onChanged: (value) async {
               await MainCubit.get(context).updateLang(KeysManager.ar);
               localeModel.changeLocale(KeysManager.ar);
             }
           )
          ],
        ),
      ),
    );
  }
}
/// This Widget is Already done and ready to use
class DefaultLocaleRadioGroupButton extends StatelessWidget {
  const DefaultLocaleRadioGroupButton({super.key, required this.value, required this.title, required this.currentLocale, required this.onChanged});
  final String title;
  final String currentLocale;
  final String value;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizesDouble.s50,
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: ColorsManager.loginButtonBackgroundColor,
        border: Border.all(color: ColorsManager.grey),
        borderRadius: BorderRadius.circular(AppSizesDouble.s8),
      ),
      child: Row(
        children: [
          Text(title),
          Spacer(),
          Radio<String>.adaptive(
            activeColor: ColorsManager.primaryColor,
            value: value,
            groupValue: currentLocale,
            onChanged: (value) => onChanged(value),
          ),
        ],
      ),
    );
  }
}

//TODO: Adjust the logic of notifications after adding one Signal
class NotificationsAlert extends StatefulWidget {
  const NotificationsAlert({
    super.key,
  });

  @override
  State<NotificationsAlert> createState() => _NotificationsAlertState();
}
class _NotificationsAlertState extends State<NotificationsAlert> {
  bool isActivated = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.white,
      insetPadding: EdgeInsets.all(AppPaddings.p10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s20)
      ),
      content: DefaultSwitch(
        isActivated: AppConstants.isNotificationsActive,
        title: StringsManager.notifications,
        onChanged: (value) async{
          await CacheHelper.saveData(key: KeysManager.isNotificationsActive, value: value);
          setState(() => AppConstants.isNotificationsActive = value);
        }
      ),
    );
  }
}

class DeleteAccountAlert extends StatelessWidget {
  const DeleteAccountAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.white,
      insetPadding: EdgeInsets.all(AppPaddings.p10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizesDouble.s20)
      ),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Text(LocalizationService.translate(StringsManager.deleteAccountWarning), style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
          ],
        ),
      ),
      actions: [
        DefaultAuthButton(
          onPressed: () => MainCubit.get(context).deleteAccount(context),
          title: LocalizationService.translate(StringsManager.deleteAccount),
          backgroundColor: ColorsManager.deepRed,
          foregroundColor: ColorsManager.white,
          hasBorder: false,
        ),
        SizedBox(height: AppSizesDouble.s20,),
        DefaultAuthButton(
          onPressed: () => Navigator.of(context).pop(),
          title: LocalizationService.translate(StringsManager.cancel),
        ),
      ],
    );
  }
}