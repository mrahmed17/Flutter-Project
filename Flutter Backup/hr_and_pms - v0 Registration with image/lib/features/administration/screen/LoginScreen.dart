import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_and_pms/features/administration/screen/AdminScreen.dart';
import 'package:hr_and_pms/features/administration/screen/RegistrationScreen.dart';
import 'package:hr_and_pms/features/administration/service/AuthService.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final storage = FlutterSecureStorage();

  AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);

      //successful login, role-based navigation
      final role = await authService.getUserRole(); //get role from authService

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else if (role == 'MANAGER') {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ManagerProfilePage(
        //       managerName: "Manager Demo",
        //       managerImageUrl: "http://localhost:8080/images/manager/The *****",
        //     ),
        //   ),
        // );
      } else if (role == 'EMPLOYEE') {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => attendanceViewScreen()),
        // );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print("Login failed: $error");
    }
  }

  // Future<void> loginUser(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.lato().fontFamily),
                )),
            SizedBox(height: 20),

            // Login Text Button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
