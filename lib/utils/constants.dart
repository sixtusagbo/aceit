import 'package:aceit/models/course.dart';
import 'package:aceit/models/quiz_result.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF458EFF);
const kGlassWhite = Color(0xCCFFFFFF); // Increased opacity
const kGlassBorder = Color(0x99FFFFFF); // More visible border
const kGlassBackground = Color(0x55FFFFFF); // New background color for depth

Map<int, Color> colorSwatch = {
  50: const Color(0xFFE3F2FF),
  100: const Color(0xFFB9DDFF),
  200: const Color(0xFF8CC6FF),
  300: const Color(0xFF5FAEFF),
  400: const Color(0xFF3C99FF),
  500: kPrimaryColor,
  600: const Color(0xFF3E79E0),
  700: const Color(0xFF2F5EBA),
  800: const Color(0xFF244A96),
  900: const Color(0xFF183374),
};

MaterialColor customBlue = MaterialColor(0xFF458EFF, colorSwatch);

const kSupportUrl = 'https://wa.me/2347080854254';

const kBannerImages = [
  'assets/images/progress-reports.webp',
  'assets/images/question-bank.webp',
  'assets/images/result-analysis.webp',
];

final kDummyQuizResults = [
  for (final _ in [1, 2, 3])
    QuizResult(
      id: 'foobang',
      score: 0,
      progress: 0.7,
      userId: 'foobarbaz',
      quizId: 'quibangbaz',
      selectedAnswers: [],
      total: 23,
      inProgress: true,
      date: DateTime.now(),
      currentQuestion: 2,
      course: Course(
        id: 'id',
        code: 'CSC 301',
        title: 'Data Structures and Algorithms',
        departmentId: 'departmentId',
        levelId: 'levelId',
      ),
    ),
];
