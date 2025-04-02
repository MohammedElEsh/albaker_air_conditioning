import 'package:flutter/material.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/custom_password_field.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // التحقق من تطابق كلمتي المرور وإرسالها للخادم
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(
        widget.email,
        _passwordController.text,
        _confirmPasswordController.text,
        widget.otp,
      );

      if (mounted) {
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تغيير كلمة المرور بنجاح'),
            backgroundColor: Colors.green,
          ),
        );

        // الانتقال إلى الشاشة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        // عرض رسالة الخطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
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

              // Password Fields
              Positioned(
                top: 460,
                left: 33,
                child: CustomPasswordField(
                  controller: _passwordController,
                  hintText: "كلمة المرور الجديدة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
                    }
                    return null;
                  },
                ),
              ),

              Positioned(
                top: 550,
                left: 33,
                child: CustomPasswordField(
                  controller: _confirmPasswordController,
                  hintText: "تأكيد كلمة المرور الجديدة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
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
                    onPressed: _isLoading ? null : _resetPassword,
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
    );
  }
}
