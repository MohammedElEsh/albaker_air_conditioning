import 'package:flutter/material.dart';

class CustomRectangle extends StatelessWidget {
  const CustomRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 251,
      decoration: BoxDecoration(
        color: const Color(0x06CA7009), // اللون مع الشفافية
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(31),
          bottomRight: Radius.circular(31),
        ),
      ),
      child: Stack(
        children: [
          // وضع الصورة في الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/Rectangle 28238.png', // استخدام الصورة في المجلد
              fit: BoxFit.cover, // لجعل الصورة تغطي الـ Container
            ),
          ),
          // يمكن إضافة عناصر أخرى فوق الصورة هنا (نصوص، أزرار)
        ],
      ),
    );
  }
}
