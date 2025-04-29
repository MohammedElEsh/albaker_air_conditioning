import 'package:flutter/material.dart';
import '../widgets/custom_rectangle.dart';
import 'new_password_screen.dart';
import '../services/user_service.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final UserService _userService = UserService();

  void _verifyCode() async {
    // تحقق من أن جميع حقول OTP مملوءة
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال جميع أرقام كود التحقق')),
        );
        return;
      }
    }

    String otp = controllers.map((c) => c.text).join();
    try {
      var response = await _userService.checkOtp(widget.email, otp);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewPasswordScreen(email: widget.email, otp: otp),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('كود التحقق غير صحيح')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  void _resendCode() async {
    try {
      await _userService.sendOtp(widget.email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال الكود مرة أخرى')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
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
              left: 35,
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
