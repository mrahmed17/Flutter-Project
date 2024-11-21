import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceLookupScreen.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceOverviewScreen.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceAnalyticsScreen.dart';
import 'package:hr_and_pms/administration/screens/UserProfileScreen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCurrentUser();
  // }

  // Future<void> _fetchCurrentUser() async {
  //   try {
  //     AuthService authService = AuthService();
  //     User user = await authService.getCurrentUser(); // Fetch the logged-in user's details
  //     setState(() {
  //       _currentUser = user;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching user details: $e')),
  //     );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  void _onBottomNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          if (_currentUser != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                      // user: _currentUser!,
                      userId: _currentUser!.id,
                      role: _currentUser!.role.name,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    _currentUser!.name,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      _currentUser!.profilePhoto ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            print('View Employees Clicked');
                            break;
                          case 1:
                            print('View Departments Clicked');
                            break;
                          case 2:
                            print('Add Department Clicked');
                            break;
                          case 3:
                            print('Settings Clicked');
                            break;
                          case 4:
                            print('Logout Clicked');
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
                          color: Colors.teal,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade700.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(3, 3),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavigationItemTapped,
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.teal.shade100,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'View Employees';
      case 1:
        return 'View Departments';
      case 2:
        return 'Add Department';
      case 3:
        return 'Settings';
      case 4:
        return 'Logout';
      default:
        return '';
    }
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.people;
      case 1:
        return Icons.business;
      case 2:
        return Icons.add;
      case 3:
        return Icons.settings;
      case 4:
        return Icons.exit_to_app;
      default:
        return Icons.help;
    }
  }
}
