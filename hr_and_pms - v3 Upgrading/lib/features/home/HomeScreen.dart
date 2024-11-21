import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/authScreen/LoginScreen.dart';
import 'package:hr_and_pms/administration/authScreen/RegistrationScreen.dart';
import 'package:hr_and_pms/features/home/ImageCarousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    RegistrationScreen(),
    LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kormi Sheba',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.teal,
        // indigo background color for navigation
        selectedItemColor: Colors.white,
        // White for selected item text and icon
        unselectedItemColor: Colors.teal.shade100,
        // Lighter indigo for unselected items
        selectedFontSize: 14,
        unselectedFontSize: 14,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Registration',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login,
            ),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Welcome text and home page content
              Text(
                'Welcome to Kormi Sheba!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manage services and information for employees and management.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              const SizedBox(height: 30),
              // Image Carousel
              ImageCarousel(),
              const SizedBox(height: 40),
              // Call to Action for registration
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Register Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Optional: Button to Login page (if needed)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
              const SizedBox(height: 20),
              // Carousel Text for HRM Features
              CarouselSlider.builder(
                itemCount: 6,
                itemBuilder: (context, index, realIndex) {
                  return FeatureText(
                    text: [
                      'Payroll Management: Easy Salary Generator System with world class Payroll management.',
                      'Attendance Management: Manage attendance with customized needs and automatic calculations.',
                      'Performance Assessment: Track skills, compensation, and other relevant employee details.',
                      'Benefits Management: Track insurance, pension, and other benefits for employees.',
                      'Employee Self-Service: Empower employees to access and update personal information.',
                      'Scheduling & Time-Table Management: Manage shifts, vacation, and leave requests seamlessly.',
                    ][index],
                    backgroundColor:
                        featureColors[index % featureColors.length],
                    textColor:
                        featureTextColors[index % featureTextColors.length],
                  );
                },
                options: CarouselOptions(
                  height: 100.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
              const SizedBox(height: 40),
              // Prospectus Section
              const Text(
                'Prospectus',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Explore our platform’s features, including payroll management, employee attendance tracking, and more.',
                style: TextStyle(fontSize: 16, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Join us and take your workforce management to the next level!',
                style: TextStyle(fontSize: 16, color: Colors.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Color> featureColors = [
  Colors.blue[100]!, // Light Blue
  Colors.green[100]!, // Light Green
  Colors.orange[100]!, // Light Orange
  Colors.purple[100]!, // Light Purple
  Colors.red[100]!, // Light Red
  Colors.teal[100]!, // Light Teal
  // Add more colors as needed
];

final List<Color> featureTextColors = [
  Colors.blue[900]!, // Dark Blue
  Colors.green[900]!, // Dark Green
  Colors.orange[900]!, // Dark Orange
  Colors.purple[900]!, // Dark Purple
  Colors.red[900]!, // Dark Red
  Colors.teal[900]!, // Dark Teal
  // Add more colors as needed
];

// FeatureText Widget for displaying each feature text in the carousel
class FeatureText extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const FeatureText(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor, // Use the textColor property
            )),
      ),
    );
  }
}
