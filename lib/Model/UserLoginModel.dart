
class UserLoginModel {
  TokenData? tokenData;
  UserData? userData;

  UserLoginModel({this.tokenData, this.userData});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    tokenData = json['token_data'] != null
        ? new TokenData.fromJson(json['token_data'])
        : null;
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tokenData != null) {
      data['token_data'] = this.tokenData!.toJson();
    }
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }
}

class TokenData {
  String? refresh;
  String? access;

  TokenData({this.refresh, this.access});

  TokenData.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    return data;
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? email;
  int? accessRole;
  String? address;
  int? phoneNo;

  UserData(
      {this.firstName,
        this.lastName,
        this.email,
        this.accessRole,
        this.address,
        this.phoneNo});

  UserData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    accessRole = json['access_role'];
    address = json['address'];
    phoneNo = json['phone_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['access_role'] = this.accessRole;
    data['address'] = this.address;
    data['phone_no'] = this.phoneNo;
    return data;
  }
}