import 'package:aceit/models/quiz_result.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:aceit/widgets/course_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueProgressWidget extends StatelessWidget {
  const ContinueProgressWidget({
    super.key,
    required this.results,
  });

  final List<QuizResult> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pick up where you left off",
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        16.verticalSpace,
        Column(
          children: [
            for (final result in results)
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                child: CourseProgressWidget(
                  courseCode: result.course!.code,
                  courseTitle: result.course!.title,
                  progress: result.progress,
                  quizId: result.quizId,
                  resultId: result.id,
                  date: result.date,
                ),
              )
          ].separatedBy(16.verticalSpace),
        ),
      ],
    );
  }
}
