import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // صورة في أعلى الصفحة
          Positioned(
            top: screenHeight * 0.13, // نسبة 13% من الشاشة
            left: screenWidth * 0.25, // نسبة 25% من عرض الشاشة
            child: Image.asset(
              'assets/images/image 2.png',
              width: screenWidth * 0.5, // نسبة 50% من عرض الشاشة
              height: screenHeight * 0.15, // نسبة 15% من ارتفاع الشاشة
              // errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 50),
            ),
          ),

          // نص "تسجيل الدخول"
          Positioned(
            top: screenHeight * 0.33, // 33% من ارتفاع الشاشة
            left: screenWidth * 0.3, // 30% من عرض الشاشة
            child: Text(
              "تسجيل الدخول",
              style: const TextStyle(
                fontSize: 25, // حجم الخط
                fontWeight: FontWeight.w800, // Extra Bold
                color: Colors.black,
              ),
            ),
          ),

          // نص "قم بإدخال بريدك الإلكتروني لتسجيل الدخول"
          Positioned(
            top: 370,
            left: 84,
            child: SizedBox(
              width: 262,
              child: Text(
                "قم بإدخال بريدك الإلكتروني لتسجيل الدخول",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.67, // 30px line-height
                  letterSpacing: 0,
                  color: Color(0xFF878383),
                ),
              ),
            ),
          ),




          // مستطيل إدخال البريد الإلكتروني
          Positioned(
            top: 480,
            left: 33,
            child: Container(
              width: 363,
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F7), // لون الخلفية
                borderRadius: BorderRadius.circular(38),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // حقل الإدخال
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress, // فتح كيبورد البريد الإلكتروني
                      textAlign: TextAlign.right, // محاذاة النص
                      decoration: InputDecoration(
                        border: InputBorder.none, // إزالة الحدود
                        hintText: "أدخل البريد الإلكتروني",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF878383),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // مسافة بين النص والخط
                  // الخط العمودي
                  Container(
                    width: 2,
                    height: 17,
                    color: Color(0x36000000),
                  ),
                  const SizedBox(width: 10), // مسافة بين الخط والأيقونة
                  // أيقونة البريد
                  Image.asset(
                    'assets/images/sms-tracking.png',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ),





          // مستطيل إدخال كلمة المرور
          Positioned(
            top: 580,
            left: 33,
            child: Container(
              width: 363,
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F7), // لون الخلفية
                borderRadius: BorderRadius.circular(38),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع العناصر بين اليمين واليسار
                children: [
                  // صورة على اليسار
                  Image.asset(
                    'assets/images/linear.png',
                    width: 24,
                    height: 24,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min, // تصغير المساحة إلى المحتوى فقط
                    children: [
                      // حقل إدخال كلمة المرور
                      SizedBox(
                        width: 200, // تحديد عرض مناسب
                        child: TextField(
                          textAlign: TextAlign.right, // محاذاة النص لليمين
                          obscureText: true, // إخفاء النص لكلمة المرور
                          decoration: InputDecoration(
                            hintText: "أدخل كلمة المرور",
                            border: InputBorder.none, // إزالة الحدود
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF878383),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // مسافة بين النص والخط
                      // الخط العمودي
                      Container(
                        width: 2,
                        height: 17,
                        color: Color(0x36000000), // لون الخط العمودي #00000036
                      ),
                      const SizedBox(width: 10), // مسافة بين الخط والأيقونة
                      // أيقونة القفل
                      Image.asset(
                        'assets/images/twotone.png', // تأكد من وجود الأيقونة في المسار الصحيح
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),





          // نص "هل نسيت كلمة المرور؟"
          Positioned(
            top: 700,
            left: 133,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: Text(
                "هل نسيت كلمة المرور؟",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  height: 1.0,
                  color: Color(0xFF25170B),
                  // decoration: TextDecoration.underline, // إضافة خط تحت النص
                ),
              ),
            ),
          ),

          Positioned(
            top: 750, // موضع الزر
            left: 35,
            child: SizedBox(
              width: 363,
              height: 76,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()), // الانتقال للشاشة الرئيسية
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D75B1), // اللون الأزرق المطلوب
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38), // تدوير الحواف
                  ),
                ),
                child: const Text(
                  "الدخول",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.0,
                    color: Colors.white, // لون الخط أبيض
                  ),
                ),
              ),
            ),
          ),


          // نص "ليس لديك حساب ؟"
          Positioned(
            top: 860,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Text(
                "ليس لديك حساب ؟",
                style: TextStyle(
                  fontSize: 18,
                  height: 1.67, // 30px line-height
                  letterSpacing: 0,
                  color: Color(0xFF878383),
                  // decoration: TextDecoration.underline, // إضافة خط تحت النص
                ),
              ),
            ),
          ),


          // نص "تسجيل حساب جديد"
          Positioned(
            top: 900, // موضع النص
            left: 120, // يمكن تعديل الموضع حسب الحاجة
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_back, // سهم لليسار
                    color: Color(0xFF1D75B1), // نفس لون النص
                    size: 20, // تكبير السهم قليلًا
                  ),
                  const SizedBox(width: 10), // مسافة بين السهم والنص
                  Text(
                    "تسجيل حساب جديد",
                    style: TextStyle(
                      fontSize: 20, // تكبير الخط قليلًا
                      fontWeight: FontWeight.w700, // جعل الخط أثقل
                      height: 1.67, // line-height 30px
                      letterSpacing: 0,
                      color: Color(0xFF1D75B1),
                    ),
                  ),
                ],
              ),
            ),
          ),




        ],
      ),
    );
  }
}