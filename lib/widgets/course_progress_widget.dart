import 'dart:ui';

import 'package:aceit/utils/constants.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseProgressWidget extends StatelessWidget {
  const CourseProgressWidget({
    super.key,
    required this.courseCode,
    required this.courseTitle,
    required this.progress,
    required this.quizId,
    required this.resultId,
    this.isDummy = false,
    required this.date,
  });

  final String courseCode;
  final String courseTitle;
  final double progress;
  final String quizId;
  final String resultId;
  final bool isDummy;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
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
        borderRadius: BorderRadius.circular(17.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Course info column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseCode,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            courseTitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Continue button
                    IconButton(
                      onPressed: isDummy
                          ? null
                          : () =>
                              context.push('/quiz/$quizId?result=$resultId'),
                      icon: const Icon(Icons.arrow_forward_ios),
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: kPrimaryColor.withOpacity(0.2),
                        padding: EdgeInsets.all(12.r),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                // Progress indicator
                LinearPercentIndicator(
                  width: MediaQuery.sizeOf(context).width * 0.65,
                  animation: true,
                  lineHeight: 8.h,
                  animationDuration: 1500,
                  percent: progress,
                  barRadius: Radius.circular(40.r),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  progressColor: kPrimaryColor,
                  trailing: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                8.verticalSpace,
                // Date text
                Text(
                  'Started ${date.timeago}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
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
