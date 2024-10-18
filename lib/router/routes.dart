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
        path: NewQuizPage.routeLocation,
        name: NewQuizPage.routeName,
        builder: (context, state) => const NewQuizPage(),
      ),
    ],
  ),
  GoRoute(
    path: QuizPage.routeLocation,
    name: QuizPage.routeName,
    builder: (context, state) {
      final pathParams = state.pathParameters;
      final queryParams = state.uri.queryParameters;
      return QuizPage(
        quizId: pathParams['quizId'].toString(),
        resultId: queryParams['result'],
      );
    },
  ),
  GoRoute(
    path: ResultAnalysisPage.routeLocation,
    name: ResultAnalysisPage.routeName,
    redirect: (context, state) {
      final extra = state.extra as Map<String, dynamic>;

      // Validate the extra data types, if type is incorrect, go back to home
      if (extra['questions'] is! List<Question> ||
          extra['shuffledOptions'] is! List<List<String>> ||
          extra['selectedAnswers'] is! List<int?> ||
          extra['score'] is! int) {
        return HomePage.routeLocation;
      }

      return null;
    },
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;

      return ResultAnalysisPage(
        questions: extra['questions'] as List<Question>,
        shuffledOptions: extra['shuffledOptions'] as List<List<String>>,
        selectedAnswers: extra['selectedAnswers'] as List<int?>,
        score: extra['score'] as int,
      );
    },
  ),
  GoRoute(
    path: ProfilePage.routeLocation,
    name: ProfilePage.routeName,
    builder: (context, state) => const ProfilePage(),
  ),
];
