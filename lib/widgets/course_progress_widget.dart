import 'package:aceit/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseProgressWidget extends StatelessWidget {
  const CourseProgressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CSC 101',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Introduction to Computer Science',
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  8.verticalSpace,

                  /// Progress bar
                  LinearPercentIndicator(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    animation: true,
                    lineHeight: 8.h,
                    animationDuration: 2000,
                    percent: 0.75,
                    barRadius: Radius.circular(40.r),
                    backgroundColor: Colors.white,
                    progressColor: Colors.greenAccent,
                    trailing: const Text("75.0%"),
                    padding: EdgeInsets.only(right: 10.w),
                  )
                ],
              ),

              /// Circle arrow right icon
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                ),
                color: Theme.of(context).primaryColor,
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFCFB9F4),
                  fixedSize: Size.fromHeight(29.h),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
