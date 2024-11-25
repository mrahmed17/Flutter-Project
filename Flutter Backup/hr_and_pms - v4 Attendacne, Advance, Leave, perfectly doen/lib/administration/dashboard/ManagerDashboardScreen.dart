import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/administration/screens/UserProfileScreen.dart';
import 'package:hr_and_pms/features/advanceSalary/Screens/AdvanceSalaryManagementScreen.dart';
import 'package:hr_and_pms/features/advanceSalary/Screens/ApplyAdvanceSalaryScreen.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceReportScreen.dart';
import 'package:hr_and_pms/features/bonus/Screens/BonusCreateScreen.dart';
import 'package:hr_and_pms/features/bonus/Screens/BonusManagementScreen.dart';
import 'package:hr_and_pms/features/leave/screens/LeaveManagementScreen.dart';
import 'package:intl/intl.dart';
import 'package:hr_and_pms/features/attendance/screens/AttendanceScreen.dart';
import 'package:hr_and_pms/features/leave/screens/ApplyLeaveScreen.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  int _selectedIndex = 0;
  User? _currentUser;

  // Welcome message and current time
  String getWelcomeMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Navigation items for the BottomNavigationBar
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home', 'screen': ()},
    {'icon': Icons.work_off, 'label': 'Leave', 'screen': ()},
    {'icon': Icons.feedback, 'label': 'Feedback', 'screen': ()},
    {'icon': Icons.person, 'label': 'Profile', 'screen': ()},
    {'icon': Icons.logout, 'label': 'Logout', 'screen': ()},
  ];

  // Fetch the screens from the navigation items
  List<Widget> get _screens =>
      _navItems.map((item) => item['screen'] as Widget).toList();

  // Fetch user and authentication state
  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _checkAuthentication();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await AuthService().getUser();
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
      } else {
        print('No user data available');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _checkAuthentication() async {
    if (!await AuthService().isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm) {
      await AuthService().logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      _logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Build the live clock widget
  Widget _buildClock() {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            DateFormat('EEEE, MMMM d, yyyy • h:mm:ss a').format(snapshot.data!),
            style: const TextStyle(fontSize: 14, color: Colors.teal, fontWeight: FontWeight.bold),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.access_time, 'label': 'Attendance Management', 'screen': AttendanceReportScreen()},
      {'icon': Icons.manage_history_outlined, 'label': 'Leave Management', 'screen': LeaveManagementScreen()},
      {'icon': Icons.currency_exchange_sharp, 'label': 'Advance Management', 'screen':AdvanceSalaryManagementScreen()},
      {'icon': Icons.currency_exchange, 'label': 'Create Bonus', 'screen': BonusCreateScreen()},
      {'icon': Icons.currency_exchange_rounded, 'label': 'Bonus Management', 'screen': BonusManagementScreen()},
      {'icon': Icons.history, 'label': 'Coming soon', 'screen': Container()},
      {'icon': Icons.history, 'label': 'Coming soon', 'screen': Container()},
      {'icon': Icons.history, 'label': 'Coming soon', 'screen': Container()},
      {'icon': Icons.history, 'label': 'Coming soon', 'screen': Container()},
      {'icon': Icons.history, 'label': 'Coming soon', 'screen': Container()},
      // Add more features as required
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => features[index]['screen'],
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(features[index]['icon'], size: 40),
                  const SizedBox(height: 8),
                  Text(features[index]['label'], style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard', style: TextStyle( fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getWelcomeMessage()}, ${_currentUser?.name ?? 'Manager'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.teal),
                ),
                _buildClock(),
              ],
            ),
          ),
          _buildDashboardGrid(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: _navItems
            .map((item) => BottomNavigationBarItem(
          icon: Icon(item['icon']),
          label: item['label'],
        ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
