import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/features/home/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await AuthService().isLoggedIn();
    if (loggedIn) {
      // Navigate to the home/dashboard employeeScreen
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Stay on the login employeeScreen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or any preferred color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            Text(
              "to Kormi Sheba!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            // Use your splash-screen-image as the main image
            Image.asset(
              'assets/images/splash_images/splash-employeeScreen-image.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 110),
            // Use your splash-top-icon below the main image or as a logo
            Image.asset(
              'assets/images/splash_images/splash-top-icon.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),const SizedBox(height: 5),
            Text(
              "Developed by",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
            ),
            Text(
              "MD. RAJU AHMED",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
