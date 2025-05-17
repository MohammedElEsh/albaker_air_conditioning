/// The splash screen that appears when the app first launches.
/// Displays the app logo with a background image and automatically navigates
/// to the authentication screen after 3 seconds or when tapped.
import 'package:flutter/material.dart';
import 'authorization_screens/auth_screen.dart';

/// Displays the initial splash screen with logo and background.
/// Handles automatic navigation to auth screen after delay or tap.
///
/// Features:
/// - Full-screen background image
/// - Centered app logo with tap animation
/// - Auto-navigation after 3 seconds
/// - Manual navigation on tap
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Auto-navigate after 3 seconds
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
            // Background image with fallback placeholder
            Image.asset(
              'assets/images/Rectangle 28133.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => const Placeholder(),
            ),
            // Centered logo with tap animation
            const Center(child: ImageWithTapEffect()),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays the app logo with a tap animation effect.
///
/// Features:
/// - Scales down to 95% when tapped
/// - Smooth animation using AnimatedScale
/// - Fallback placeholder for image loading errors
class ImageWithTapEffect extends StatefulWidget {
  const ImageWithTapEffect({super.key});

  @override
  State<ImageWithTapEffect> createState() => _ImageWithTapEffectState();
}

class _ImageWithTapEffectState extends State<ImageWithTapEffect> {
  /// Current scale factor for the logo animation
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Scale down on tap down
      onTapDown: (_) => setState(() => _scale = 0.95),
      // Return to normal scale on tap up
      onTapUp: (_) => setState(() => _scale = 1.0),
      // Return to normal scale if tap is cancelled
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
