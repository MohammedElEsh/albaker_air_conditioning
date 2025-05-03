import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertUtils {
  static void showErrorAlert(BuildContext context, String title, String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
        ),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descTextAlign: TextAlign.center,
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "حسناً",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Almarai',
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red,
          radius: BorderRadius.circular(8.0),
        ),
      ],
    ).show();
  }

  static void showSuccessAlert(BuildContext context, String title, String message) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      desc: message,
      style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
        ),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descTextAlign: TextAlign.center,
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "حسناً",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Almarai',
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.green,
          radius: BorderRadius.circular(8.0),
        ),
      ],
    ).show();
  }

  static void showWarningAlert(BuildContext context, String title, String message) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      desc: message,
      style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
        ),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descTextAlign: TextAlign.center,
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "حسناً",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Almarai',
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.orange,
          radius: BorderRadius.circular(8.0),
        ),
      ],
    ).show();
  }

  static void showInfoAlert(BuildContext context, String title, String message) {
    Alert(
      context: context,
      type: AlertType.info,
      title: title,
      desc: message,
      style: AlertStyle(
        titleStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
        ),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        descTextAlign: TextAlign.center,
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "حسناً",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Almarai',
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
          radius: BorderRadius.circular(8.0),
        ),
      ],
    ).show();
  }

  // Common alert messages
  static const String networkError = "لا يمكن الاتصال بالإنترنت حالياً. تحقق من الشبكة وحاول مرة أخرى.";
  static const String loginError = "فشل تسجيل الدخول. تحقق من البريد الإلكتروني وكلمة المرور.";
  static const String invalidEmailLogin = "البريد الإلكتروني غير مسجل. يرجى إنشاء حساب جديد أو المحاولة بعنوان مختلف.";
  static const String invalidPasswordLogin = "كلمة المرور غير صحيحة. تأكد من كتابتها بشكل صحيح.";
  static const String invalidEmail = "صيغة البريد الإلكتروني غير صحيحة. يرجى المحاولة بعنوان صحيح.";
  static const String invalidPassword = "كلمة المرور المدخلة غير صحيحة.";
  static const String serverError = "حدث خطأ في الخادم. يرجى المحاولة لاحقاً.";
  static const String sessionExpired = "انتهت الجلسة. يرجى تسجيل الدخول مجددًا للمتابعة.";
  static const String requiredFields = "يرجى ملء جميع الحقول المطلوبة.";
  static const String successMessage = "تمت العملية بنجاح.";
  static const String deleteConfirmation = "هل أنت متأكد من رغبتك في حذف هذا العنصر؟ لا يمكن التراجع عن هذه العملية.";
  static const String saveConfirmation = "هل ترغب بحفظ التغييرات قبل المتابعة؟";
  static const String verificationCodeError = "رمز التحقق غير صحيح. تأكد من الرمز وأعد المحاولة.";
  static const String verificationCodeEmpty = "يرجى إدخال رمز التحقق المكون من 5 أرقام.";
  static const String verificationCodeSent = "تم إرسال رمز التحقق إلى بريدك الإلكتروني.";
  static const String verificationCodeResent = "تم إرسال رمز تحقق جديد بنجاح.";
  static const String passwordMismatch = "كلمتا المرور غير متطابقتين.";
  static const String registrationFailed = "فشل إنشاء الحساب. يرجى المحاولة لاحقاً.";
  static const String passwordResetFailed = "تعذر إعادة تعيين كلمة المرور. تحقق من البيانات وأعد المحاولة.";
  static const String profileUpdateSuccess = "تم تحديث الملف الشخصي بنجاح.";
  static const String profileUpdateFailed = "فشل تحديث البيانات الشخصية. تحقق من المعلومات وأعد المحاولة.";
  static const String passwordChangeSuccess = "تم تغيير كلمة المرور بنجاح.";
  static const String passwordChangeFailed = "فشل تغيير كلمة المرور. تأكد من كلمة المرور الحالية.";
  static const String accountDeleteSuccess = "تم حذف الحساب بنجاح.";
  static const String accountDeleteFailed = "فشل حذف الحساب. تحقق من البيانات وحاول مرة أخرى.";
  static const String logoutSuccess = "تم تسجيل الخروج بنجاح.";
  static const String logoutFailed = "حدث خطأ أثناء تسجيل الخروج. حاول مرة أخرى.";
  static const String otpSendFailed = "تعذر إرسال رمز التحقق. يرجى المحاولة مرة أخرى.";
  static const String invalidOtpFormat = "رمز التحقق يجب أن يتكون من 5 أرقام.";
  static const String emailNotFound = "البريد الإلكتروني غير موجود في قاعدة البيانات.";
  static const String invalidPhoneNumber = "رقم الجوال غير صالح. أدخل رقماً بصيغة صحيحة.";
  static const String duplicateEmail = "البريد الإلكتروني مستخدم بالفعل.";
  static const String weakPassword = "كلمة المرور ضعيفة. استخدم 8 أحرف على الأقل تشمل أحرف كبيرة، صغيرة وأرقام.";
  static const String invalidInput = "البيانات المدخلة غير صالحة. يرجى التأكد منها.";
  static const String generalError = "حدث خطأ غير متوقع. حاول لاحقًا.";
  static const String newOtpSent = "تم إرسال رمز تحقق جديد إلى بريدك الإلكتروني.";
  static const String loadingMessage = "جاري المعالجة... يرجى الانتظار.";
  static const String noInternet = "أنت غير متصل حالياً بالإنترنت.";
  static const String noDataFound = "لم يتم العثور على بيانات لعرضها.";
  static const String unauthorizedAccess = "ليس لديك صلاحية للوصول إلى هذا المحتوى.";
  static const String underMaintenance = "الخدمة حالياً تحت الصيانة. يرجى المحاولة لاحقاً.";
  static const String featureComingSoon = "هذه الميزة قيد التطوير. ترقبها قريباً!";
  static const String uploadFailed = "فشل في رفع الملف. يرجى المحاولة مرة أخرى.";
  static const String downloadFailed = "فشل في تحميل الملف. تحقق من الاتصال أو حاول لاحقاً.";
  static const String formValidationError = "يرجى التأكد من صحة البيانات المدخلة.";
  static const String actionNotAllowed = "لا يمكن تنفيذ هذا الإجراء حالياً.";
  static const String emailSent = "تم إرسال رسالة إلى بريدك الإلكتروني.";
  static const String alreadyLoggedIn = "أنت بالفعل مسجل دخول.";
  static const String phoneAlreadyUsed = "رقم الهاتف مستخدم مسبقاً.";
  static const String invalidCredentials = "بيانات الدخول غير صحيحة.";
  static const String termsNotAccepted = "يجب الموافقة على الشروط والأحكام للمتابعة.";
  }
