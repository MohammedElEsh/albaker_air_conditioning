import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
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
              const SizedBox(width: 10),
              Container(width: 2, height: 17, color: const Color(0x36000000)),
              const SizedBox(width: 10),
              Image.asset('assets/images/twotone.png', width: 24, height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
