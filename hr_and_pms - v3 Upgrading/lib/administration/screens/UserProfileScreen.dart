import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  final String role;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.role,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Replace with actual method to fetch user by ID
      final user = await _authService.getUserById(widget.userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile(User updatedUser, XFile? profilePhoto) async {
    try {
      String result = await _authService.updateUserProfile(updatedUser.id, updatedUser, profilePhoto);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      _fetchUserDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $e')));
    }
  }

  void _showUpdateDialog() {
    TextEditingController nameController = TextEditingController(text: _user?.name ?? '');
    TextEditingController emailController = TextEditingController(text: _user?.email ?? '');
    TextEditingController addressController = TextEditingController(text: _user?.address ?? '');
    TextEditingController contactController = TextEditingController(text: _user?.cell ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
                TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateUserProfile(
                  User(
                    id: _user!.id,
                    name: nameController.text,
                    email: emailController.text,
                    address: addressController.text,
                    cell: contactController.text,
                    // Populate all required fields
                    basicSalary: _user!.basicSalary,
                    dateOfBirth: _user!.dateOfBirth,
                    gender: _user!.gender,
                    joinedDate: _user!.joinedDate,
                    leaveBalance: _user!.leaveBalance,
                    password: _user!.password,
                    profilePhoto: _user!.profilePhoto,
                    role: _user!.role,
                  ),
                  null,
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('User not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  backgroundImage: _user?.profilePhoto != null
                      ? NetworkImage("http://localhost:8080/uploadDir/images/${_user!.profilePhoto}")
                      : null,
                  radius: 60,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Name: ${_user?.name ?? ''}'),
            Text('Email: ${_user?.email ?? ''}'),
            // Additional fields...
            const Divider(),
            ElevatedButton(
              onPressed: () => _showUpdateDialog(),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
