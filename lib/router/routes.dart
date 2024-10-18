part of 'router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRoutes = [
  GoRoute(
    path: SplashPage.routeLocation,
    name: SplashPage.routeName,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: LoginPage.routeLocation,
    name: LoginPage.routeName,
    builder: (context, state) => const LoginPage(),
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
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return ScaffoldWithNavBar(child: child);
    },
    routes: [
      GoRoute(
        path: HomePage.routeLocation,
        name: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: QuizzesPage.routeLocation,
        name: QuizzesPage.routeName,
        builder: (context, state) => const QuizzesPage(),
        routes: [
          // Add a route for each quiz
          GoRoute(
            path: QuizPage.routeLocation,
            name: QuizPage.routeName,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final pathParams = state.pathParameters;
              final queryParams = state.uri.queryParameters;
              return QuizPage(
                quizId: pathParams['quizId'].toString(),
                resultId: queryParams['result'],
              );
            },
          )
        ],
      ),
    ],
  ),
  GoRoute(
    path: ProfilePage.routeLocation,
    name: ProfilePage.routeName,
    builder: (context, state) => const ProfilePage(),
  ),
];
