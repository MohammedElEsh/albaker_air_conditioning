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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.08,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(38),
      ),
      child: Row(
        children: [
          // Password visibility toggle button (على اليسار)
          GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Image.asset(
              'assets/images/linear.png',
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          // Expanded input field section
          Expanded(
            child: Row(
              children: [
                // Password input field with right alignment
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    textAlign: TextAlign.right,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                        color: const Color(0xFF878383),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.025),
                // Vertical divider between icon and input
                Container(
                  width: 2,
                  height: screenHeight * 0.02,
                  color: const Color(0x36000000),
                ),
                SizedBox(width: screenWidth * 0.025),
                // Password icon (على اليمين)
                Image.asset(
                  'assets/images/twotone.png',
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
