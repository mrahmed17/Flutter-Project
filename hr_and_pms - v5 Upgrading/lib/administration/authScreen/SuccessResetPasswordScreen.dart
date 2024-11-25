
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hr_and_pms/administration/authScreen/ResetPasswordScreen.dart';

class SuccessResetPasswordScreen extends StatelessWidget {
  const SuccessResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri uri = ModalRoute.of(context)!.settings.arguments as Uri;
    final token = uri.queryParameters['token'];  // Extract the token from the URL

    return ResetPasswordScreen(token: token!);  // Pass the token to the ResetPasswordScreen
  }
}
