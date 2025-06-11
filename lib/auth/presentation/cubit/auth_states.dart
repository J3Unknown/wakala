abstract class AuthStates{}

final class AuthInitialState extends AuthStates{}

final class AuthChangeObscureState extends AuthStates{}

final class AuthStartTimerState extends AuthStates{
  final int initialTime;
  AuthStartTimerState({required this.initialTime});
}

final class AuthFinishTimerState extends AuthStates{}

final class AuthSendingOtpCodeLoadingState extends AuthStates{}

final class AuthSendingOtpCodeSuccessState extends AuthStates{}

final class AuthSendingOtpCodeErrorState extends AuthStates{}

final class AuthLoginLoadingState extends AuthStates{}

final class AuthLoginSuccessState extends AuthStates{}

final class AuthLoginErrorState extends AuthStates{}

final class AuthSignUpLoadingState extends AuthStates{}

final class AuthSignUpSuccessState extends AuthStates{}

final class AuthResetPasswordLoadingState extends AuthStates{}

final class AuthResetPasswordSuccessState extends AuthStates{}