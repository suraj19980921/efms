class URLS {

  static const String baseUrl = 'http://192.168.40.70:8000/user';

  static const String login = '$baseUrl/login/';
  static const String signup = '$baseUrl/signup/';
  static const String verify_otp = '$baseUrl/verify_otp/?action=forgot_password';
  static const String forgot_password = '$baseUrl/forgot_password/';
  static const String logout = '$baseUrl/logout/';
  static const String reset_password = '$baseUrl/set_new_password/';

}