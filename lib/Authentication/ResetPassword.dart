import 'package:efms/Other/Constants.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Urls/URLS.dart';
import '../Utils/AppUtils.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  top: 160,
                  bottom: 0), // Adjust top padding
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/otp.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Reset Password', // Your login text
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,fontFamily: "Manrope",
                        fontStyle:
                            FontStyle.italic // Adjust the color as needed
                        ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Please select a strong password', // Your login text
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87 ,fontFamily: "Manrope",
                        fontStyle:
                        FontStyle.italic // Adjust the color as needed
                    ) , textAlign: TextAlign.center,
                  ), SizedBox(height: 30,),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'New Password',
                      prefixIcon: Icon(LineAwesomeIcons.key),
                      hintText: 'Abcd@12345',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Constants.cornerRadius)),
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(LineAwesomeIcons.key),
                      hintText: 'Abcd@12345',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
              width: 360,
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 35.0, right: 10, left: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.cornerRadius),
                      ),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Manrope",),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      changePassword();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changePassword() {
    if (passwordController.text.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter new password");
    } else if (confirmPasswordController.text.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter confirm password");
    } else if (passwordController.text.toString() !=
        confirmPasswordController.text.toString()) {
      Fluttertoast.showToast(msg: "Confirm password and new password should be same");
    } else {
      resetPassword(passwordController.text.toString());
    }
  }

  void resetPassword(new_password) async {
    bool isConnected = await AppUtils.isInternetConnected();
    if (!isConnected) {
      AppUtils.showToastMessage(context, 'No internet connection');
    } else {
      var email;
      AppUtils.showProgressDialog(context, 'Loading Please wait....');
      Map<String, String> formData;
      final url = Uri.parse(URLS.reset_password);
      print(url);
      var shared_preferences = await SharedPreferences.getInstance();
      email = shared_preferences.getString('email');
      formData = {
        'email': email,
        'new_password': new_password,
      };
      http.Response response;
      try {
        response = await http.post(url, body: formData);
        print(formData);
        if (response.statusCode == 200) {
          AppUtils.hideProgressDialog(context);
          Navigator.pop(context);
          AppUtils.showToastMessage(context, 'Password reset successfully please login to your account');
          setState(() async {
            Navigator.pushNamed(context, 'login');
          });
        } else {
          AppUtils.hideProgressDialog(context);
          AppUtils.showToastMessage(context, 'Something Went Wrong');
        }
      } catch (e) {
        AppUtils.hideProgressDialog(context);
      }
    }
  }
}
