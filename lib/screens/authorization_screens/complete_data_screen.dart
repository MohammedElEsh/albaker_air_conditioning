/// The complete data screen that handles user registration data completion.
/// Provides input fields for personal information and password setup.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_password_field.dart';
import '../../services/user_service.dart';
import '../app_screens/main_screen.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Manages the user registration completion process and UI.
///
/// Features:
/// - Personal information input (first name, last name, phone)
/// - Password and confirm password fields
/// - Form validation for all fields
/// - API integration for registration completion
/// - Token-based session management
/// - Error handling for various scenarios
/// - Custom UI with user profile icon
class CompleteDataScreen extends StatefulWidget {
  /// Email address used for registration
  final String email;

  /// OTP code used for verification
  final String otp;

  const CompleteDataScreen({super.key, required this.email, required this.otp});

  @override
  State<CompleteDataScreen> createState() => _CompleteDataScreenState();
}

class _CompleteDataScreenState extends State<CompleteDataScreen> {
  /// Controller for managing first name input
  final TextEditingController _firstNameController = TextEditingController();

  /// Controller for managing last name input
  final TextEditingController _lastNameController = TextEditingController();

  /// Controller for managing phone number input
  final TextEditingController _phoneController = TextEditingController();

  /// Controller for managing password input
  final TextEditingController _passwordController = TextEditingController();

  /// Controller for managing confirm password input
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Service for handling user-related API calls
  final UserService _userService = UserService();

  /// Flag to track loading state during registration
  bool _isLoading = false;

  /// Validates all input fields and shows appropriate error messages.
  ///
  /// Validates:
  /// - First name presence
  /// - Last name presence
  /// - Phone number presence
  /// - Password presence and strength
  /// - Password matching
  ///
  /// Returns true if all validations pass, false otherwise.
  bool _validateFields() {
    // Validate first name
    if (_firstNameController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", "يرجى إدخال الاسم الأول");
      return false;
    }

    // Validate last name
    if (_lastNameController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", "يرجى إدخال الاسم الأخير");
      return false;
    }

    // Validate phone number
    if (_phoneController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", "يرجى إدخال رقم الجوال");
      return false;
    }

    // Validate password presence
    if (_passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(context, "تنبيه", "يرجى إدخال كلمة المرور");
      return false;
    }

    // Validate password strength
    if (_passwordController.text.length < 8) {
      AlertUtils.showWarningAlert(context, "تنبيه", AlertUtils.weakPassword);
      return false;
    }

    // Validate password matching
    if (_passwordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.passwordMismatch,
      );
      return false;
    }

    return true;
  }

  /// Handles the registration completion process by validating inputs and making API calls.
  ///
  /// Process:
  /// 1. Validates all input fields
  /// 2. Shows loading indicator
  /// 3. Makes API call to complete registration
  /// 4. Handles response:
  ///    - Success: Stores token and navigates to main screen
  ///    - Validation errors: Shows specific error messages
  ///    - Other errors: Shows appropriate error message
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Duplicate phone number
  /// - Duplicate email
  /// - Form validation errors
  /// - General registration errors
  void _completeRegistration() async {
    if (!_validateFields()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Attempt to complete registration through API
      var response = await _userService.completeRegister(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        email: widget.email,
        otp: widget.otp,
        fcmToken: '123', // Default token for now
      );

      setState(() => _isLoading = false);

      // Handle successful registration
      if (response.statusCode == 200) {
        if (response.data != null &&
            response.data['data'] != null &&
            response.data['data']['token'] != null) {
          var token = response.data['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          AlertUtils.showSuccessAlert(
            context,
            "نجاح",
            AlertUtils.successMessage,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.serverError);
        }
      }
      // Handle validation errors
      else if (response.statusCode == 422) {
        if (response.data != null && response.data['message'] != null) {
          if (response.data['message'].toString().contains('phone')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.phoneAlreadyUsed,
            );
          } else if (response.data['message'].toString().contains('email')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.duplicateEmail,
            );
          } else {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.formValidationError,
            );
          }
        } else {
          AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.invalidInput);
        }
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
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
          alignment: Alignment.center,
          children: [
            // User profile icon
            Positioned(
              top: 90,
              left: 165,
              child: Image.asset(
                'assets/images/user.png',
                width: 123,
                height: 123,
                color: const Color(0xFFE17A1D),
              ),
            ),

            // Registration completion title
            const Positioned(
              top: 230,
              child: Text(
                "إستكمال البيانات",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2525),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Registration instructions
            const Positioned(
              top: 270,
              child: SizedBox(
                width: 300,
                child: Text(
                  "قم بإستكمال بياناتك الشخصية لتتمكن من تسجيل حسابك",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2D2525),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Form fields
            Positioned(
              top: 350,
              child: Column(
                children: [
                  // First name input field
                  Container(
                    width: 363,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1D75B1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _firstNameController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: "الاسم الأول",
                        hintStyle: TextStyle(
                          color: Color(0xFF878383),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  // Last name input field
                  Container(
                    width: 363,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1D75B1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _lastNameController,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: "الاسم الأخير",
                        hintStyle: TextStyle(
                          color: Color(0xFF878383),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  // Phone number input field
                  Container(
                    width: 363,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF1D75B1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "رقم الجوال",
                        hintStyle: TextStyle(
                          color: Color(0xFF878383),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  // Password input field
                  CustomPasswordField(
                    controller: _passwordController,
                    hintText: "كلمة المرور",
                  ),

                  // Confirm password input field
                  CustomPasswordField(
                    controller: _confirmPasswordController,
                    hintText: "تأكيد كلمة المرور",
                  ),

                  // Complete registration button with loading state
                  Container(
                    width: 363,
                    height: 76,
                    margin: const EdgeInsets.only(top: 32),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _completeRegistration,
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
                                "إستكمال التسجيل",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
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
}
