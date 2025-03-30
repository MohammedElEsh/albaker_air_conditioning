import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء حساب جديد"),
        backgroundColor: const Color(0xFF1D75B1), // يمكنك تغيير اللون حسب تصميمك
      ),
      body: const Center(
        child: Text(
          "صفحة تسجيل حساب جديد",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
