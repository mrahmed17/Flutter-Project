import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/administration/screen/LoginScreen.dart';
import 'package:hr_and_pms/features/administration/screen/RegistrationScreen.dart';
import 'package:hr_and_pms/features/home/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HR and Payroll Management System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // home: AllDepartmentViewScreen(),
      home: HomeScreen(),
      // home: RegistrationScreen(),
      // home: LoginScreen(),
    );
  }
}