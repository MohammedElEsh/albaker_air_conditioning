import 'package:flutter/material.dart';
import '../../widgets/custom_email_field.dart'; // تأكد من إضافة هذا السطر لاستيراد الـ Widget الجديد
import '../../widgets/custom_rectangle.dart'; // تأكد من استيراد الـ Widget المخصص للصورة
import 'verification_code_screen.dart'; // إضافة استيراد الشاشة الجديدة
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _sendOtp() async {
    final email = _emailController.text.trim();
    
    // التحقق من إدخال البريد الإلكتروني
    if (email.isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.requiredFields
      );
      return;
    }

    // التحقق من صحة تنسيق البريد الإلكتروني
    if (!_validateEmail(email)) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.invalidEmail
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var response = await _userService.sendOtp(email);

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        // AlertUtils.showSuccessAlert(
        //   context,
        //   "نجاح",
        //   AlertUtils.emailSent
        // );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(email: email),
          ),
        );
      } else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.emailNotFound
        );
      } else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.invalidEmail
        );
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.otpSendFailed
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.networkError
        );
      } else if (e.toString().contains('timeout')) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.noInternet
        );
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.generalError
        );
      }
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
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomRectangle(),
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

            // زر الإرسال
            Positioned(
              top: 618,
              left: 35,
              child: SizedBox(
                width: 363,
                height: 76,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D75B1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
