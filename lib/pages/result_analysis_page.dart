import 'package:aceit/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        title: Text('Result Analysis', style: TextStyle(fontSize: 18.sp)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Final Score: $score/$totalQuestions',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              _buildStatisticRow('Correct', correctPercentage, Colors.green),
              _buildStatisticRow('Incorrect', incorrectPercentage, Colors.red),
              _buildStatisticRow('Skipped', skippedPercentage, Colors.orange),
              SizedBox(height: 20.h),
              ...List.generate(
                totalQuestions,
                (index) => _buildQuestionAnalysis(index),
              ),
            ],
          ),
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

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}:',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                if (isSkipped)
                  Text(
                    'Skipped',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(question.question, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 12.h),
            ...shuffledOptions[index].asMap().entries.map((entry) {
              final isSelected = selectedAnswerIndex == entry.key;
              final isCorrectAnswer =
                  entry.value == question.options[question.answer];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? (isCorrect ? Icons.check_circle : Icons.cancel)
                          : (isCorrectAnswer ? Icons.check_circle : null),
                      color: isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : (isCorrectAnswer ? Colors.green : null),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : (isCorrectAnswer ? Colors.green : null),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Text(
                        isCorrect ? 'Correct' : 'Wrong',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (!isSelected && isCorrectAnswer)
                      Text(
                        'Correct',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
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
}
