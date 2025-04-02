import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // تأكد من وجود هذا المسار
import 'dart:async';

void main() {
  // إضافة معالج الأخطاء العام
  runZonedGuarded(
    () {
      // تسجيل معالج الأخطاء غير المتوقعة في Flutter
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        print('خطأ غير متوقع في Flutter: ${details.exception}');
      };

      runApp(const MyApp());
    },
    (error, stackTrace) {
      // معالجة الأخطاء غير المتوقعة خارج Flutter
      print('خطأ غير متوقع: $error');
      print('موقع الخطأ: $stackTrace');
    },
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
      ),
      home: const SplashScreen(), // شاشة البداية الآن هي SplashScreen
      builder: (context, child) {
        // معالجة الأخطاء في مستوى التطبيق
        return MediaQuery(
          // يتأكد من أن إعدادات MediaQuery تنتقل بشكل صحيح
          data: MediaQuery.of(context),
          child: Builder(
            builder: (context) {
              return Material(
                child: Stack(children: [child!, _handleErrorNotification()]),
              );
            },
          ),
        );
      },
    );
  }

  // ويدجت لعرض الإشعارات في حالة الخطأ
  Widget _handleErrorNotification() {
    return Builder(
      builder: (context) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 0, // غير مرئي بشكل افتراضي
          ),
        );
      },
    );
  }
}
