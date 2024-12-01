import 'dart:ui';

import 'package:aceit/models/question.dart';
import 'package:aceit/pages/home_page.dart';
import 'package:aceit/utils/constants.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResultAnalysisPage extends StatelessWidget {
  const ResultAnalysisPage({
    super.key,
    required this.questions,
    required this.shuffledOptions,
    required this.selectedAnswers,
    required this.score,
  });

  final List<Question> questions;
  final List<List<String>> shuffledOptions;
  final List<int?> selectedAnswers;
  final int score;

  static String get routeName => 'result-analysis';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    final totalQuestions = questions.length;
    final skippedCount =
        selectedAnswers.where((answer) => answer == null).length;
    final correctCount = score;
    final incorrectCount = totalQuestions - correctCount - skippedCount;

    final correctPercentage =
        (correctCount / totalQuestions * 100).toStringAsFixed(1);
    final incorrectPercentage =
        (incorrectCount / totalQuestions * 100).toStringAsFixed(1);
    final skippedPercentage =
        (skippedCount / totalQuestions * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result Analysis',
          style: titleStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.go(HomePage.routeLocation),
          icon: Icon(Icons.home),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScoreCard(totalQuestions),
                SizedBox(height: 20.h),
                _buildStatisticsCard(
                  correctPercentage,
                  incorrectPercentage,
                  skippedPercentage,
                ),
                SizedBox(height: 20.h),
                ...List.generate(
                  totalQuestions,
                  (index) => _buildQuestionAnalysis(index),
                ).separatedBy(16.verticalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kGlassWhite,
            kGlassBackground,
          ],
        ),
        border: Border.all(
          color: kGlassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(-3, -3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: child,
        ),
      ),
    );
  }

  Widget _buildScoreCard(int totalQuestions) {
    return _buildGlassContainer(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            Text(
              '/$totalQuestions',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(
    String correctPercentage,
    String incorrectPercentage,
    String skippedPercentage,
  ) {
    return _buildGlassContainer(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildStatisticRow('Correct', correctPercentage, Colors.green),
            SizedBox(height: 12.h),
            _buildStatisticRow('Incorrect', incorrectPercentage, Colors.red),
            SizedBox(height: 12.h),
            _buildStatisticRow('Skipped', skippedPercentage, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String label, String percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: double.parse(percentage) / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$percentage%',
            style: TextStyle(
                fontSize: 16.sp, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionAnalysis(int index) {
    final question = questions[index];
    final selectedAnswerIndex = selectedAnswers[index];
    final isSkipped = selectedAnswerIndex == null;
    final isCorrect = !isSkipped &&
        shuffledOptions[index][selectedAnswerIndex] ==
            question.options[question.answer];

    return _buildGlassContainer(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                if (isSkipped)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Skipped',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              question.question,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ...shuffledOptions[index].asMap().entries.map((entry) {
              final isSelected = selectedAnswerIndex == entry.key;
              final isCorrectAnswer =
                  entry.value == question.options[question.answer];

              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      _getOptionColor(isSelected, isCorrect, isCorrectAnswer),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getOptionIcon(isSelected, isCorrect, isCorrectAnswer),
                      color: _getOptionIconColor(
                          isSelected, isCorrect, isCorrectAnswer),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _getOptionTextColor(
                              isSelected, isCorrect, isCorrectAnswer),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getOptionColor(bool isSelected, bool isCorrect, bool isCorrectAnswer) {
    if (isSelected) {
      return isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1);
    }
    if (isCorrectAnswer) {
      return Colors.green.withOpacity(0.1);
    }
    return Colors.white.withOpacity(0.5);
  }

  IconData _getOptionIcon(
      bool isSelected, bool isCorrect, bool isCorrectAnswer) {
    if (isSelected) {
      return isCorrect ? Icons.check_circle : Icons.cancel;
    }
    if (isCorrectAnswer) {
      return Icons.check_circle;
    }
    return Icons.radio_button_unchecked;
  }

  Color _getOptionIconColor(
      bool isSelected, bool isCorrect, bool isCorrectAnswer) {
    if (isSelected) {
      return isCorrect ? Colors.green : Colors.red;
    }
    if (isCorrectAnswer) {
      return Colors.green;
    }
    return Colors.grey;
  }

  Color _getOptionTextColor(
      bool isSelected, bool isCorrect, bool isCorrectAnswer) {
    if (isSelected) {
      return isCorrect ? Colors.green : Colors.red;
    }
    if (isCorrectAnswer) {
      return Colors.green;
    }
    return Colors.black87;
  }
}
