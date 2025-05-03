import 'package:flutter/material.dart';
import '../../widgets/custom_email_field.dart';
import 'verification_code_screen2.dart';
import 'auth_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _register() async {
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
      var response = await _userService.register(email);

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        AlertUtils.showSuccessAlert(
          context,
          "نجاح",
          AlertUtils.emailSent
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen2(email: email),
          ),
        );
      } else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.duplicateEmail
        );
      } else if (response.statusCode == 400) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.invalidEmail
        );
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.registrationFailed
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Star Image
            Positioned(
              top: screenHeight * 0.13,
              left: screenWidth * 0.25,
              child: Image.asset(
                'assets/images/image 2.png',
              ),
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

            // Email Field
            Positioned(
              top: 475,
              left: 35,
              child: CustomEmailField(controller: _emailController),
            ),

            // Sign Up Button
            Positioned(
              top: 580,
              left: 35,
              child: SizedBox(
                width: 363,
                height: 76,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D75B1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

            // "Already have an account?" Text
            Positioned(
              top: 820,
              left: 150,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
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

            // Login Link
            Positioned(
              top: 860,
              left: 145,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
                child: Row(
                  children: const [
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
    );
  }
}
