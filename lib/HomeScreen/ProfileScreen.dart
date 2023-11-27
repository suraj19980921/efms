import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:efms/Urls/URLS.dart';
import 'package:http/http.dart' as http;
import 'package:efms/Other/Constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/AppUtils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isObscure = true;
  File? image;

  Future pickImages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final temp_image = File(image.path);
      setState(() => this.image = temp_image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 60, right: 25, left: 25, bottom: 10),
          child: Column(
            children: [
              Text('Fill Your Profile',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: "Manrope",
                  )),
              SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 4, // Adjust the border width as needed
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(110),
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ) // Display the picked image if available
                            : Image.asset(
                                Constants.photo,
                                fit: BoxFit.cover,
                              ), // Display the default asset image
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        pickImages();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(110),
                          color: Colors.red,
                        ),
                        child: Icon(LineAwesomeIcons.pen,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    Container(
                      height: Constants.inputFieldHeight,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          labelText: 'Full Name',
                          prefixIcon: Icon(LineAwesomeIcons.user),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: Constants.inputFieldHeight,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          labelText: 'Email',
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: Constants.inputFieldHeight,
                      child: TextFormField(
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          labelText: 'Phone No',
                          prefixIcon: Icon(LineAwesomeIcons.phone),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: Constants.inputFieldHeight,
                      child: TextFormField(
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          labelText: 'Password',
                          prefixIcon: Icon(LineAwesomeIcons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Toggle the password visibility
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: Constants.inputFieldHeight,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          labelText: 'Address',
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: Constants.commonHeightMedium,
                      width: 360,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Manrope"),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: Constants.commonHeightMedium,
                      width: 360,
                      child: ElevatedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.cornerRadius),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Manrope"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                initiateLogoutProcess();
              },
              child: Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void initiateLogoutProcess() async {
    Navigator.pop(context);
    bool isConnected = await AppUtils.isInternetConnected();
    if (!isConnected) {
      Fluttertoast.showToast(msg: 'No internet connection');
    } else {
      AppUtils.showProgressDialog(context, 'Loading Please wait....');
      var refresh_token;
      Map<String, String> form_data;
      var shared_preferences = await SharedPreferences.getInstance();
      refresh_token = shared_preferences.getString('refresh_token');
      print('received refresh token $refresh_token');
      form_data = {'refresh': refresh_token};
      print('form data $form_data');
      final url = Uri.parse(URLS.logout);
      print('url is - $url');
      http.Response response;
      try {
        AppUtils.hideProgressDialog(context);
        response = await http.post(url, body: form_data);
        print('response is $response');
        if (response.statusCode == 200) {
          print('success');
          shared_preferences.remove('refresh_token');
          Navigator.pushNamed(context, 'login');
        } else {
          AppUtils.showToastMessage(context, 'Something went wrong');
        }
      } catch (e) {
        print(e.toString());
        AppUtils.hideProgressDialog(context);
      }
    }
  }
}
