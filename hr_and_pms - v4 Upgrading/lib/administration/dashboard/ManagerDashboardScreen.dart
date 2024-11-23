import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceReportScreen.dart';
import 'package:hr_and_pms/features/salary/Payroll.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  int _selectedIndex = 0;

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    print('Attendance Report Clicked');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AttendanceReportScreen()),
                    );
                    break;
                  case 1:
                    print('View Employees Clicked');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => EmployeeDetails()),
                    );
                    break;
                  case 2:
                    print('View Departments Clicked');
                    break;
                  case 3:
                    print('Add Department Clicked');
                    break;
                  case 4:
                    print('Settings Clicked');
                    break;
                  case 5:
                    print('Login Clicked');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    break;
                  default:
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.orange, // Consistent teal color for all items
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade700.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(3, 3), // Subtle shadow effect
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIcon(index),
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getLabel(index),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.orange.shade100,
        backgroundColor: Colors.orange,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Attendance Report';
      case 1:
        return 'View Employees';
      case 2:
        return 'View Departments';
      case 3:
        return 'Add Department';
      case 4:
        return 'Settings';
      case 5:
        return 'Logout';
      default:
        return '';
    }
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.access_time;
      case 1:
        return Icons.people;
      case 2:
        return Icons.house;
      case 3:
        return Icons.add;
      case 4:
        return Icons.settings;
      case 5:
        return Icons.exit_to_app;
      default:
        return Icons.help;
    }
  }
}
