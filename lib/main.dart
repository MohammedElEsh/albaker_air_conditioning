import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart'; // تأكد من وجود هذا المسار
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Almarai", // اجعل الخط الافتراضي Almarai
        primaryColor: const Color(0xFF1D75B1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D75B1),
          primary: const Color(0xFF1D75B1),
        ),
      ),
      home: const SplashScreen(), // شاشة البداية الآن هي SplashScreen
    );
  }
}
