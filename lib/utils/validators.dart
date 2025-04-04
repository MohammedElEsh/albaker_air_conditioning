class Validators {
  // التحقق من صحة البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صحيح';
    }

    return null;
  }

  // التحقق من صحة كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }

    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    return null;
  }

  // التحقق من صحة الاسم
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    return null;
  }

  // التحقق من صحة رقم الهاتف
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الهاتف';
    }

    if (value.length < 10) {
      return 'الرجاء إدخال رقم هاتف صحيح';
    }

    return null;
  }

  // التحقق من تطابق كلمة المرور
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    }

    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }

    return null;
  }

  // التحقق من صحة الرمز
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رمز التحقق';
    }

    if (value.length != 5) {
      return 'رمز التحقق يجب أن يكون 5 أرقام';
    }

    return null;
  }
}
