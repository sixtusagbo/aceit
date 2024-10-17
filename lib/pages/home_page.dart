import 'package:aceit/pages/profile_page.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/state/setup.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:aceit/widgets/course_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authProvider.select(
      (value) => value.valueOrNull?.displayName,
    ));

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
            onPressed: () {},
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
            Text(
              "Quick Access",
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            16.verticalSpace,

            /// Cards for quick access
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final _ in [1, 2, 3])
                    Container(
                      width: 132.w,
                      height: 101.h,
                      decoration: ShapeDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r)),
                      ),
                      child: Center(
                        child: Text(
                          'Lorem Ipsum',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          // style: context.textTheme,
                        ),
                      ),
                    ),
                ].separatedBy(10.horizontalSpace),
              ),
            ),
            20.verticalSpace,

            Text(
              "Continue with previous courses",
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            16.verticalSpace,

            /// Continue with previous courses
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
                  const CourseProgressWidget(),
                  const CourseProgressWidget(),
                  const CourseProgressWidget(),
                ].separatedBy(const Divider()),
              ),
            ),
            16.verticalSpace,

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final setup = FirestoreSetup();
                  await setup.setupInitialData();
                },
                child: const Text('Setup Initial Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
