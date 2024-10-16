import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizPage extends HookWidget {
  const QuizPage({super.key, this.quizId});

  static String get routeName => 'quiz';
  static String get routeLocation => ':quizId';

  final String? quizId;

  @override
  Widget build(BuildContext context) {
    // Hooks for state management
    final currentQuestionIndex = useState(0);
    final score = useState(0);
    final secondsElapsed = useState(0);
    final isQuizFinished = useState(false);

    // Timer hook
    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 1), (i) => i);
      final subscription = timer.listen((_) {
        if (!isQuizFinished.value) secondsElapsed.value++;
      });
      return () => subscription.cancel;
    }, []);

    // Dummy data for questions
    final questions = useMemoized(
        () => [
              {
                'question': 'What is the capital of Ebonyi State?',
                'options': ['Ezillo', 'Abakaliki', 'Ezzangbo', 'Nkalagu'],
                'answer': 1,
              },
              {
                'question': 'Who is the current president of Nigeria?',
                'options': ['Buhari', 'Jonathan', 'Tinubu', 'Mimi'],
                'answer': 2,
              },
              {
                'question': 'What is Nigeria\'s currency?',
                'options': [
                  'Naira',
                  'Dollar',
                  'Pounds',
                  'Cedis',
                ],
                'answer': 0,
              },
            ],
        []);

    // Hook to manage selected answers
    final selectedAnswers = useState(List.filled(questions.length, -1));

    // Hook to manage shuffled options
    final shuffledOptions = useMemoized(() {
      return questions.map((q) {
        final options = List<String>.from(q['options'] as Iterable);
        options.shuffle(Random());
        return options;
      }).toList();
    }, []);

    void nextQuestion() {
      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
      }
    }

    void previousQuestion() {
      if (currentQuestionIndex.value > 0) {
        currentQuestionIndex.value--;
      }
    }

    void submitQuiz() {
      isQuizFinished.value = true;
      score.value = selectedAnswers.value.asMap().entries.where((entry) {
        final question = questions[entry.key];
        final answerIndex = (question['options'] as List)
            .indexOf((question['options'] as List)[question['answer'] as int]);
        final selectedOptionIndex = shuffledOptions[entry.key]
            .indexOf((question['options'] as List)[entry.value]);
        return answerIndex == selectedOptionIndex;
      }).length;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Quiz Results', style: TextStyle(fontSize: 18.sp)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Score: ${score.value}/${questions.length}',
                  style: TextStyle(fontSize: 16.sp)),
              Text(
                  'Time taken: ${secondsElapsed.value ~/ 60}m ${secondsElapsed.value % 60}s',
                  style: TextStyle(fontSize: 16.sp)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz $quizId', style: TextStyle(fontSize: 18.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timer display
            Text(
              isQuizFinished.value
                  ? 'Time: 00:00'
                  : 'Time: ${secondsElapsed.value ~/ 60}:${(secondsElapsed.value % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            // Question
            Text(
              questions[currentQuestionIndex.value]['question'].toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 20.h),
            // Options
            ...shuffledOptions[currentQuestionIndex.value]
                .asMap()
                .entries
                .map((entry) => RadioListTile(
                      title:
                          Text(entry.value, style: TextStyle(fontSize: 16.sp)),
                      value: entry.key,
                      groupValue:
                          selectedAnswers.value[currentQuestionIndex.value],
                      onChanged: (value) {
                        final newAnswers =
                            List<int>.from(selectedAnswers.value);
                        newAnswers[currentQuestionIndex.value] = value!;
                        selectedAnswers.value = newAnswers;
                      },
                    )),
            SizedBox(height: 20.h),
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      currentQuestionIndex.value > 0 ? previousQuestion : null,
                  child: Text('Previous', style: TextStyle(fontSize: 14.sp)),
                ),
                ElevatedButton(
                  onPressed: currentQuestionIndex.value < questions.length - 1
                      ? nextQuestion
                      : null,
                  child: Text('Next', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Submit button
            ElevatedButton(
              onPressed: submitQuiz,
              child: Text('Submit Quiz', style: TextStyle(fontSize: 16.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
