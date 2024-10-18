import 'package:aceit/pages/forgot_password_page.dart';
import 'package:aceit/pages/home_page.dart';
import 'package:aceit/pages/login_page.dart';
import 'package:aceit/pages/profile_page.dart';
import 'package:aceit/pages/quiz_page.dart';
import 'package:aceit/pages/quizzes_page.dart';
import 'package:aceit/pages/settings_page.dart';
import 'package:aceit/pages/splash_page.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/widgets/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routeLocation,
    routes: appRoutes,
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.uri.toString() == SplashPage.routeLocation;
      if (isSplash) {
        return isAuth ? HomePage.routeLocation : LoginPage.routeLocation;
      }

      final isLoggingIn =
          state.uri.toString().startsWith(LoginPage.routeLocation) ||
              state.uri.toString().startsWith(ForgotPasswordPage.routeLocation);
      if (isLoggingIn) return isAuth ? HomePage.routeLocation : null;

      return isAuth ? null : SplashPage.routeLocation;
    },
  );
});
