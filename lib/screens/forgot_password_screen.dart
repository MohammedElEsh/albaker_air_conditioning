import 'package:flutter/material.dart';
import '../widgets/custom_email_field.dart'; // تأكد من إضافة هذا السطر لاستيراد الـ Widget الجديد
import '../widgets/custom_rectangle.dart'; // تأكد من استيراد الـ Widget المخصص للصورة
import 'verification_code_screen.dart'; // إضافة استيراد الشاشة الجديدة
import '../services/user_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();

  void _sendOtp() async {
    try {
      var response = await _userService.sendOtp(_emailController.text);

      if (response.statusCode == 200) {
        // Successfully sent OTP
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    VerificationCodeScreen(email: _emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // الـ Rectangle في الأسفل
            Positioned(
              top: 0, // يمكنك تعديل المسافة من الأعلى إذا أردت
              left: 0,
              right: 0,
              child: CustomRectangle(), // استدعاء الـ CustomRectangle
            ),
            // تعديل موضع الصورة لتكون فوق الـ Rectangle
            Positioned(
              top: 96,
              left: 154,
              child: Image.asset(
                'assets/images/sms-notification.png',
                width: 123,
                height: 123,
                color: const Color(0xFFE17A1D),
              ),
            ),

            // النصوص
            Positioned(
              top: 321,
              left: 20,
              right: 20,
              child: Column(
                children: const [
                  Text(
                    'هل نسيت كلمة المرور؟',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),

                  // إضافة `SizedBox` لتحديد العرض مثل النص الأول
                  SizedBox(
                    width: 300,
                    child: Text(
                      'قم بإدخال بريدك الإلكتروني لإرسال كود التحقق',
                      style: TextStyle(
                        fontSize: 18,
                        height: 2,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // حقل البريد الإلكتروني
            Positioned(
              top: 505,
              left: 35,
              child: CustomEmailField(controller: _emailController),
            ),

            // زر الدخول في الأسفل
            Positioned(
              top: 618, // جعل الزر في الأسفل داخل الشاشة
              left: 35,
              child: SizedBox(
                width: 363,
                height: 76,
                child: ElevatedButton(
                  onPressed: _sendOtp, // Call _sendOtp method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D75B1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: const Text(
                    "إرسال",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.white,
                    ),
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
