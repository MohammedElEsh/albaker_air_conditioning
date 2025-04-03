import 'package:flutter/material.dart';
import '../widgets/custom_password_field.dart';

class CompleteDataScreen extends StatefulWidget {
  final String email;

  const CompleteDataScreen({super.key, required this.email});

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
  // bool _isPasswordVisible = false;
  // bool _isConfirmPasswordVisible = false;

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

            // Confirm Button
            Positioned(
              top: 820,
              child: SizedBox(
                width: 363,
                height: 76,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle data completion
                  },
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
