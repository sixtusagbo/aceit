import 'dart:developer';
import 'dart:ui';

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
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizPage extends HookConsumerWidget {
  const QuizPage({
    super.key,
    required this.quizId,
    required this.resultId,
  });

  static String get routeName => 'quiz';
  static String get routeLocation => '/quiz/:quizId';

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
    final canPop = useState(false);
    final courseDetailsAsync = ref.watch(courseDetailsByQuizIdProvider(quizId));
    final currentResultId = useState<String?>(resultId);
    final userId = ref.watch(userIdProvider);
    final quizResultAsync = ref.watch(quizResultProvider(quizId));
    var titleStyle = TextStyle(fontSize: 18.sp);
    // Track initialization
    final hasInitialized = useState(false);

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

    // Restore progress for existing quiz
    useEffect(() {
      if (resultId != null) {
        final result = ref.read(currentQuizProgressProvider(resultId!));
        if (result != null) {
          currentResultId.value = result.id;
          currentQuestionIndex.value = result.currentQuestion;
          selectedAnswers.value = List<int?>.from(result.selectedAnswers);
          secondsElapsed.value = result.secondsElapsed;
          if (!result.inProgress) {
            isQuizFinished.value = true;
          }
        }
        hasInitialized.value = true;
      }
      return null;
    }, []);

    // Replace the existing quiz restoration effect with this new one
    useEffect(() {
      if (!hasInitialized.value &&
          resultId == null &&
          quizResultAsync != null) {
        Future.microtask(() async {
          if (context.mounted) {
            final continueExisting = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Continue Existing Quiz?'),
                content: const Text(
                    'Would you like to continue your recent attempt or start a new quiz?'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text('Start New'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(true),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            );

            if (continueExisting == true) {
              currentResultId.value = quizResultAsync.id;
              currentQuestionIndex.value = quizResultAsync.currentQuestion;
              selectedAnswers.value =
                  List<int?>.from(quizResultAsync.selectedAnswers);
              secondsElapsed.value = quizResultAsync.secondsElapsed;
              if (!quizResultAsync.inProgress) {
                isQuizFinished.value = true;
              }
            } else {
              // Create new quiz result for fresh start
              final newQuizResult = QuizResult(
                id: '',
                userId: userId!,
                quizId: quizId,
                score: null,
                selectedAnswers: List<int?>.filled(questions.length, null),
                total: questions.length,
                inProgress: true,
                date: DateTime.now(),
                currentQuestion: 0,
                progress: 0,
                secondsElapsed: 0,
                course: null,
              );
              // Save the new quiz result and use it
              final savedResult =
                  await ref.read(saveQuizResultProvider(newQuizResult).future);
              currentResultId.value = savedResult.id; // Store the new result ID

              // Update the state with the new quiz result
              currentQuestionIndex.value = savedResult.currentQuestion;
              selectedAnswers.value =
                  List<int?>.from(savedResult.selectedAnswers);
              secondsElapsed.value = savedResult.secondsElapsed;
            }
          }
          hasInitialized.value = true;
        });
      } else if (!hasInitialized.value && resultId == null) {
        // Initialize immediately if there's no existing quiz to restore
        hasInitialized.value = true;
      }
      return null;
    }, [quizResultAsync]);

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
        id: currentResultId.value ?? '',
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
        id: currentResultId.value ?? '',
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
          barrierColor: Colors.black.withOpacity(0.3),
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: kGlassBackground.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: kGlassBorder, width: 2),
              ),
              title: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: kGlassBorder)),
                ),
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'Quiz Results',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border:
                            Border.all(color: kPrimaryColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${(score / questions.length * 100).round()}%',
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          Text(
                            '$score out of ${questions.length}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.grey[600]),
                        8.horizontalSpace,
                        Text(
                          '${secondsElapsed.value ~/ 60}m ${secondsElapsed.value % 60}s',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.push('/result-analysis', extra: {
                      'questions': questions,
                      'shuffledOptions': shuffledOptions,
                      'selectedAnswers': selectedAnswers.value,
                      'score': score,
                    });
                    canPop.value = true;
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'View Analysis',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return PopScope(
      canPop: canPop.value,
      onPopInvokedWithResult: (didPop, _) async {
        bool? canPopPage = false;
        if (!isQuizFinished.value) {
          canPopPage = await showDialog<bool>(
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
        } else {
          canPopPage = true;
        }

        if (canPopPage == true) {
          canPop.value = true;
          if (context.mounted) Navigator.pop(context);
        } else {
          canPop.value = false;
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: courseDetailsAsync.when(
            data: (course) {
              return Text("Quiz on ${course.code}", style: titleStyle);
            },
            loading: () => Text('Quiz', style: titleStyle),
            error: (_, __) => Text('Quiz', style: titleStyle),
          ),
          centerTitle: true,
          actions: [
            Text(
              isQuizFinished.value || hasInitialized.value == false
                  ? '00:00'
                  : '${secondsElapsed.value ~/ 60}:${(secondsElapsed.value % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline),
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Saving progress...')),
                );
                await saveProgress();
                if (context.mounted) context.pop();
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  animation: true,
                  lineHeight: 8.h,
                  animationDuration: 500,
                  animateFromLastPercent: true,
                  percent: (currentQuestionIndex.value + 1) / questions.length,
                  center: null,
                  progressColor: kPrimaryColor,
                  backgroundColor: Colors.grey[200],
                  barRadius: Radius.circular(4.r),
                ),
                Text(
                  'Question ${currentQuestionIndex.value + 1} of ${questions.length}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                Expanded(
                  child: Container(
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
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          offset: Offset(-3, -3),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  questions[currentQuestionIndex.value]
                                      .question,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                20.verticalSpace,
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: shuffledOptions[
                                            currentQuestionIndex.value]
                                        .length,
                                    separatorBuilder: (_, __) =>
                                        8.verticalSpace,
                                    itemBuilder: (context, index) {
                                      final option = shuffledOptions[
                                          currentQuestionIndex.value][index];
                                      final isSelected = selectedAnswers.value[
                                              currentQuestionIndex.value] ==
                                          index;

                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            final newAnswers = List<int?>.from(
                                                selectedAnswers.value);
                                            newAnswers[currentQuestionIndex
                                                .value] = index;
                                            selectedAnswers.value = newAnswers;
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          child: Container(
                                            padding: EdgeInsets.all(16.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color: isSelected
                                                    ? kPrimaryColor
                                                    : Colors.grey[300]!,
                                                width: 2,
                                              ),
                                              color: isSelected
                                                  ? kPrimaryColor
                                                      .withOpacity(0.1)
                                                  : Colors.transparent,
                                            ),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: isSelected
                                                    ? kPrimaryColor
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: currentQuestionIndex.value > 0
                          ? previousQuestion
                          : null,
                      icon: Icon(Icons.arrow_back, size: 18.sp),
                      label:
                          Text('Previous', style: TextStyle(fontSize: 14.sp)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          currentQuestionIndex.value < questions.length - 1
                              ? nextQuestion
                              : null,
                      label: Text('Next', style: TextStyle(fontSize: 14.sp)),
                      icon: Icon(Icons.arrow_forward, size: 18.sp),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                ElevatedButton.icon(
                  onPressed: submitQuiz,
                  icon: Icon(Icons.check_circle, size: 20.sp),
                  label: Text('Submit Quiz', style: TextStyle(fontSize: 16.sp)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
