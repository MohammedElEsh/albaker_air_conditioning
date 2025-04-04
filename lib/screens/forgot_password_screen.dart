import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_email_field.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/loading_widget.dart';
import 'verification_code_screen.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: _formKey,
              child: SafeArea(
                child: Stack(
                  children: [
                    // الـ Rectangle في الأسفل
                    const Positioned(
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

                    // عرض رسالة الخطأ
                    if (authProvider.error.isNotEmpty)
                      Positioned(
                        top: 450,
                        left: 40,
                        right: 40,
                        child: ErrorText(
                          error: authProvider.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // حقل البريد الإلكتروني
                    Positioned(
                      top: 505,
                      left: 35,
                      child: CustomEmailField(
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                    ),

                    // زر الدخول في الأسفل
                    Positioned(
                      top: 618, // جعل الزر في الأسفل داخل الشاشة
                      left: 35,
                      child: SizedBox(
                        width: 363,
                        height: 76,
                        child: ElevatedButton(
                          onPressed:
                              () => _sendResetCode(context, authProvider),
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
            ),
          ),
        );
      },
    );
  }

  void _sendResetCode(BuildContext context, AuthProvider authProvider) async {
    // التحقق من صحة المدخلات
    if (_formKey.currentState?.validate() ?? false) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      // إرسال رمز التحقق
      final success = await authProvider.sendOtp(_emailController.text.trim());

      // إذا تم إرسال الرمز بنجاح، انتقل إلى شاشة التحقق
      if (success && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    VerificationCodeScreen(email: _emailController.text.trim()),
          ),
        );
      }
    }
  }
}
