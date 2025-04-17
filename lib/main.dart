import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; //
// import 'screens/home_screen.dart'; //

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Almarai", // اجعل الخط الافتراضي Almarai
      ),

      home: const SplashScreen(), // شاشة البداية الآن هي SplashScreen
      // home: const HomeScreen(), // شاشة البداية الآن هي HomeScreen

    );
  }
}
