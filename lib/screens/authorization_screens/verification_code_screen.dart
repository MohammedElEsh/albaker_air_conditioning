/// The verification code screen that handles OTP verification for password reset.
/// Provides input fields for 5-digit verification code and resend functionality.
import 'package:flutter/material.dart';
// import '../../widgets/custom_rectangle.dart';
import 'new_password_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Manages the OTP verification process and UI.
///
/// Features:
/// - 5-digit OTP input with auto-focus
/// - Real-time validation
/// - Resend OTP functionality
/// - Error handling for various scenarios
/// - Navigation to new password screen
/// - Custom UI with background rectangle and icon
class VerificationCodeScreen extends StatefulWidget {
  /// Email address for which OTP was sent
  final String email;

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  /// List of controllers for each digit of the OTP
  final List<TextEditingController> controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  /// Service for handling user-related API calls
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // Show success alert when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertUtils.showSuccessAlert(
        context,
        "نجاح",
        AlertUtils.verificationCodeSent,
      );
    });
  }

  /// Verifies the entered OTP code by validating format and making API call.
  ///
  /// Process:
  /// 1. Validates that all OTP fields are filled
  /// 2. Validates OTP format (5 digits)
  /// 3. Makes API call to verify OTP
  /// 4. Handles response:
  ///    - Success: Navigates to new password screen
  ///    - Invalid code: Shows error message
  ///    - Email not found: Shows error message
  ///    - Other errors: Shows appropriate error message
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Invalid OTP format
  /// - Invalid verification code
  /// - General verification errors
  void _verifyCode() async {
    // Validate that all OTP fields are filled
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        AlertUtils.showWarningAlert(
          context,
          "تنبيه",
          AlertUtils.verificationCodeEmpty,
        );
        return;
      }
    }

    String otp = controllers.map((c) => c.text).join();

    // Validate OTP format (5 digits)
    if (otp.length != 5 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.invalidOtpFormat,
      );
      return;
    }

    try {
      // Attempt to verify OTP through API
      var response = await _userService.checkOtp(widget.email, otp);

      // Handle successful verification
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewPasswordScreen(email: widget.email, otp: otp),
          ),
        );
      }
      // Handle invalid verification code
      else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.verificationCodeError,
        );
      }
      // Handle email not found
      else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.emailNotFound);
      }
      // Handle other errors
      else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
      }
    } catch (e) {
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

  /// Resends a new OTP code to the user's email.
  ///
  /// Process:
  /// 1. Makes API call to resend OTP
  /// 2. Clears existing input fields
  /// 3. Shows success message
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Email not found
  /// - General OTP sending errors
  void _resendCode() async {
    try {
      // Attempt to resend OTP through API
      var response = await _userService.sendOtp(widget.email);

      // Handle successful resend
      if (response.statusCode == 200) {
        // Clear old input fields
        for (var controller in controllers) {
          controller.clear();
        }
        // Notify user that new code has been sent
        AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.newOtpSent);
      }
      // Handle email not found
      else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.emailNotFound);
      }
      // Handle other errors
      else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.otpSendFailed);
      }
    } catch (e) {
      // Handle various error scenarios
      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.networkError);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.otpSendFailed);
      }
    }
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
                SizedBox(height: screenHeight * 0.02),

                // Verification icon
                Center(
                  child: Image.asset(
                    'assets/images/Group 176119.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.25,
                    color: const Color(0xFF1D75B1),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Verification code title
                const Text(
                  "كود التحقق",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2525),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.02),

                // Verification code instructions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text(
                    "قم بكتابة كود التحقق المكون من 5 أرقام الذي تم إرساله إليك عبر البريد الإلكتروني",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2D2525),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Email display
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2D2525),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.04),

                // Verification code input fields with auto-focus
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          width: screenWidth * 0.14,
                          height: screenWidth * 0.14,
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controllers[index].text.isNotEmpty
                                    ? const Color(0xFF000000)
                                    : const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color:
                                  controllers[index].text.isNotEmpty
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {}); // تحديث حالة الحاوية عند الكتابة
                              if (value.isNotEmpty && index < 4) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08,
                  child: ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D75B1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                    ),
                    child: const Text(
                      "تحقق",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Resend code text
                const Text(
                  "لم يتم إرسال كود التحقق ؟",
                  style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.02),

                GestureDetector(
                  onTap: _resendCode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: Color(0xFF1D75B1),
                        size: 20,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "أرسل الكود مرة أخرى",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D75B1),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
