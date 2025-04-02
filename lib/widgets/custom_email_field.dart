import 'package:flutter/material.dart';

class CustomEmailField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomEmailField({super.key, required this.controller, this.validator});

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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Image.asset('assets/images/sms-tracking.png', width: 24, height: 24),
            const SizedBox(width: 10),
            Container(width: 2, height: 17, color: const Color(0x36000000)),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.right,
                validator: widget.validator,
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
          ],
        ),
      ),
    );
  }
}
