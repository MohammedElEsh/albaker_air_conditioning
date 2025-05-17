/// A custom decorative rectangle widget used as a background element.
///
/// Features:
/// - Semi-transparent orange gradient background
/// - Rounded bottom corners (31px radius)
/// - Fixed width of 430 pixels
/// - Fixed height of 250 pixels
/// - Stack layout for additional content
/// - Consistent styling across the app
///
/// This widget is commonly used as a header background in various screens
/// to provide visual hierarchy and consistent branding.
import 'package:flutter/material.dart';

/// A reusable header background widget with consistent styling.
///
/// This widget creates a decorative header background with the following features:
/// - Semi-transparent orange gradient (10% opacity)
/// - Rounded bottom corners for a modern look
/// - Stack layout allowing for additional content overlay
/// - Fixed dimensions for consistency
/// - Custom color scheme matching the app's branding
///
/// The widget uses a combination of:
/// - Base container with transparent green background
/// - Overlay container with semi-transparent orange
/// - Custom border radius for rounded corners
class CustomRectangle extends StatelessWidget {
  const CustomRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0x0ACA7009), // Transparent green background
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(31),
          bottomRight: Radius.circular(31),
        ),
      ),
      child: Stack(
        children: [
          // Semi-transparent orange background with rounded corners
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(
                  0.1,
                ), // 10% opacity for subtle effect
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(31),
                  bottomRight: Radius.circular(31),
                ),
              ),
            ),
          ),
          // Additional content can be added here using Stack
        ],
      ),
    );
  }
}
