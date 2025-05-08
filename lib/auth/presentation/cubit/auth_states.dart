abstract class AuthStates{}

final class AuthInitialState extends AuthStates{}

final class AuthChangeObscureState extends AuthStates{}

final class AuthStartTimerState extends AuthStates{
  final int initialTime;
  AuthStartTimerState({required this.initialTime});
}

final class AuthFinishTimerState extends AuthStates{}