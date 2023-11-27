import 'package:efms/Urls/URLS.dart';
import 'package:efms/Utils/AppUtils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:efms/Other/Constants.dart';

String string_response = "";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isEmailValid = true;
  bool accepted = false;
  bool _isObscure = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 25, right: 25, bottom: 10),
              child: Column(
                children: [
                  Text(
                    'Sign up',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: "Manrope"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontFamily: "Manrope"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Create your new account.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontFamily: "Manrope"),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'First Name',
                          prefixIcon: Icon(LineAwesomeIcons.user),
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.cornerRadius))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Last name',
                          prefixIcon: Icon(LineAwesomeIcons.user),
                          labelText: 'Last name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.cornerRadius))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Email',
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                          hintText: 'xyz@gmail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.cornerRadius))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
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
                        prefixIcon: Icon(Icons.fingerprint),
                        hintText: 'Enter secure password',
                        // Add a suffix icon for the eye toggle button
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter 10 digit phone no',
                          prefixIcon: Icon(LineAwesomeIcons.phone),
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.cornerRadius))),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: Constants.inputFieldHeight,
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter a valid address',
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.cornerRadius))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: accepted,
                          onChanged: (bool? newValue) {
                            setState(() {
                              accepted = newValue!;
                            });
                          },
                          activeColor: Colors.red,
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to your ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Manrope",
                                  ), // Default text color
                                ),
                                TextSpan(
                                  text: 'privacy policy ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        "Manrope", // Red color for clickable text
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      AppUtils.showToastMessage(
                                          context, 'coming soon');
                                    },
                                ),
                                TextSpan(
                                  text: 'and ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Manrope",
                                  ), // Default text color
                                ),
                                TextSpan(
                                  text: 'terms and conditions',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        "Manrope", // Red color for clickable text
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      AppUtils.showToastMessage(
                                          context, 'coming soon');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: Constants.commonHeightMedium,
                    width: 365,
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.cornerRadius),
                            ),
                            elevation: 5),
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          verifyFields();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text(
                          'Already an account, login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: "Manrope",
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void verifyFields() {
    validateEmail();
    if (firstNameController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "First name is missing");
    } else if (lastNameController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "Last name is missing");
    } else if (emailController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "Email is missing");
    } else if (!isEmailValid) {
      AppUtils.showToastMessage(context, "Enter a valid email");
    } else if (passwordController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "Password is missing");
    } else if (phoneController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "Phone no is missing");
    } else if (phoneController.text.toString().length < 10) {
      AppUtils.showToastMessage(context, "Phone number should be 10 digit long");
    } else if (addressController.text.toString().isEmpty) {
      AppUtils.showToastMessage(context, "Address is missing");
    } else if (!accepted) {
      AppUtils.showToastMessage(context, "Accept terms and condition");
    } else {
      signUp(
          firstNameController.text.toString().trim(),
          lastNameController.text.toString().trim(),
          emailController.text.toString().trim(),
          passwordController.text.toString().trim(),
          phoneController.text.toString().trim(),
          addressController.text.toString().trim());
    }
  }

  void signUp(firstName, lastName, email, password, phone, address) async {
    AppUtils.showProgressDialog(context, 'Loading Please wait....');
    Map<String, String> form_data;
    final url = Uri.parse(URLS.signup);
    http.Response response;
    try {
      form_data = {
        'email': email,
        'password': password,
        'access_role': '3',
        'address': address,
        'phone_no': phone,
        'first_name': firstName,
        'last_name': lastName,
      };

      response = await http.post(url, body: form_data);
      print(form_data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        AppUtils.hideProgressDialog(context);
        setState(() async {
          string_response = response.body;
          AppUtils.showToastMessage(context, 'Welcome Suraj Kumar');
          print(string_response);
          var pref = await SharedPreferences.getInstance();
          pref.setString("email", email);
          Navigator.pushNamed(context, 'verify_otp');
        });
      } else if (response.statusCode == 208) {
        AppUtils.hideProgressDialog(context);
        AppUtils.showToastMessage(context, 'User already exist');
      } else {
        AppUtils.showToastMessage(context, 'Something went wrong');
      }
    } catch (e) {
      AppUtils.hideProgressDialog(context);
    }
  }
}
