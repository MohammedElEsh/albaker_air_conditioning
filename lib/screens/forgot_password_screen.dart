import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إعادة تعيين كلمة المرور"),
        backgroundColor: const Color(0xFF1D75B1),
      ),
      body: const Center(
        child: Text(
          "صفحة إعادة تعيين كلمة المرور",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
