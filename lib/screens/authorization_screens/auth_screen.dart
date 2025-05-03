import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import '../app_screens/main_screen.dart';
import '../../widgets/custom_email_field.dart'; // استيراد الويدجت المخصصة
import '../../widgets/custom_password_field.dart'; // إضافة استيراد الـ widget الجديد
import '../../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService _userService = UserService();

  void _login(BuildContext context) async {
    // التحقق من عدم ترك الحقول فارغة
    if (emailController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.requiredFields
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.requiredFields
      );
      return;
    }

    try {
      var response = await _userService.login(
        emailController.text,
        passwordController.text,
      );
      if (response.statusCode == 200) {
        var token = response.data['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else if (response.statusCode == 401) {
        // خطأ في بيانات الاعتماد
        if (response.data != null && response.data['message'] != null) {
          if (response.data['message'].toString().contains('email')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.invalidEmailLogin
            );
          } else if (response.data['message'].toString().contains('password')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.invalidPasswordLogin
            );
          } else {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.loginError
            );
          }
        } else {
          AlertUtils.showErrorAlert(
            context,
            "تنبيه",
            AlertUtils.loginError
          );
        }
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.loginError
        );
      }
    } catch (e) {
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
          "انتهت مهلة الاتصال بالخادم"
        );
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.loginError
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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

          // استبدال حقل إدخال البريد بـ CustomEmailField
          Positioned(
            top: 480,
            left: 33,
            child: CustomEmailField(controller: emailController),
          ),

          Positioned(
            top: 580,
            left: 33,
            child: CustomPasswordField(controller: passwordController),
          ),

          Positioned(
            top: 700,
            left: 133,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(),
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

          Positioned(
            top: 750,
            left: 35,
            child: SizedBox(
              width: 363,
              height: 76,
              child: ElevatedButton(
                onPressed: () => _login(context), // Call _login method

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D75B1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38),
                  ),
                ),
                child: const Text(
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

          Positioned(
            top: 860,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
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

          Positioned(
            top: 900,
            left: 120,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1D75B1),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
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
    );
  }
}
