import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:hr_and_pms/features/administration/screen/LoginPage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController name = TextEditingController()..text = 'TEST';
  final TextEditingController email = TextEditingController()
    ..text = 'test@test.com';
  final TextEditingController password = TextEditingController()
    ..text = '123456';
  final TextEditingController confirmPassword = TextEditingController()
    ..text = '123456';
  final TextEditingController cell = TextEditingController()
    ..text = '01700000000';
  final TextEditingController address = TextEditingController()..text = 'OMG';
  final TextEditingController basicSalary = TextEditingController()
    ..text = '5000';
  DateTime? selectedDOB;
  String? selectedGender;
  String? selectedRole = "EMPLOYEE";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  XFile? mobilePhoto;
  Uint8List? webPhoto;

  Future<void> pickImage() async {
    if (kIsWeb) {
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webPhoto = pickedImage; // Store the picked image as Uint8List
        });
      }
    } else {
      // For Mobile: Use image_picker to pick image
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          mobilePhoto = pickedImage;
        });
      }
    }
  }

  // Method to register user
  void _register() async {
    if (_formKey.currentState!.validate()) {
      final user = {
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'cell': cell.text,
        'address': address.text,
        'dateOfBirth':
            selectedDOB != null ? selectedDOB!.toIso8601String() : '',
        'role': selectedRole ?? "EMPLOYEE",
        'gender': selectedGender ?? "Other",
      };

      setState(() {
        isLoading = true;
      });

      final response = await _sendDataToBackend(user);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print("Registration failed with status: ${response.statusCode}");
      }
    }
  }

  // HTTP post request to send data to backend
  Future<http.Response> _sendDataToBackend(Map<String, String> user) async {
    const String url = 'http://localhost:8080/register';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      http.MultipartFile.fromString(
        'user',
        jsonEncode(user),
        contentType: MediaType('application', 'json'),
      ),
    );

    if (kIsWeb && webPhoto != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'profilePhoto',
        webPhoto!,
        filename: 'upload.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (mobilePhoto != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profilePhoto',
        mobilePhoto!.path,
      ));
    }

    final response = await request.send();
    return await http.Response.fromStream(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                      labelText: "Full name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) => value == null || value.isEmpty
                      ? "Full name is required"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                      labelText: "Enter email address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                  validator: (value) => value == null || value.isEmpty
                      ? "Email is required"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Enter your password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  validator: (value) => value == null || value.isEmpty
                      ? "Password is required"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirm password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  validator: (value) =>
                      value != password.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: cell,
                  decoration: const InputDecoration(
                      labelText: "Enter your cell number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                  validator: (value) => value == null || value.isEmpty
                      ? "Cell number is required"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                      labelText: "Enter your address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.maps_home_work_rounded)),
                  validator: (value) => value == null || value.isEmpty
                      ? "Address is required"
                      : null,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    color: Colors.grey[200],
                    height: 150,
                    width: double.infinity,
                    child: webPhoto != null
                        ? kIsWeb
                            // Display `webPhoto` on web using `Image.memory`
                            ? Image.memory(webPhoto!, fit: BoxFit.cover)
                            // Display `mobilePhoto` on mobile using `Image.file`
                            : Image.file(File(mobilePhoto!.path),
                                fit: BoxFit.cover)
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.grey[700],
                            size: 50,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    labelText: "Select Date of Birth",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  onChanged: (DateTime? value) {
                    setState(() {
                      selectedDOB = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login here",
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
