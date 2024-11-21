import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/administration/screen/RegistrationScreen.dart';
import 'package:hr_and_pms/features/administration/service/AuthService.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Home Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                showDialog(context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: CircularProgressIndicator(),),
                );
                await _authService.logout();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
