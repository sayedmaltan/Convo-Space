import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/services/authentication/auth_gate.dart';
import 'package:iti_project/shared/cash_helper.dart';
import 'firebase_options.dart';
import 'modules/call/resgister_page.dart';
import 'modules/messenger/imageUploadScreen.dart';
import 'modules/on_boarding/onboardingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CashHelper.init();
  // FirebaseAppCheck.instance.activate(
  //     androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity
  // );
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }

}

class MyApp extends StatelessWidget {
  Widget startScreen() {
    if (CashHelper.getData('onboarding') != null &&
        CashHelper.getData('onboarding')) {
      return AuthGate();
    }
    return OnboardingScreen();
  }

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startScreen(),

    );
  }
}

