import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/auth/presentation/cubit/auth_states.dart';

import '../../../utilities/resources/values_manager.dart';

class AuthCubit extends Cubit<AuthStates>{

  AuthCubit() : super(AuthInitialState());
  
  static AuthCubit get(context) => BlocProvider.of(context);
  
  bool isObscured = true;
  late bool canResendCode;

  int counter = AppSizes.s60;
  late Stream<int> _timerStream;
  late StreamController<int> _timerStreamController;
  Timer? _timer;

  Stream<int> get timerStream => _timerStream;

  void initializeStream() {
    _timerStreamController = StreamController<int>.broadcast();
    _timerStream = _timerStreamController.stream;
    canResendCode = false;
    _counter();
  }

  void _counter() {
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

  void sendVerificationCode(){
    _counter();
  }

  void changeObscured(){
    isObscured = !isObscured;
    emit(AuthChangeObscureState());
  }
}