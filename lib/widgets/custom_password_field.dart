/// A custom password input field widget with show/hide functionality.
///
/// Features:
/// - Password visibility toggle
/// - Right-aligned text input
/// - Custom styling with rounded corners
/// - Password icon and divider
/// - Consistent width and height
/// - Customizable hint text
///
/// The widget uses a light gray background (#F7F7F7) and includes
/// a vertical divider between the password icon and input field.
import 'package:flutter/material.dart';

/// A reusable password input field with custom styling and layout.
///
/// This widget provides a consistent password input field across the app
/// with the following features:
/// - Toggle password visibility
/// - Right-to-left text alignment
/// - Custom styling with rounded corners
/// - Password icon and divider
/// - Customizable hint text
///
/// The widget maintains a fixed width of 363 and height of 76 pixels
/// for consistency across the app.
class CustomPasswordField extends StatefulWidget {
  /// Controller for managing the password input field
  final TextEditingController controller;

  /// Custom hint text to display in the input field
  final String hintText;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.hintText = "أدخل كلمة المرور",
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  /// Tracks whether the password is currently visible
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 363,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(38),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Password visibility toggle button
          GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Image.asset(
              'assets/images/linear.png',
              width: 24,
              height: 24,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Password input field with right alignment
              SizedBox(
                width: 200,
                child: TextField(
                  controller: widget.controller,
                  textAlign: TextAlign.right,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF878383),
                    ),
                  ),
                ),
              ),
              // Vertical divider between icon and input
              const SizedBox(width: 10),
              Container(width: 2, height: 17, color: const Color(0x36000000)),
              const SizedBox(width: 10),
              // Password icon
              Image.asset('assets/images/twotone.png', width: 24, height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
