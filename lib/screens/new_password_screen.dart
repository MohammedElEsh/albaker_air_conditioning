import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'auth_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    // Rectangle at the top
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CustomRectangle(),
                    ),

                    // Eye unlock image
                    Positioned(
                      top: 96,
                      left: 154,
                      child: Image.asset(
                        'assets/images/eye_unlock_twotone.png',
                        width: 123,
                        height: 123,
                        color: const Color(0xFFE17A1D),
                      ),
                    ),

                    // Title text
                    Positioned(
                      top: 321,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 220,
                            height: 40,
                            child: Text(
                              "كلمة المرور الجديدة",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D2525),
                                height: 1.0, // line-height: 100%
                                letterSpacing: 0, // letter-spacing: 0%
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(
                            width: 350,
                            height: 60,
                            child: Text(
                              "قم بتعيين كلمة المرور الجديدة الخاصة بحسابك",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2D2525),
                                height: 1.4, // line-height: 25px
                                letterSpacing: 0, // letter-spacing: 0%
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
                        top: 410,
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

                    // Password Fields
                    Positioned(
                      top: 460,
                      left: 33,
                      child: CustomPasswordField(
                        controller: _passwordController,
                        hintText: "كلمة المرور الجديدة",
                        validator: Validators.validatePassword,
                      ),
                    ),

                    Positioned(
                      top: 550,
                      left: 33,
                      child: CustomPasswordField(
                        controller: _confirmPasswordController,
                        hintText: "تأكيد كلمة المرور الجديدة",
                        validator:
                            (value) => Validators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                      ),
                    ),

                    // Confirm Button
                    Positioned(
                      top: 700,
                      left: 35,
                      child: SizedBox(
                        width: 363,
                        height: 76,
                        child: ElevatedButton(
                          onPressed:
                              () => _resetPassword(context, authProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D75B1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38),
                            ),
                          ),
                          child: const Text(
                            "تأكيد",
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

  void _resetPassword(BuildContext context, AuthProvider authProvider) async {
    // التحقق من صحة المدخلات
    if (_formKey.currentState?.validate() ?? false) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      // إعادة تعيين كلمة المرور
      final success = await authProvider.resetPassword(
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      // في حالة النجاح، انتقل إلى شاشة تسجيل الدخول
      if (success && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    }
  }
}
