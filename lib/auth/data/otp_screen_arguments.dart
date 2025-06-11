class OtpScreenArguments{
  final String phone;
  final String password;
  final String name;
  final bool isResetPassword;

  OtpScreenArguments(this.phone, this.isResetPassword, {this.password = '', this.name = ''});
}