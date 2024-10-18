import 'dart:developer';

import 'package:aceit/models/question.dart';
import 'package:aceit/models/quiz_result.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/state/courses.dart';
import 'package:aceit/state/questions.dart';
import 'package:aceit/state/quiz_results.dart';
import 'package:aceit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizPage extends HookConsumerWidget {
  const QuizPage({
    super.key,
    required this.quizId,
    required this.resultId,
  });

  static String get routeName => 'quiz';
  static String get routeLocation => ':quizId';

  final String quizId;
  final String? resultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider(quizId));

    return Scaffold(
      body: questionsAsync.when(
        data: (questions) => _QuizContent(
            questions: questions, quizId: quizId, resultId: resultId),
        error: (error, _) {
          log('Error: $error');
          return const Center(child: Text('An error occurred'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QuizContent extends HookConsumerWidget {
  const _QuizContent({
    required this.questions,
    required this.quizId,
    required this.resultId,
  });

  final List<Question> questions;
  final String quizId;
  final String? resultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestionIndex = useState(0);
    final secondsElapsed = useState(0);
    final isQuizFinished = useState(false);
    final selectedAnswers = useState(List<int?>.filled(questions.length, null));

    final courseDetailsAsync = ref.watch(courseDetailsByQuizIdProvider(quizId));
    final userId = ref.watch(userIdProvider);
    final quizResultAsync = ref.watch(quizResultProvider(quizId));

    final shuffledOptions = useMemoized(() {
      return questions.map((q) {
        final options = List<String>.from(q.options);
        options.shuffle();
        return options;
      }).toList();
    }, [questions]);

    useEffect(() {
      final timer = Stream.periodic(const Duration(seconds: 1), (i) => i);
      final subscription = timer.listen((_) {
        if (!isQuizFinished.value) {
          secondsElapsed.value++;
        }
      });
      return subscription.cancel;
    }, []);

    // Restore progress if any
    useEffect(() {
      if (resultId != null) {
        final result = ref.read(currentQuizProgressProvider(resultId!));
        if (result != null) {
          currentQuestionIndex.value = result.currentQuestion;
          selectedAnswers.value = List<int?>.from(result.selectedAnswers);
          secondsElapsed.value = result.secondsElapsed;
          if (!result.inProgress) {
            isQuizFinished.value = true;
          }
        }
      }
      return null;
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

    Future<void> saveProgress() async {
      final quizResult = QuizResult(
        id: quizResultAsync?.id ?? '',
        userId: userId!,
        quizId: quizId,
        score: null,
        selectedAnswers: selectedAnswers.value,
        total: questions.length,
        inProgress: true,
        date: DateTime.now(),
        currentQuestion: currentQuestionIndex.value,
        progress: (currentQuestionIndex.value + 1) / questions.length,
        secondsElapsed: secondsElapsed.value,
        course: null,
      );

      await ref.read(saveQuizResultProvider(quizResult).future);
    }

    Future<void> submitQuiz() async {
      isQuizFinished.value = true;
      final score = selectedAnswers.value.asMap().entries.where((entry) {
        final question = questions[entry.key];
        final selectedOptionIndex = entry.value;
        if (selectedOptionIndex == null) return false;
        final selectedOption = shuffledOptions[entry.key][selectedOptionIndex];
        return selectedOption == question.options[question.answer];
      }).length;

      final quizResult = QuizResult(
        id: quizResultAsync?.id ?? '',
        userId: userId!,
        quizId: quizId,
        score: score,
        selectedAnswers: selectedAnswers.value,
        total: questions.length,
        inProgress: false,
        date: DateTime.now(),
        currentQuestion: currentQuestionIndex.value,
        progress: 1.0,
        secondsElapsed: secondsElapsed.value,
        course: null,
      );

      await ref.read(saveQuizResultProvider(quizResult).future);

      if (context.mounted) {
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Quiz Results', style: TextStyle(fontSize: 18.sp)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Score: $score/${questions.length}',
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
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        bool? canPop = false;
        if (!isQuizFinished.value) {
          canPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Leave quiz?'),
              content:
                  const Text('Your progress will be saved. Continue later?'),
              actions: [
                TextButton(
                  onPressed: () => context.pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await saveProgress();
                    if (context.mounted) context.pop(true);
                  },
                  child: const Text('Leave'),
                ),
              ],
            ),
          );
        }
        if (canPop == true) {
          if (context.mounted) Navigator.pop(context);
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: courseDetailsAsync.when(
            data: (course) => Text("Quiz on ${course.code}",
                style: TextStyle(fontSize: 18.sp)),
            loading: () => Text('Quiz', style: TextStyle(fontSize: 18.sp)),
            error: (_, __) => Text('Quiz', style: TextStyle(fontSize: 18.sp)),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (currentQuestionIndex.value + 1) / questions.length,
                valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
                backgroundColor: Colors.grey[300],
              ),
              16.verticalSpace,
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
              20.verticalSpace,
              Text(
                questions[currentQuestionIndex.value].question,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 20.sp),
              ),
              SizedBox(height: 20.h),
              ...shuffledOptions[currentQuestionIndex.value]
                  .asMap()
                  .entries
                  .map((entry) => RadioListTile(
                        title: Text(entry.value,
                            style: TextStyle(fontSize: 16.sp)),
                        value: entry.key,
                        groupValue:
                            selectedAnswers.value[currentQuestionIndex.value],
                        onChanged: (value) {
                          final newAnswers =
                              List<int?>.from(selectedAnswers.value);
                          newAnswers[currentQuestionIndex.value] = value;
                          selectedAnswers.value = newAnswers;
                        },
                      )),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentQuestionIndex.value > 0
                        ? previousQuestion
                        : null,
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
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: Text(
                  'Submit Quiz',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
