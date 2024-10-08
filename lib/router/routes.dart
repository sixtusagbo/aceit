import 'package:aceit/screens/forgot_password_page.dart';
import 'package:aceit/screens/home_page.dart';
import 'package:aceit/screens/login_page.dart';
import 'package:aceit/screens/profile_page.dart';
import 'package:aceit/screens/splash_page.dart';
import 'package:go_router/go_router.dart';

final appRoutes = [
  GoRoute(
    path: SplashPage.routeLocation,
    name: SplashPage.routeName,
    builder: (context, state) {
      return const SplashPage();
    },
  ),
  GoRoute(
    path: HomePage.routeLocation,
    name: HomePage.routeName,
    builder: (context, state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: LoginPage.routeLocation,
    name: LoginPage.routeName,
    builder: (context, state) {
      return const LoginPage();
    },
    routes: [
      GoRoute(
        path: ForgotPasswordPage.routeLocation,
        name: ForgotPasswordPage.routeName,
        builder: (context, state) {
          final arguments = state.uri.queryParameters;
          return ForgotPasswordPage(email: arguments['email']);
        },
      ),
    ],
  ),
  GoRoute(
    path: ProfilePage.routeLocation,
    name: ProfilePage.routeName,
    builder: (context, state) {
      return const ProfilePage();
    },
  ),
];
