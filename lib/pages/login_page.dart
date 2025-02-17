import 'package:aceit/utils/constants.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(
        actions: [
          ForgotPasswordAction(((context, email) {
            final uri = Uri(
              path: '/login/forgot-password',
              queryParameters: <String, String?>{
                'email': email,
              },
            );
            context.push(uri.toString());
          })),
          AuthStateChangeAction(((context, state) {
            final user = switch (state) {
              SignedIn state => state.user,
              UserCreated state => state.credential.user,
              _ => null
            };
            if (user == null) {
              return;
            }
            if (!user.emailVerified) {
              user.sendEmailVerification();

              showToast(
                'Please check your email to verify your email address',
                isLong: true,
                gravity: ToastGravity.CENTER,
              );
            }
            context.pushReplacement('/');
          })),
        ],
      ),
    );
  }
}
