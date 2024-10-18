import 'package:aceit/pages/profile_page.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/state/quiz_results.dart';
import 'package:aceit/state/setup_firestore.dart';
import 'package:aceit/utils/constants.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:aceit/widgets/auto_scrolling_carousel.dart';
import 'package:aceit/widgets/course_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authStateProvider.select(
      (value) => value.valueOrNull?.displayName,
    ));
    final inProgressQuizzes = ref.watch(inProgressQuizProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.push(ProfilePage.routeLocation),
              child: const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.person),
              ),
            ),
            12.horizontalSpace,
            SizedBox(
              width: 140.w,
              child: Text(
                "Hi, $name",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        titleSpacing: 27.w,
        actions: [
          // Support icon button
          IconButton(
            onPressed: () async => launchUrl(Uri.parse(kSupportUrl)),
            iconSize: 49.sp,
            icon: const Icon(Icons.support_agent),
          ),
          18.horizontalSpace,
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 23.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Carousel of banner images
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200.h),
              child: AutoScrollingCarousel(
                autoScrollDuration: const Duration(seconds: 3),
                transitionDuration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                children: [
                  for (final image in kBannerImages)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                ], // Customize as needed
              ),
            ),
            20.verticalSpace,

            /// Continue in-progress quiz
            inProgressQuizzes.when(
              data: (results) => results.isEmpty
                  ? const Text('No in-progress quizzes')
                  : Column(
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
                        Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              for (final result in results)
                                CourseProgressWidget(
                                  courseCode: result.course!.code,
                                  courseTitle: result.course!.title,
                                  progress: result.progress,
                                  quizId: result.quizId,
                                  resultId: result.id,
                                )
                            ].separatedBy(const Divider()),
                          ),
                        ),
                      ],
                    ),
              error: (err, _) => Text('Error: $err'),
              loading: CircularProgressIndicator.new,
            ),
            16.verticalSpace,

            /// Setup initial data
            ElevatedButton(
              onPressed: () async {
                final setup = SetupFirestore();
                await setup.setupInitialData();
              },
              child: const Text('Setup Initial Data'),
            ),
          ],
        ),
      ),
    );
  }
}
