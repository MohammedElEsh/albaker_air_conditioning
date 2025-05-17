/// The verification code screen that handles OTP verification for new user registration.
/// Provides input fields for 5-digit verification code and resend functionality.
import 'package:flutter/material.dart';
import '../../widgets/custom_rectangle.dart';
import 'complete_data_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Manages the OTP verification process and UI for new user registration.
///
/// Features:
/// - 5-digit OTP input with auto-focus
/// - Real-time validation
/// - Resend OTP functionality
/// - Error handling for various scenarios
/// - Navigation to complete data screen
/// - Custom UI with background rectangle and icon
class VerificationCodeScreen2 extends StatefulWidget {
  /// Email address for which OTP was sent
  final String email;

  const VerificationCodeScreen2({super.key, required this.email});

  @override
  State<VerificationCodeScreen2> createState() =>
      _VerificationCodeScreen2State();
}

class _VerificationCodeScreen2State extends State<VerificationCodeScreen2> {
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
  ///    - Success: Navigates to complete data screen
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
    // تحقق من أن جميع حقول OTP مملوءة
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

    // تحقق من تنسيق رمز التحقق
    if (otp.length != 5 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.invalidOtpFormat,
      );
      return;
    }

    try {
      var response = await _userService.checkOtp(widget.email, otp);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => CompleteDataScreen(email: widget.email, otp: otp),
          ),
        );
      } else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.verificationCodeError,
        );
      } else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.emailNotFound);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
      }
    } catch (e) {
      if (e.toString().contains('network')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.networkError);
      } else if (e.toString().contains('timeout')) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.noInternet);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.generalError);
      }
    }
  }

  void _resendCode() async {
    try {
      var response = await _userService.sendOtp(widget.email);
      if (response.statusCode == 200) {
        // مسح الحقول القديمة
        for (var controller in controllers) {
          controller.clear();
        }
        // إعلام المستخدم أنه تم إرسال رمز جديد
        AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.newOtpSent);
      } else if (response.statusCode == 404) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.emailNotFound);
      } else {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.otpSendFailed);
      }
    } catch (e) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Rectangle at the top
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomRectangle(),
            ),

            // Star image
            Positioned(
              top: 133,
              left: 100,
              child: Image.asset(
                'assets/images/Group 176119.png',
                width: 235,
                height: 50,
              ),
            ),

            // Main content
            Positioned(
              top: 303,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Positioned(
                    child: const SizedBox(
                      width: 128,
                      height: 40,
                      child: Text(
                        "كود التحقق",
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
                  ),

                  Positioned(
                    child: const SizedBox(
                      width: 400,
                      height: 65,
                      child: Text(
                        "قم بكتابة كود التحقق المكون من 5 أرقام الذي تم إرساله إليك عبر البريد الإلكتروني",
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
                  ),

                  Positioned(
                    child: SizedBox(
                      width: 246,
                      height: 70,
                      child: Text(
                        widget.email, // يعرض البريد الإلكتروني المرسل
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2D2525),
                          height: 1.0, // line-height: 100%
                          letterSpacing: 0, // letter-spacing: 0%
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // const SizedBox(height: 50),

                  // Verification code fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: 60,
                            height: 61,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                setState(
                                  () {},
                                ); // تحديث حالة الحاوية عند الكتابة
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
                ],
              ),
            ),

            // Verify Button
            Positioned(
              top: 600,
              left: 33,
              child: SizedBox(
                width: 363,
                height: 76,
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
            ),

            // Resend code text
            Positioned(
              top: 745,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    "لم يتم إرسال كود التحقق ؟",
                    style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
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
                ],
              ),
            ),
          ],
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
