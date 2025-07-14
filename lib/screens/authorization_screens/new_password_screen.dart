import 'package:flutter/material.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  void _resetPassword() async {
    if (_passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.requiredFields);
      return;
    }

    if (_passwordController.text.length < 8) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.weakPassword);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.passwordMismatch);
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
        if (response.data != null && response.data['data'] != null && response.data['data']['token'] != null) {
          var token = response.data['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.passwordChangeSuccess);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          setState(() => _isLoading = true); // Set loading for fallback login
          try {
            var loginResponse = await _userService.login(
              widget.email,
              _passwordController.text,
            );

            setState(() => _isLoading = false);

            if (loginResponse.statusCode == 200 &&
                loginResponse.data != null &&
                loginResponse.data['data'] != null &&
                loginResponse.data['data']['token'] != null) {
              var token = loginResponse.data['data']['token'];
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);

              AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.passwordChangeSuccess);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            } else {
              AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
            }
          } catch (loginError) {
            setState(() => _isLoading = false);
            AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
          }
        }
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.passwordResetFailed);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.networkError);
      } else if (e.toString().contains('timeout')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.noInternet);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.passwordResetFailed);
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
    // Get screen dimensions for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),

                // Eye unlock icon
                Center(
                  child: Image.asset(
                    'assets/images/eye_unlock_twotone.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.25,
                    color: const Color(0xFF1D75B1),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Title
                const Text(
                  "كلمة المرور الجديدة",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2525),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.02),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text(
                    "قم بتعيين كلمة المرور الجديدة الخاصة بحسابك",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2D2525),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // New Password Field
                CustomPasswordField(
                  controller: _passwordController,
                  hintText: "كلمة المرور الجديدة",
                ),

                SizedBox(height: screenHeight * 0.02),

                // Confirm Password Field
                CustomPasswordField(
                  controller: _confirmPasswordController,
                  hintText: "تأكيد كلمة المرور الجديدة",
                ),

                SizedBox(height: screenHeight * 0.05),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08,
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

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}