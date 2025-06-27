import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class AddAuctionAlert extends StatefulWidget {
  const AddAuctionAlert({super.key, required this.adId, required this.lowestAuctionPrice});
  final int lowestAuctionPrice;
  final int adId;

  @override
  State<AddAuctionAlert> createState() => _AddAuctionAlertState();
}

class _AddAuctionAlertState extends State<AddAuctionAlert> {
  final TextEditingController _auctionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: BlocListener(
        bloc: MainCubit.get(context),
        listener: (context, state) {
          if(state is MainSaveAuctionSuccessState){
            if(mounted){
              Navigator.of(context).pop('added');
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: DefaultTextInputField(
                controller: _auctionController,
                borderColor: ColorsManager.grey5,
                keyboardType: TextInputType.number,
                obscured: false,
                hintText: LocalizationService.translate(StringsManager.putAuctionPrice),
                isOutlined: true,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return LocalizationService.translate(StringsManager.emptyFieldMessage);
                  } else if(int.parse(_auctionController.text) < widget.lowestAuctionPrice){
                    return LocalizationService.translate(StringsManager.auctionPriceWarning);
                  }
                  return null;
                },
              ),
            ),
            Text(
              '${StringsManager.lowestAuctionPrice} ${widget.lowestAuctionPrice} ${StringsManager.egp}',
              style: TextStyle(
                color: ColorsManager.deepRed
              ),
            )
          ],
        ),
      ),
      actions: [
        DefaultAuthButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              MainCubit.get(context).saveAuction(widget.adId, int.parse(_auctionController.text));
            }
          },
          title: StringsManager.addAuction,
          icon: AssetsManager.auction,
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: ColorsManager.white,
          hasBorder: false,
          height: AppSizesDouble.s60,
        )
      ],
      backgroundColor: ColorsManager.white,
    );
  }
}
