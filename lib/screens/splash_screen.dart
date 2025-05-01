import 'package:flutter/material.dart';
import 'authorization_screens/auth_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الانتقال التلقائي بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    });

    return Scaffold(
      body: GestureDetector(
        onTap: () {
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
