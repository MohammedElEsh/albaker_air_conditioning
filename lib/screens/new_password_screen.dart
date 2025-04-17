import 'package:flutter/material.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/custom_password_field.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

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
  final ApiService _apiService = ApiService();

  void _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    try {
      var response = await _apiService.resetPassword({
        'email': widget.email,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
        'otp': widget.otp,
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل تغيير كلمة المرور')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
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
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomRectangle(),
            ),

            // Eye unlock image
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
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D75B1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  child: const Text(
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
