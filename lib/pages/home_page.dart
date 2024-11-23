import 'package:aceit/pages/profile_page.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/state/quiz_results.dart';
import 'package:aceit/utils/constants.dart';
import 'package:aceit/widgets/auto_scrolling_carousel.dart';
import 'package:aceit/widgets/continue_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(displayNameProvider);
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
                switch (name) {
                  AsyncData(:final value) =>
                    value == null ? 'Welcome' : 'Hi, $value',
                  _ => 'Welcome',
                },
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        titleSpacing: 27.w,
        backgroundColor: Colors.blue.withOpacity(0.1),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        height: 1.sh,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 23.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Materials',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                // Carousel section
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
                24.verticalSpace,
                inProgressQuizzes.when(
                  data: (results) => results.isEmpty
                      ? Center(
                          child: Text(
                            'No quizzes in progress',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ContinueProgressWidget(results: results),
                  error: (err, _) => Text('Error: $err'),
                  loading: () => Skeletonizer(
                    child: ContinueProgressWidget(results: kDummyQuizResults),
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
