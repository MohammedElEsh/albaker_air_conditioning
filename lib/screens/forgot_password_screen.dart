import 'package:flutter/material.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/custom_email_field.dart';
import '../services/auth_service.dart';
import 'verification_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.forgotPassword(_emailController.text);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    VerificationCodeScreen(email: _emailController.text),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              // الـ Rectangle في الأعلى
              Positioned(top: 0, left: 0, right: 0, child: CustomRectangle()),

              // صورة البريد الإلكتروني
              Positioned(
                top: 96,
                left: 160,
                child: Image.asset(
                  'assets/images/sms-notification.png',
                  width: 123,
                  height: 123,
                  color: const Color(0xFFE17A1D),
                ),
              ),

              // نص "نسيت كلمة المرور"
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
                top: 500,
                left: 33,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomEmailField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'البريد الإلكتروني غير صحيح';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // زر الإرسال
              Positioned(
                top: 620,
                left: 33,
                child: SizedBox(
                  width: 363,
                  height: 76,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleForgotPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D75B1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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
      ),
    );
  }
}
