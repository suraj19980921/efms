import 'dart:async';
import 'dart:convert';
import 'package:efms/Other/Constants.dart';
import 'package:efms/Urls/URLS.dart';
import 'package:efms/Utils/AppUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:efms/Other/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

String string_response = "";

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  String otp = " ";
  String? email;
  late Timer _timer;
  int _secondsRemaining = 60; // 1 minute = 60 seconds

  @override
  void initState() {
    super.initState();
    getValue();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    );
    // Color.fromRGBO(114, 178, 238, 1)

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
        margin: EdgeInsets.only(left: 25, right: 25),
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
                "Verify It's You",
                style: TextStyle(color: Colors.red ,fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "Manrope",),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to verify your email before getting started!",
                style: TextStyle(
                  fontSize: 18, fontFamily: "Manrope",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 35,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  otp = pin;
                },
              ),
              SizedBox(
                height: 5,
              ),
              Padding(padding: const EdgeInsets.only(right: 10, left: 50,top: 10, bottom: 0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Text(
                        _secondsRemaining > 0
                            ? "Resend otp in : $_secondsRemaining sec"
                            : "Resend otp",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red, fontFamily: "Manrope",
                        ),
                      ),
                    ),
                  )
                ],
              )),
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
                    if (otp.length == 6) {
                      Navigator.pushNamed(context, 'reset_password');
                      //verifyOtp(otp);
                     } else {
                       Fluttertoast.showToast(msg: 'Please enter a valid otp');
                     }
                  },
                  child: Text(
                    "Verify Otp",
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

  void verifyOtp(String otp) async {
    bool isConnected = await AppUtils.isInternetConnected();
    if (!isConnected) {
      Fluttertoast.showToast(msg: 'No internet connection');
    } else {
      AppUtils.showProgressDialog(context, "Please Wait");
      Map<String, String> formData;
      formData = {
        'email': email.toString(),
        'otp': otp.toString(),
      };
      final url = Uri.parse(URLS.verify_otp);
      print(url);
      http.Response response;
      try {
        response = await http.post(url, body: formData);
        print(formData);
        if (response.statusCode == 200) {
          AppUtils.hideProgressDialog(context);
          setState(() async {
            string_response = response.body;
            Fluttertoast.showToast(msg: "Otp verify successfully");
            print(string_response);
            Navigator.pushNamed(context, 'reset_password');
            Navigator.pop(context);
          });
        } else {
          AppUtils.hideProgressDialog(context);
          Fluttertoast.showToast(msg: "Wrong credential");
        }
      } catch (e) {
        AppUtils.hideProgressDialog(context);
      }
    }
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }
}


