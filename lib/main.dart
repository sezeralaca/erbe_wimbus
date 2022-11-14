import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:erbe/pages/auth/login_page.dart';
import 'package:erbe/pages/auth/sign_up.dart';
import 'package:erbe/utils/customColors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erbe Yazılım',
      routes: {
        "/loginPage": (context) => const LoginPage(),
        "/signUp": (context) => const SignUp(),
        
      },
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.scaffoldBackgroundColor,
      ),
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
