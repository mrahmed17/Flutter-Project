import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_and_pms/administration/authScreen/ForgetPasswordScreen.dart';
import 'package:hr_and_pms/administration/authScreen/RegistrationScreen.dart';
import 'package:hr_and_pms/administration/dashboard/AdminDashboardScreen.dart';
import 'package:hr_and_pms/administration/dashboard/ManagerDashboardScreen.dart';
import 'package:hr_and_pms/features/empDashboard/EmpDashboardScreen.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController()
    ..text = 'emp@mail.com';
  final TextEditingController password = TextEditingController()
    ..text = '123456';
  final storage = FlutterSecureStorage();
  bool _isPasswordVisible = false;

  AuthService authService = AuthService();

  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);
      final role = await authService.getUserRole();

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
        );
      } else if (role == 'MANAGER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagerDashboardScreen()),
        );
      } else if (role == 'EMPLOYEE') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmpDashboardScreen()),
        );
      } else {
        print('Unknown role: $role');
      }
    } catch (error) {
      print('Login failed: $error');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _checkForExistingToken();
  // }
  //
  // Future<void> _checkForExistingToken() async {
  //   bool loggedIn = await AuthService().isLoggedIn();
  //   if (loggedIn) {
  //     // Redirect to home or empDashboard if already logged in
  //     Navigator.pushReplacementNamed(context, '/empDashboard');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Login',
      //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      //   ),
      //   backgroundColor: Colors.teal,
      //   centerTitle: true,
      //   elevation: 4,
      //   shadowColor: Colors.black54,
      // ),
      body: Padding(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.indigo, Colors.teal],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/carousel/secretary.jpg',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 25),
                          _buildTextField(email, "Email", Icons.email),
                          SizedBox(height: 20),
                          _buildPasswordField(),
                          SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              loginUser(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.teal),
                                ),
                                Text(
                                  "Register now!",
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.teal),
        ),
        prefixIcon: Icon(icon, color: Colors.teal),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: password,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.teal),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.teal),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.teal,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Colors.black87),
    );
  }
}
