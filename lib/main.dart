/// The main entry point for the Albaker Air Conditioning application.
/// This file sets up the core application configuration and theme.
import 'package:flutter/material.dart';
// import 'screens/app_screens/main_screen.dart'; // Main screen with navbar and all screens
import 'screens/splash_screen.dart'; //

/// Entry point of the application that initializes and runs the Flutter app
void main() {
  runApp(const MyApp());
}

/// Root widget of the application that configures the MaterialApp with custom theme
/// and initial routing.
///
/// This widget sets up:
/// - Custom theme with Almarai font family
/// - Primary color scheme using #1D75B1
/// - AppBar styling with white background and custom text style
/// - Initial route to SplashScreen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Almarai", // Default font is Almarai
        primaryColor: const Color(0xFF1D75B1), // Primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D75B1),
          primary: const Color(0xFF1D75B1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1D75B1)),
          titleTextStyle: TextStyle(
            fontFamily: "Almarai",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      // home: const MainScreen(), // Start with main screen directly for testing
      home: const SplashScreen(), // شاشة البداية الآن هي SplashScreen
    );
  }
}
