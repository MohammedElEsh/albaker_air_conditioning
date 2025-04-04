import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // التحقق من حالة المصادقة
    _checkAuth();
  }

  void _checkAuth() async {
    Future.delayed(const Duration(seconds: 2), () async {
      // الحصول على مزود المصادقة
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // التحقق من حالة تسجيل الدخول
      final isLoggedIn = await authProvider.checkAuthStatus();

      if (!mounted) return;

      // التوجيه بناءً على حالة تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? const HomeScreen() : AuthScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // عند النقر، قم بالانتقال إلى شاشة المصادقة
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        },
        child: Stack(
          children: [
            // الخلفية
            Image.asset(
              'assets/images/Rectangle 28133.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => const Placeholder(),
            ),
            // اللوجو في المنتصف
            const Center(child: ImageWithTapEffect()),
          ],
        ),
      ),
    );
  }
}

class ImageWithTapEffect extends StatefulWidget {
  const ImageWithTapEffect({super.key});

  @override
  State<ImageWithTapEffect> createState() => _ImageWithTapEffectState();
}

class _ImageWithTapEffectState extends State<ImageWithTapEffect> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Image.asset(
          'assets/images/Mask Group 2412 1.png',
          width: 185,
          height: 80,
          errorBuilder: (_, __, ___) => const Placeholder(),
        ),
      ),
    );
  }
}
