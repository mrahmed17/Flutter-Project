import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceScreen.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/home/HomeScreen.dart';
import 'package:hr_and_pms/widget/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

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
      // home: SplashScreen(),
      // home: AdvanceSalaryFilterScreen(),
      // home: AdvanceSalaryStatusScreen(userId: 3),
      // home: CreateAdvanceSalaryScreen(),
      // home: AdvanceSalaryStatusScreen(userId: 3, isEmployee: true),
      // home: AdvanceSalaryHistoryScreen(userId: 3),
      // home: PendingApplicationsScreen(),
      // home: AdvanceSalaryApplyScreen(),
      // home: HomeScreen(),
      // home: DashboardScreen(),
      // home: AttendanceScreen(attendanceService: AttendanceService()),
      // home: ManagerDashboardScreen(),
      // home: AdminDashboardScreen(),
      // home: UserListScreen(),
      // home: RegistrationScreen(),
      home: LoginScreen(),
    );
  }
}

class SplashHandler extends StatefulWidget {
  @override
  _SplashHandlerState createState() => _SplashHandlerState();
}

class _SplashHandlerState extends State<SplashHandler> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}