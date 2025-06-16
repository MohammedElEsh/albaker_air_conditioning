/// The forgot password screen that handles password recovery process.
/// Provides email input for OTP verification and navigation to verification screen.
import 'package:flutter/material.dart';
import '../../widgets/custom_email_field.dart'; // تأكد من إضافة هذا السطر لاستيراد الـ Widget الجديد
// import '../../widgets/custom_rectangle.dart'; // تأكد من استيراد الـ Widget المخصص للصورة
import 'verification_code_screen.dart'; // إضافة استيراد الشاشة الجديدة
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Manages the password recovery process and UI.
///
/// Features:
/// - Email input with format validation
/// - OTP sending functionality
/// - Loading state management
/// - Error handling for various scenarios
/// - Navigation to verification screen
/// - Custom UI with background rectangle and icon
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /// Controller for managing email input field
  final TextEditingController _emailController = TextEditingController();

  /// Service for handling user-related API calls
  final UserService _userService = UserService();

  /// Flag to track loading state during OTP sending
  bool _isLoading = false;

  /// Validates email format using regex pattern
  ///
  /// Pattern checks for:
  /// - Username with dots, hyphens, and underscores
  /// - Domain name with dots
  /// - Top-level domain (2-4 characters)
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Handles the OTP sending process by validating email and making API calls.
  ///
  /// Process:
  /// 1. Validates email presence and format
  /// 2. Shows loading indicator
  /// 3. Makes API call to send OTP
  /// 4. Handles response:
  ///    - Success: Navigates to verification screen
  ///    - Email not found: Shows error message
  ///    - Invalid email: Shows error message
  ///    - Other errors: Shows appropriate error message
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Invalid email format
  /// - Email not found in system
  /// - General OTP sending errors
  void _sendOtp() async {
    final email = _emailController.text.trim();

    // Validate email input
    if (email.isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.requiredFields);
      return;
    }

    // Validate email format
    if (!_validateEmail(email)) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.invalidEmail);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Attempt to send OTP through API
      var response = await _userService.sendOtp(email);

      setState(() => _isLoading = false);

      // Handle successful OTP sending
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(email: email),
          ),
        );
      }
      // Handle email not found error
      else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.emailNotFound);
      }
      // Handle invalid email error
      else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.invalidEmail);
      }
      // Handle other errors
      else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.otpSendFailed);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      // Handle various error scenarios
      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.networkError);
      } else if (e.toString().contains('timeout')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.noInternet);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
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

                // SMS notification icon
                Center(
                  child: Image.asset(
                    'assets/images/sms-notification.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.25,
                    color: const Color(0xFF1D75B1),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Title
                const Text(
                  'هل نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.02),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text(
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

                SizedBox(height: screenHeight * 0.05),

                // Email input field
                CustomEmailField(controller: _emailController),

                SizedBox(height: screenHeight * 0.04),

                // Send button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
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
                              "إرسال",
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
