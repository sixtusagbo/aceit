import 'package:flutter/material.dart';

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  static String get routeName => 'quizzes';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Quizzes Page'),
      ),
    );
  }
}
