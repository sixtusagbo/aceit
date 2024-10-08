import 'package:aceit/screens/profile_page.dart';
import 'package:aceit/state/auth.dart';
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
              child: const CircleAvatar(child: Icon(Icons.person)),
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
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Quick Access",
            ),

            /// Cards for quick access

            /// Current progress with previous courses on Practice

            /// Recent courses
          ],
        ),
      ),
    );
  }
}
