import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/administration/model/User.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  User? _user;
   // final imageUrl = "http://localhost:8080/uploadDir/images/${_user?.profilePhoto}";
  bool _isLoading = true;
  bool _isUpdating = false;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = await _authService.getUser;
      setState(() {
        _user = user as User?;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user details: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserProfile(User updatedUser) async {
    try {
      setState(() => _isUpdating = true);
      String result = await _authService.updateUserProfile(
        updatedUser.id,
        updatedUser,
        _selectedImage,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      _fetchUserDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _showUpdateDialog() {
    TextEditingController nameController =
    TextEditingController(text: _user?.name ?? '');
    TextEditingController emailController =
    TextEditingController(text: _user?.email ?? '');
    TextEditingController addressController =
    TextEditingController(text: _user?.address ?? '');
    TextEditingController contactController =
    TextEditingController(text: _user?.cell ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
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
                    basicSalary: _user!.basicSalary,
                    dateOfBirth: _user!.dateOfBirth,
                    gender: _user!.gender,
                    joinedDate: _user!.joinedDate,
                    leaveBalance: _user!.leaveBalance,
                    password: _user!.password,
                    profilePhoto: _user!.profilePhoto,
                    role: _user!.role,
                  ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _selectedImage != null
                          ? FileImage(File(_selectedImage!.path))
                          : _user!.profilePhoto != null
                          ? NetworkImage("http://localhost:8080/uploadDir/images/${_user!.profilePhoto}"
                      )
                          : null as ImageProvider<Object>?,
                      child: _selectedImage == null &&
                          _user!.profilePhoto == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Name: ${_user?.name ?? ''}',
                  style: const TextStyle(fontSize: 18)),
              Text('Email: ${_user?.email ?? ''}',
                  style: const TextStyle(fontSize: 18)),
              Text('Role: ${_user?.role.toString() ?? ''}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Divider(),
              ElevatedButton(
                onPressed: () => _showUpdateDialog(),
                child: _isUpdating
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
