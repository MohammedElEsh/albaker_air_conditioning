/// A custom email input field widget with a consistent design across the app.
///
/// Features:
/// - Right-to-left text alignment for Arabic text
/// - Email icon with vertical divider
/// - Custom styling with rounded corners
/// - Consistent width and height
/// - Light gray background
/// - Email-specific keyboard type
///
/// The widget maintains a fixed width of 363 and height of 76 pixels
/// for consistency across the app.
import 'package:flutter/material.dart';

/// A reusable email input field with custom styling and layout.
///
/// This widget provides a consistent email input field across the app
/// with the following features:
/// - Right-to-left text alignment
/// - Custom styling with rounded corners
/// - Email icon and divider
/// - Light gray background (#F7F7F7)
/// - Email-specific keyboard type
/// - Customizable hint text
///
/// The widget uses a container with rounded corners (38px radius)
/// and includes a vertical divider between the email icon and input field.
class CustomEmailField extends StatefulWidget {
  /// Controller for managing the email input field
  final TextEditingController controller;

  const CustomEmailField({super.key, required this.controller});

  @override
  _CustomEmailFieldState createState() => _CustomEmailFieldState();
}

class _CustomEmailFieldState extends State<CustomEmailField> {
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Email input field with right alignment
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "أدخل البريد الإلكتروني",
                hintStyle: TextStyle(
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
          // Email icon
          Image.asset('assets/images/sms-tracking.png', width: 24, height: 24),
        ],
      ),
    );
  }
}
