import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/local/shared_preferences.dart';
import 'package:wakala/utilities/network/dio.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';

import '../../../utilities/resources/repo.dart';
import '../../../utilities/resources/values_manager.dart';

class AuthCubit extends Cubit<AuthStates>{

  AuthCubit() : super(AuthInitialState());
  
  static AuthCubit get(context) => BlocProvider.of(context);
  
  bool isObscured = true;
  late bool canResendCode;

  int? otpCode;

  int counter = AppSizes.s60;
  late Stream<int> _timerStream;
  late StreamController<int> _timerStreamController;
  Timer? _timer;

  Stream<int> get timerStream => _timerStream;

  void initializeStream() {
    _timerStreamController = StreamController<int>.broadcast();
    _timerStream = _timerStreamController.stream;
    canResendCode = false;
  }

  void timer() {
    _timer?.cancel();
    canResendCode = false;
    counter = AppSizes.s60;

    _timerStreamController.add(counter);
    _timer = Timer.periodic(Duration(seconds: AppSizes.s1), (timer) {
      counter--;
      _timerStreamController.add(counter);
      if (counter <= AppSizes.s0) {
        timer.cancel();
        canResendCode = true;
        emit(AuthFinishTimerState());
      }
    });
    emit(AuthStartTimerState(initialTime: counter));
  }

  @override
  Future<void> close(){
    if(_timer!.isActive){
      _timer?.cancel();
    }
    if (!_timerStreamController.isClosed) {
      _timerStreamController.close();
    }
    return super.close();
  }

  void sendVerificationCode(String phoneNumber) {
    emit(AuthSendingOtpCodeLoadingState());
    DioHelper.postData(url: EndPoints.sendOtpRegister, data: {KeysManager.phone:phoneNumber}).then((value){
      if(value.data[KeysManager.success]){
        otpCode = value.data[KeysManager.result][KeysManager.otpCode];
        //log(otpCode.toString());
        emit(AuthSendingOtpCodeSuccessState());
      } else {
        emit(AuthSendingOtpCodeErrorState());
        showToastMessage(
          msg: value.data[KeysManager.msg],
          toastState: ToastState.warning,
        );
      }
    });
  }

  void sendForgotPasswordOtp(String phone){
    emit(AuthSendingOtpCodeLoadingState());
    DioHelper.postData(
      url: EndPoints.sendOtp,
      data: {KeysManager.phone: phone},
    ).then((value){
      if(value.data[KeysManager.success]){
        otpCode = value.data[KeysManager.result][KeysManager.otpUnderscoreCode];
        emit(AuthSendingOtpCodeSuccessState());
      } else {
        showToastMessage(msg: value.data[KeysManager.msg], toastState: ToastState.error);
        emit(AuthSendingOtpCodeErrorState());
      }
    });
  }
  
  void resetPassword({required String phone, required int otpCode, required String password, required String passwordConfirmation}){
    emit(AuthResetPasswordLoadingState());
    DioHelper.postData(
      url: EndPoints.resetPassword,
      data: {
        KeysManager.phone:phone,
        KeysManager.password:password,
        KeysManager.passwordConfirmation:passwordConfirmation,
        KeysManager.otpCode:otpCode
      }
    ).then((value){
      showToastMessage(
        msg: LocalizationService.translate(StringsManager.passwordSetSuccessfully),
        toastState: ToastState.success
      );
    });
  }

  void register({required String phone, required String name, required int otpCode, required String password}){
    emit(AuthSignUpLoadingState());
    DioHelper.postData(
      url: EndPoints.register,
      data: {
        KeysManager.phone: phone,
        KeysManager.password: password,
        KeysManager.name: name,
        KeysManager.type: KeysManager.user,
        KeysManager.otpCode: otpCode
      }
    ).then((value){
      Repo.profileDataModel = ProfileDataModel.fromJson(value.data);
      _loginCaches();
      emit(AuthSignUpSuccessState());
    }).catchError((e){
      showToastMessage(msg: LocalizationService.translate(StringsManager.errorOccurred), toastState: ToastState.error);
    });
  }
  void _loginCaches(){
    CacheHelper.saveData(key: KeysManager.isAuthenticated, value: true);
    AppConstants.isAuthenticated = true;
    CacheHelper.saveData(key: KeysManager.isGuest, value: false);
    AppConstants.isGuest = false;
    CacheHelper.saveData(key: KeysManager.userId, value: Repo.profileDataModel!.result!.id);
    AppConstants.userId = Repo.profileDataModel!.result!.id;
    CacheHelper.saveData(key: KeysManager.token, value: Repo.profileDataModel!.result!.token);
    AppConstants.token = Repo.profileDataModel!.result!.token!;
  }

  void login(String phone, String password) {
   var parsedPhone = int.parse(phone);
    emit(AuthLoginLoadingState());
    DioHelper.postData(
      url: EndPoints.login,
      data: {
        KeysManager.phone: parsedPhone,
        KeysManager.password: password
      }
    ).then((value){
      if(value.data[KeysManager.success]){
        Repo.profileDataModel = ProfileDataModel.fromJson(value.data);
        _loginCaches();
        emit(AuthLoginSuccessState());
      } else {
        showToastMessage(msg: "${LocalizationService.translate(StringsManager.couldNotLogin)} ${value.data[KeysManager.msg]}", toastState: ToastState.error);
        emit(AuthLoginErrorState());
      }
    }).catchError((e){
        showToastMessage(msg: LocalizationService.translate(StringsManager.errorInCredentials), toastState: ToastState.error);
        emit(AuthLoginErrorState());
    });
  }

  void changeObscured(){
    isObscured = !isObscured;
    emit(AuthChangeObscureState());
  }
}