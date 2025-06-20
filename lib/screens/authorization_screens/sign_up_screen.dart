/// The sign up screen that handles new user registration.
/// Provides email input field and validation, with navigation to verification
/// screen upon successful registration.
import 'package:flutter/material.dart';
import '../../widgets/custom_email_field.dart';
import 'verification_code_screen2.dart';
import 'auth_screen.dart';
import '../../services/user_service.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Manages the user registration process and UI.
///
/// Features:
/// - Email input with format validation
/// - Loading state management
/// - API integration for registration
/// - Error handling for various scenarios
/// - Navigation to verification screen on success
/// - Navigation back to login screen
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Controller for managing email input field
  final TextEditingController _emailController = TextEditingController();

  /// Service for handling user-related API calls
  final UserService _userService = UserService();

  /// Flag to track loading state during registration
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

  /// Handles the registration process by validating email and making API calls.
  ///
  /// Process:
  /// 1. Validates email presence and format
  /// 2. Shows loading indicator
  /// 3. Makes API call to register user
  /// 4. Handles response:
  ///    - Success: Shows success message and navigates to verification
  ///    - Duplicate email: Shows error message
  ///    - Invalid email: Shows error message
  ///    - Other errors: Shows appropriate error message
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Invalid email format
  /// - Duplicate email addresses
  /// - General registration errors
  void _register() async {
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
      // Attempt registration through API
      var response = await _userService.register(email);

      setState(() => _isLoading = false);

      // Handle successful registration
      if (response.statusCode == 200) {
        AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.emailSent);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen2(email: email),
          ),
        );
      }
      // Handle duplicate email error
      else if (response.statusCode == 422) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.duplicateEmail);
      }
      // Handle invalid email error
      else if (response.statusCode == 400) {
        AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.invalidEmail);
      }
      // Handle other errors
      else {
        AlertUtils.showErrorAlert(
          context,
          "تنبيه",
          AlertUtils.registrationFailed,
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
                SizedBox(height: screenHeight * 0.08),

                // App logo
                Center(
                  child: Image.asset(
                    'assets/images/image 2.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.15,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Registration title
                const Text(
                  "تسجيل حساب جديد",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Registration subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text(
                    "قم بإدخال بريدك الإلكتروني لتسجيل حساب جديد",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.67,
                      color: Color(0xFF878383),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Email input field
                CustomEmailField(controller: _emailController),

                SizedBox(height: screenHeight * 0.04),

                // Registration button with loading state
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.08,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
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
                              "تسجيل",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.15),

                // "Already have an account?" text
                GestureDetector(
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

                SizedBox(height: screenHeight * 0.02),

                // Login link with back arrow
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
