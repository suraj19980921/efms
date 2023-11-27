import 'dart:convert';
import 'package:efms/Model/UserLoginModel.dart';
import 'package:efms/Urls/URLS.dart';
import 'package:efms/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:efms/Other/Constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  bool _isObscure = true;
  late UserLoginModel user_login_model;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  top: 80,
                  bottom: 0), // Adjust top padding
              child: Column(
                children: [
                  Text(
                    'Sign in', textAlign: TextAlign.start, // Your login text
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: "Manrope",
                    ),
                  ),
                  SizedBox(height: 80),
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      fontFamily: "Manrope", // Adjust the color as needed
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Login to your account.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontFamily: "Manrope", // Adjust the color as needed
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius)),
                        labelText: 'Email or Phone',
                        prefixIcon: Icon(LineAwesomeIcons.user),
                        hintText: 'xyz@gmail.com',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 20,
                bottom: 0,
              ),
              child: Container(
                height:
                    Constants.inputFieldHeight, // Set the desired height here
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  // Toggle the obscureText property
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Constants.cornerRadius),
                    ),
                    labelText: 'Password',
                    prefixIcon: Icon(LineAwesomeIcons.key),
                    hintText: 'Enter secure password',
                    // Add a suffix icon for the eye toggle button
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Toggle the password visibility
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 25, top: 18, bottom: 0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'forgot_password');
                      },
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontFamily: "Manrope",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: Constants.commonHeightLarge,
              width: 360,
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 10, left: 10),
                  child: CupertinoButton(
                    color: Colors.red,
                    // Set the button's background color
                    borderRadius: BorderRadius.circular(Constants.cornerRadius),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pushNamed(context, 'home_page');
                      //verifyFields();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Manrope",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'register');
              },
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account, ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: "Manrope",
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontFamily: "Manrope",
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void verifyFields() {
    if (emailController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, 'Username is missing');
    } else if (passwordController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, 'Password is missing');
    } else {
      login(emailController.text.toString().trim(), passwordController.text.toString().trim());
    }
  }

  void login(email, password) async {
    bool isConnected = await AppUtils.isInternetConnected();
    if (!isConnected) {
      AppUtils.showToastMessage(context, 'No internet connection');
    } else {
      AppUtils.showProgressDialog(context, 'Loading Please wait....');
      Map<String, String> formData;
      final url = Uri.parse(URLS.login);
      print(url);
      formData = {
        'email': emailController.text.toString(),
        'password': passwordController.text.toString(),
      };
      http.Response response;
      try {
        AppUtils.hideProgressDialog(context);
        response = await http.post(url, body: formData);
        print(formData);
        if (response.statusCode == 200) {
          Navigator.pop(context);
          setState(() async {
            user_login_model = UserLoginModel.fromJson(json.decode(response.body));
            print('response body is $response.body');
            AppUtils.showToastMessage(context, 'Welcome ${user_login_model.userData?.firstName} '
                '${user_login_model.userData?.lastName}');
            var shared_preferences = await SharedPreferences.getInstance();
            Map<String, dynamic> data = jsonDecode(response.body);
            String refreshToken = data['token_data']['refresh'];
            print('Refresh Token is -: $refreshToken');
            shared_preferences.setString('refresh_token', refreshToken);
            print(shared_preferences.get('refresh_token'));
            Navigator.pushNamed(context, 'home_page');
          });
        } else {
          AppUtils.showToastMessage(context, 'Wrong credential');
        }
      } catch (e) {
        AppUtils.hideProgressDialog(context);
      }
    }
  }
}
