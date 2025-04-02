import 'package:flutter/material.dart';
import '../widgets/custom_password_field.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'verification_code_screen.dart';
import 'home_screen.dart';
import 'auth_screen.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCompleteData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. إنشاء نموذج المستخدم
      final user = UserModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: widget.email,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      // طباعة بيانات المستخدم للتصحيح
      print('بيانات المستخدم المراد تسجيلها:');
      print('الاسم الأول: ${user.firstName}');
      print('الاسم الأخير: ${user.lastName}');
      print('البريد الإلكتروني: ${user.email}');
      print('رقم الجوال: ${user.phone}');
      print('كلمة المرور: ${user.password.length} أحرف');

      // محاولة إكمال التسجيل
      try {
        await _authService.completeRegistration(user);

        if (mounted) {
          // عرض رسالة نجاح
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل البيانات بنجاح، يمكنك الآن تسجيل الدخول'),
              backgroundColor: Colors.green,
            ),
          );

          // الانتقال إلى شاشة تسجيل الدخول
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
          );
        }
      } catch (error) {
        print('خطأ في إكمال التسجيل: $error');

        if (mounted) {
          // تجهيز رسالة الخطأ
          String errorMsg = error.toString().replaceAll('Exception: ', '');

          // عرض حوار مع خيار المحاولة مرة أخرى أو العودة لشاشة تسجيل الدخول
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('فشل في إكمال التسجيل'),
                  content: Text(errorMsg),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // إغلاق الحوار
                        setState(() {
                          _isLoading =
                              false; // إرجاع زر التأكيد إلى حالته العادية
                        });
                      },
                      child: const Text('حاول مرة أخرى'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // إغلاق الحوار
                        // الانتقال إلى شاشة تسجيل الدخول
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('الذهاب لتسجيل الدخول'),
                    ),
                  ],
                ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        // طباعة الخطأ للتصحيح
        print('خطأ في التسجيل: $e');

        // عرض رسالة الخطأ الفعلية للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                  child: TextFormField(
                    controller: _firstNameController,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الأول';
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: _lastNameController,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الأخير';
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: _phoneController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الجوال';
                      }
                      return null;
                    },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 8) {
                      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
              ),

              // Confirm Password Field
              Positioned(
                top: 713,
                child: CustomPasswordField(
                  controller: _confirmPasswordController,
                  hintText: "تأكيد كلمة المرور",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
              ),

              // Confirm Button
              Positioned(
                top: 820,
                child: SizedBox(
                  width: 363,
                  height: 76,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCompleteData,
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
      ),
    );
  }
}
