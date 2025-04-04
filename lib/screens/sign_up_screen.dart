import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_email_field.dart';
import '../widgets/loading_widget.dart';
import 'verification_code_screen2.dart';
import 'auth_screen.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    // Star Image
                    Positioned(
                      top: screenHeight * 0.13,
                      left: screenWidth * 0.25,
                      child: Image.asset('assets/images/image 2.png'),
                    ),

                    Positioned(
                      top: 330,
                      left: 110,
                      child: const Text(
                        "تسجيل حساب جديد",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 370,
                      left: 84,
                      child: const SizedBox(
                        width: 280,
                        child: Text(
                          "قم بإدخال بريدك الإلكتروني لتسجيل حساب جديد",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.67,
                            color: Color(0xFF878383),
                          ),
                        ),
                      ),
                    ),

                    // عرض رسالة الخطأ
                    if (authProvider.error.isNotEmpty)
                      Positioned(
                        top: 425,
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

                    // Email Field
                    Positioned(
                      top: 475,
                      left: 35,
                      child: CustomEmailField(
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                    ),

                    // Sign Up Button
                    Positioned(
                      top: 580,
                      left: 35,
                      child: SizedBox(
                        width: 363,
                        height: 76,
                        child: ElevatedButton(
                          onPressed: () => _register(context, authProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D75B1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38),
                            ),
                          ),
                          child: const Text(
                            "تسجيل",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // "Don't have an account?" Text
                    Positioned(
                      top: 820,
                      left: 150,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "لديك حساب بالفعل ؟",
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.67,
                            color: Color(0xFF878383),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 860,
                      left: 145,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Color(0xFF1D75B1),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D75B1),
                              ),
                            ),
                          ],
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

  void _register(BuildContext context, AuthProvider authProvider) async {
    // التحقق من صحة المدخلات
    if (_formKey.currentState?.validate() ?? false) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      // محاولة تسجيل حساب جديد
      final success = await authProvider.register(_emailController.text.trim());

      // في حالة النجاح، انتقل إلى شاشة التحقق من الرمز
      if (success && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VerificationCodeScreen2(
                  email: _emailController.text.trim(),
                ),
          ),
        );
      }
    }
  }
}
