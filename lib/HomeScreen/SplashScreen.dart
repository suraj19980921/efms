import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, 'login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_screen.png'), // Path to your background image
            fit: BoxFit.cover, // You can adjust the BoxFit as needed
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 100.0), // Add a bottom margin
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircularProgressIndicator(), // Display a progress indicator
                      SizedBox(height: 16.0), // Add some spacing
                      Text('Please wait...'), // Add a loading text
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
