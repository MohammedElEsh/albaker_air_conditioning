import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_email_field.dart';
import '../widgets/custom_password_field.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage =
            e.toString().contains('Exception:')
                ? e.toString().split('Exception:')[1].trim()
                : e.toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.13,
                left: screenWidth * 0.25,
                child: Image.asset(
                  'assets/images/image 2.png',
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.15,
                ),
              ),
              Positioned(
                top: screenHeight * 0.33,
                left: screenWidth * 0.3,
                child: const Text(
                  "تسجيل الدخول",
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
                    "قم بإدخال بريدك الإلكتروني لتسجيل الدخول",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.67,
                      color: Color(0xFF878383),
                    ),
                  ),
                ),
              ),

              // Email Field
              Positioned(
                top: 480,
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

              // Password Field
              Positioned(
                top: 580,
                left: 33,
                child: CustomPasswordField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),
              ),

              // Forgot Password Link
              Positioned(
                top: 700,
                left: 133,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "هل نسيت كلمة المرور؟",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF25170B),
                    ),
                  ),
                ),
              ),

              // Login Button
              Positioned(
                top: 750,
                left: 35,
                child: SizedBox(
                  width: 363,
                  height: 76,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
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
                              "الدخول",
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
                top: 860,
                left: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "ليس لديك حساب ؟",
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.67,
                      color: Color(0xFF878383),
                    ),
                  ),
                ),
              ),

              // Sign Up Link
              Positioned(
                top: 900,
                left: 120,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
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
                        "تسجيل حساب جديد",
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
    );
  }
}
