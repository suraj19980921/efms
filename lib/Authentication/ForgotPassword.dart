import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Urls/URLS.dart';
import '../Utils/AppUtils.dart';
import 'package:efms/Other/Constants.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isEmailValid = true;
  TextEditingController emailController = TextEditingController();

  void validateEmail() {
    setState(() {
      isEmailValid = EmailValidator.validate(emailController.text.toString().trim());
    });
  }

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
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 10),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                "Forgot Password",
                style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "Manrope",),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Don't worry make new password in two easy steps",
                style: TextStyle(
                  fontSize: 18, fontFamily: "Manrope",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Constants.cornerRadius),),
                  labelText: 'Email',
                  prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                  hintText: 'abc@gmail.com',
                ),
              ),
              SizedBox(
                height: 35,
              ),
              SizedBox(
                width: double.infinity,
                height: Constants.commonHeightMedium,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constants.cornerRadius))),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    validateEmail();
                    if (emailController.text.toString().isEmpty) {
                      AppUtils.showToastMessage(context, 'Email is missing');
                    } else if (!isEmailValid) {
                      AppUtils.showToastMessage(context, 'Enter a valid email');
                    } else {
                      Navigator.pushNamed(context, 'verify_otp');
                      //resetPassword(emailController.text.toString().trim());
                    }
                  },
                  child: Text(
                    "Get Otp",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Manrope",),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    bool isConnected = await AppUtils.isInternetConnected();
    if (!isConnected) {
      AppUtils.showToastMessage(context, 'No internet connection');
    } else {
      AppUtils.showProgressDialog(context, "Please Wait");
      final url = Uri.parse(URLS.forgot_password);
      print(url);
      http.Response response;
      try {
        response = await http.post(url, body: {'email': email});
        if (response.statusCode == 200) {
          AppUtils.hideProgressDialog(context);
          setState(() async {
            var shared_preferences = await SharedPreferences.getInstance();
            shared_preferences.setString('email', email);
            AppUtils.showToastMessage(context, "Otp sent successfully");
            Navigator.pushNamed(context, 'verify_otp');
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: "Wrong credential");
        }
      } catch (e) {
        AppUtils.hideProgressDialog(context);
      }
    }
  }
}

