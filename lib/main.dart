import 'package:aceit/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
import 'router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(const ProviderScope(child: AceItApp()));
}

class AceItApp extends ConsumerWidget {
  const AceItApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        builder: (_, __) {
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            title: 'Ace It',
            theme: ThemeData.light().copyWith(
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                    highlightColor: kPrimaryColor,
                  ),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: customBlue),
              textTheme: GoogleFonts.interTextTheme(
                Theme.of(context).textTheme,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: kPrimaryColor,
            ),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
