import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/authScreen/RegistrationScreen.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/administration/screens/UserProfileScreen.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';



class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final AuthService _authService = AuthService();
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;

  // Filter fields
  String _nameFilter = '';
  String _roleFilter = '';
  String _genderFilter = '';
  double _minSalary = 0.0;
  double _maxSalary = 100000.0;

  // Dropdown items for role and gender
  final List<String> _roles = ['Manager', 'Employee'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<User> users = await _authService.getAllUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),)),
      );
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredUsers = _users.where((user) {
        // Convert the role and gender to lowercase to make the comparison case-insensitive
        final roleString = user.role.toString().toLowerCase();
        final genderString = user.gender!.toLowerCase(); // Make sure it's in lowercase
        final matchesName = user.name!.toLowerCase().contains(_nameFilter.toLowerCase());
        final matchesRole = roleString.contains(_roleFilter.toLowerCase());
        final matchesGender = _genderFilter.isEmpty || genderString == _genderFilter.toLowerCase();  // Strict match for gender
        final matchesSalary = user.basicSalary! >= _minSalary && user.basicSalary! <= _maxSalary;

        return matchesName && matchesRole && matchesGender && matchesSalary;
      }).toList();
    });
  }



  void _resetFilters() {
    setState(() {
      _nameFilter = '';
      _roleFilter = '';
      _genderFilter = '';
      _minSalary = 0.0;
      _maxSalary = 100000.0;
      _filteredUsers = _users;
    });
  }

  Widget _buildUserImage(String? profilePhoto) {
    final imageUrl = profilePhoto != null
        ? "http://localhost:8080/uploadDirectory/profilePhotos/$profilePhoto"
        : null;
    print(imageUrl);
    return imageUrl != null
        ? Image.network(
      imageUrl,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Image loading error: $error');
        print('Stack trace: $stackTrace');
        return const Icon(Icons.error);
      },
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : const CircularProgressIndicator();
      },
    )
        : const Icon(Icons.person, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
          ).then((value) => _fetchUsers());
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Name filter
                TextField(
                  decoration: const InputDecoration(labelText: 'Filter by Name',
                      labelStyle: TextStyle(color: Colors.teal)),
                  onChanged: (value) {
                    _nameFilter = value;
                    _applyFilters();
                  },
                ),
                // Row for Role and Gender filters
                Row(
                  children: [
                    // Role dropdown filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _roleFilter.isEmpty ? null : _roleFilter,
                        decoration: const InputDecoration(labelText: 'Filter by Role',
    labelStyle: TextStyle(color: Colors.teal),),
                        onChanged: (value) {
                          setState(() {
                            _roleFilter = value!;
                          });
                          _applyFilters();
                        },
                        items: _roles
                            .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 8), // Space between the filters
                    // Gender dropdown filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _genderFilter.isEmpty ? null : _genderFilter,
                        decoration: const InputDecoration(labelText: 'Filter by Gender',
                          labelStyle: TextStyle(color: Colors.teal),),
                        onChanged: (value) {
                          setState(() {
                            _genderFilter = value!;
                          });
                          _applyFilters();
                        },
                        items: _genders
                            .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                // Salary range filter with title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Text('Salary Range: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                      Expanded(
                        child: RangeSlider(
                          min: 0.0,
                          max: 100000.0,
                          divisions: 100,
                          labels: RangeLabels('$_minSalary', '$_maxSalary'),
                          values: RangeValues(_minSalary, _maxSalary),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _minSalary = values.start;
                              _maxSalary = values.end;
                            });
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Reset filter button
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Reset Filters', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                User user = _filteredUsers[index];
                return ListTile(
                  leading: _buildUserImage(user.profilePhoto),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(userId: user.id, role: '',),
                      ),
                    ).then((value) => _fetchUsers());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
