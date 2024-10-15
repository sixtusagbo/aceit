import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, this.quizId});

  static String get routeName => 'quiz';
  static String get routeLocation => ':quizId';

  final String? quizId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Quiz Page'),
      ),
    );
  }
}
