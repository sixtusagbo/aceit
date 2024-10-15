import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({
    super.key,
    this.email,
  });

  static String get routeName => 'forgot-password';
  static String get routeLocation => '/$routeName';

  final String? email;

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      email: email,
      headerMaxExtent: 200,
    );
  }
}
