/// The new password screen that handles password reset after OTP verification.
/// Provides password and confirm password input fields with validation.
import 'package:flutter/material.dart';
import '../../widgets/custom_rectangle.dart';
import '../../widgets/custom_password_field.dart';
import '../app_screens/main_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the password reset process and UI.
///
/// Features:
/// - Password and confirm password input fields
/// - Password strength validation
/// - Password matching validation
/// - Secure password visibility toggle
/// - API integration for password reset
/// - Token-based session management
/// - Error handling for various scenarios
class NewPasswordScreen extends StatefulWidget {
  /// Email address for which password is being reset
  final String email;

  /// OTP code used for verification
  final String otp;

  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  /// Controller for managing new password input
  final TextEditingController _passwordController = TextEditingController();

  /// Controller for managing confirm password input
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Service for handling user-related API calls
  final UserService _userService = UserService();

  /// Flag to track loading state during password reset
  bool _isLoading = false;

  /// Handles the password reset process by validating inputs and making API calls.
  ///
  /// Process:
  /// 1. Validates password presence and strength
  /// 2. Validates password matching
  /// 3. Makes API call to reset password
  /// 4. Handles response:
  ///    - Success: Stores token and navigates to main screen
  ///    - Failure: Shows appropriate error message
  /// 5. If token not returned, attempts login
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Weak password
  /// - Password mismatch
  /// - Session expiration
  /// - General password reset errors
  void _resetPassword() async {
    // Validate password presence
    if (_passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.requiredFields);
      return;
    }

    // Validate password strength
    if (_passwordController.text.length < 8) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.weakPassword);
      return;
    }

    // Validate password matching
    if (_passwordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.passwordMismatch,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Attempt password reset through API
      var response = await _userService.resetPassword(
        email: widget.email,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        otp: widget.otp,
      );

      setState(() => _isLoading = false);

      // Handle successful password reset
      if (response.statusCode == 200) {
        // Store token if returned in response
        if (response.data != null &&
            response.data['data'] != null &&
            response.data['data']['token'] != null) {
          var token = response.data['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          AlertUtils.showSuccessAlert(
            context,
            "نجاح",
            AlertUtils.passwordChangeSuccess,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // If token not returned, attempt login
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
                AlertUtils.passwordChangeSuccess,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            } else {
              AlertUtils.showErrorAlert(
                context,
                "تنبيه",
                AlertUtils.sessionExpired,
              );
            }
          } catch (loginError) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.sessionExpired,
            );
          }
        }
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.passwordResetFailed,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      // Handle various error scenarios
      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.networkError);
      } else if (e.toString().contains('timeout')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.noInternet);
      } else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.passwordResetFailed,
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
            // Background rectangle decoration
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomRectangle(),
            ),

            // Password reset icon
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

            // Title and instructions
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
                        height: 1.0,
                        letterSpacing: 0,
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
                        height: 1.4,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // New password input field
            Positioned(
              top: 460,
              left: 33,
              child: CustomPasswordField(
                controller: _passwordController,
                hintText: "كلمة المرور الجديدة",
              ),
            ),

            // Confirm password input field
            Positioned(
              top: 550,
              left: 33,
              child: CustomPasswordField(
                controller: _confirmPasswordController,
                hintText: "تأكيد كلمة المرور الجديدة",
              ),
            ),

            // Reset password button with loading state
            Positioned(
              top: 650,
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "تغيير كلمة المرور",
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
