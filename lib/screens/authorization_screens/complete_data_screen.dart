import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_password_field.dart';
import '../../services/user_service.dart';
import '../app_screens/main_screen.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

class CompleteDataScreen extends StatefulWidget {
  final String email;
  final String otp;

  const CompleteDataScreen({super.key, required this.email, required this.otp});

  @override
  State<CompleteDataScreen> createState() => _CompleteDataScreenState();
}

class _CompleteDataScreenState extends State<CompleteDataScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  bool _validateFields() {
    if (_firstNameController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        "يرجى إدخال الاسم الأول"
      );
      return false;
    }

    if (_lastNameController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        "يرجى إدخال الاسم الأخير"
      );
      return false;
    }

    if (_phoneController.text.trim().isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        "يرجى إدخال رقم الجوال"
      );
      return false;
    }

    if (_passwordController.text.isEmpty) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        "يرجى إدخال كلمة المرور"
      );
      return false;
    }

    if (_passwordController.text.length < 8) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.weakPassword
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.passwordMismatch
      );
      return false;
    }

    return true;
  }

  void _completeRegistration() async {
    if (!_validateFields()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
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

      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null && response.data['data']['token'] != null) {
          var token = response.data['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          AlertUtils.showSuccessAlert(
            context,
            "نجاح",
            AlertUtils.successMessage
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          AlertUtils.showErrorAlert(
            context,
            "تنبيه",
            AlertUtils.serverError
          );
        }
      } else if (response.statusCode == 422) {
        if (response.data != null && response.data['message'] != null) {
          if (response.data['message'].toString().contains('phone')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.phoneAlreadyUsed
            );
          } else if (response.data['message'].toString().contains('email')) {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.duplicateEmail
            );
          } else {
            AlertUtils.showErrorAlert(
              context,
              "تنبيه",
              AlertUtils.formValidationError
            );
          }
        } else {
          AlertUtils.showErrorAlert(
            context,
            "تنبيه",
            AlertUtils.invalidInput
          );
        }
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
            // User Image
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

            // Title Text
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

            // Subtitle Text
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

            // First Name Field
            Positioned(
              top: 365,
              child: Container(
                width: 363,
                height: 76,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: TextField(
                  controller: _firstNameController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: "الاسم الأول",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF878383),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),

            // Last Name Field
            Positioned(
              top: 452,
              child: Container(
                width: 363,
                height: 76,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: TextField(
                  controller: _lastNameController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: "الاسم الأخير",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF878383),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),

            // Phone Field
            Positioned(
              top: 539,
              child: Container(
                width: 363,
                height: 76,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: TextField(
                  controller: _phoneController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "رقم الجوال",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF878383),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),

            // Password Field
            Positioned(
              top: 626,
              child: CustomPasswordField(
                controller: _passwordController,
                hintText: "كلمة المرور",
              ),
            ),

            // Confirm Password Field
            Positioned(
              top: 713,
              child: CustomPasswordField(
                controller: _confirmPasswordController,
                hintText: "تأكيد كلمة المرور",
              ),
            ),

            // Register Button
            Positioned(
              bottom: 40,
              child: SizedBox(
                width: 363,
                height: 76,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeRegistration,
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
          ],
        ),
      ),
    );
  }
}
