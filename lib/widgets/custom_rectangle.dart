import 'package:flutter/material.dart';

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
          // Background rectangle with solid color
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1), // Adjust opacity as needed
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(31),
                  bottomRight: Radius.circular(31),
                ),
              ),
            ),
          ),
          // Add any other widgets on top here (texts, buttons, etc.)
        ],
      ),
    );
  }
}
