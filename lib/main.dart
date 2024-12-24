import 'package:firebase_core/firebase_core.dart';
import 'package:hospitize/model/userLoginSessionToken.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hospitize/view/HomePage.dart';
import 'package:hospitize/view/SplashScreen.dart';
import 'package:hospitize/view/UserForgotPassword.dart';
import 'package:hospitize/view/UserLogin.dart';
import 'package:hospitize/view/UserSignUp.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => const SplashScreen(
          child: UserLoginPage(),
        ),
        '/login': (context) => UserLoginPage(),
        '/signUp': (context) => UserSignUpPage(),
        '/home': (context) => HomePage(session: UserLoginSessions(uID: '', sessionToken: '')),
        '/forgotpass': (context) => UserForgotPassPage(),
      },
    );
  }
}
