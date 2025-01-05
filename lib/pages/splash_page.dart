import 'package:aceit/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "Splash Page",
        style: TextStyle(fontSize: 24, color: kPrimaryColor),
      )),
    );
  }
}
