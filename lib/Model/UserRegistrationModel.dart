class UserRegistrationModel {
  int? otp;
  String? userEmail;
  String? successMessage;

  UserRegistrationModel({this.otp, this.userEmail, this.successMessage});

  UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    userEmail = json['user_email'];
    successMessage = json['success_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['user_email'] = this.userEmail;
    data['success_message'] = this.successMessage;
    return data;
  }
}