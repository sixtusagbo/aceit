import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  static String routeName = 'profile';
  static String routeLocation = '/$routeName';

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providers: [
        EmailAuthProvider(),
      ],
      actions: [
        SignedOutAction((context) {
          context.pushReplacement('/');
        }),
      ],
    );
  }
}
