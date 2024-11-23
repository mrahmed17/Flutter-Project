import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
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
  final TextEditingController name = TextEditingController()
    ..text = 'Test Name';
  final TextEditingController email = TextEditingController()
    ..text = 'test@gmail.com';
  final TextEditingController password = TextEditingController()
    ..text = '123456';
  final TextEditingController confirmPassword = TextEditingController()
    ..text = '123456';
  final TextEditingController cell = TextEditingController()
    ..text = '01700000000';
  final TextEditingController address = TextEditingController()
    ..text = 'Dhaka, Bangladesh';
  final TextEditingController basicSalary = TextEditingController()
    ..text = '30000';
  DateTime? selectedDOB;
  DateTime? joinedDate = DateTime.now();
  String? selectedGender;
  String? selectedRole = "EMPLOYEE";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  XFile? mobilePhoto;
  Uint8List? webPhoto;

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webPhoto = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          mobilePhoto = pickedImage;
        });
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final user = {
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'cell': cell.text,
        'address': address.text,
        'dateOfBirth':
            selectedDOB != null ? selectedDOB!.toIso8601String() : '',
        'gender': selectedGender ?? "Other",
        'basicSalary': basicSalary.text,
        'joinedDate': joinedDate!.toIso8601String(),
        'role': selectedRole ?? "EMPLOYEE",
      };

      setState(() {
        isLoading = true;
      });

      final response = await _sendDataToBackend(user);

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed. Please try again.")),
        );
        print("Registration failed with status: ${response.statusCode}");
      }
    }
  }

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
      // appBar: AppBar(
      //   title: Text(
      //     'Register',
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/carousel/hr management.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.4),
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Registration",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(name, 'Full Name', Icons.person),
                          const SizedBox(height: 20),
                          _buildTextField(email, 'Email', Icons.email,
                              validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is mandatory';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                          const SizedBox(height: 20),
                          _buildTextField(password, 'Password', Icons.lock,
                              obscureText: true),
                          const SizedBox(height: 20),
                          _buildTextField(
                              confirmPassword, 'Confirm Password', Icons.lock,
                              obscureText: true),
                          const SizedBox(height: 20),
                          _buildTextField(cell, 'Cell Number', Icons.phone),
                          const SizedBox(height: 20),
                          _buildTextField(address, 'Address', Icons.home),
                          const SizedBox(height: 20),
                          DateTimeFormField(
                            decoration: InputDecoration(
                              labelText: "Date of Birth",
                              hintText: selectedDOB == null
                                  ? "Select your birthday date"
                                  : "${selectedDOB!.year}-${selectedDOB!.month}-${selectedDOB!.day}",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: Colors.teal),
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
                                    value: gender, child: Text(gender)))
                                .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Gender",
                              border: OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.people, color: Colors.teal),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(basicSalary, 'Basic Salary',
                              Icons.currency_exchange),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: pickImage,
                            child: Row(
                              children: [
                                Text("Profile Photo:",
                                    style: TextStyle(fontSize: 20)),
                                Spacer(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.teal, width: 2),
                                    ),
                                    height: 80,
                                    width: 100,
                                    // width: double.infinity,
                                    child: webPhoto != null
                                        ? Image.memory(webPhoto!,
                                            fit: BoxFit.cover)
                                        : mobilePhoto != null
                                            ? Image.file(
                                                File(mobilePhoto!.path),
                                                fit: BoxFit.cover)
                                            : Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Colors.grey[700],
                                                size: 50),
                                  ),
                                ),
                              ],
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 60),
                                  ),
                                  child: const Text("Register",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(color: Colors.teal),
                                ),
                                Text(
                                  "Login now!",
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
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator ??
          (value) =>
              value == null || value.isEmpty ? "$label is required" : null,
    );
  }
}
