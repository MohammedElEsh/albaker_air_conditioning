import 'package:flutter/material.dart';
// import '../../widgets/custom_rectangle.dart';
import '../../widgets/custom_password_field.dart';
import '../app_screens/main_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final UserService _userService = UserService();
  bool _isLoading = false;

  void _resetPassword() async {
    if (_passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(
          context,
          "تنبيه",
          AlertUtils.requiredFields
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      AlertUtils.showWarningAlert(
          context,
          "تنبيه",
          AlertUtils.weakPassword
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(
          context,
          "تنبيه",
          AlertUtils.passwordMismatch
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var response = await _userService.resetPassword(
        email: widget.email,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        otp: widget.otp,
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        // حفظ التوكن للمستخدم بعد تغيير كلمة المرور بنجاح
        if (response.data != null && response.data['data'] != null && response.data['data']['token'] != null) {
          var token = response.data['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          AlertUtils.showSuccessAlert(
              context,
              "نجاح",
              AlertUtils.passwordChangeSuccess
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // إذا لم يتم إرجاع التوكن، نحاول تسجيل الدخول أولاً
          try {
            var loginResponse = await _userService.login(
              widget.email,
              _passwordController.text,
            );

            if (loginResponse.statusCode == 200 &&
                loginResponse.data != null &&
                loginResponse.data['data'] != null &&
                loginResponse.data['data']['token'] != null) {

              var token = loginResponse.data['data']['token'];
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);

              AlertUtils.showSuccessAlert(
                  context,
                  "نجاح",
                  AlertUtils.passwordChangeSuccess
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            } else {
              AlertUtils.showErrorAlert(
                  context,
                  "تنبيه",
                  AlertUtils.sessionExpired
              );
            }
          } catch (loginError) {
            AlertUtils.showErrorAlert(
                context,
                "تنبيه",
                AlertUtils.sessionExpired
            );
          }
        }
      } else {
        AlertUtils.showErrorAlert(
            context,
            "تنبيه",
            AlertUtils.passwordResetFailed
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
            AlertUtils.passwordResetFailed
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Rectangle at the top
            // const Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: CustomRectangle(),
            // ),

            // Eye unlock image
            Positioned(
              top: 50,
              left: 130,
              child: Image.asset(
                'assets/images/eye_unlock_twotone.png',
                width: 200,
                height: 200,
                color: const Color(0xFF1D75B1),
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
              ),
            ),

            Positioned(
              top: 550,
              left: 33,
              child: CustomPasswordField(
                controller: _confirmPasswordController,
                hintText: "تأكيد كلمة المرور الجديدة",
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
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
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
    );
  }
}