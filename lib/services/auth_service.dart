import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'https://tmwel.fun/api';
  final http.Client _client = http.Client();

  // تسجيل مستخدم جديد (الخطوة الأولى: إرسال البريد الإلكتروني)
  Future<void> signUp(String email) async {
    try {
      print('إرسال طلب تسجيل إلى: $baseUrl/register');

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        body: {'email': email},
      );

      // طباعة استجابة الخادم للتصحيح
      print('استجابة الخادم: ${response.statusCode} ${response.body}');

      // التحقق من وجود استجابة
      if (response.body.isEmpty) {
        throw Exception('استجابة فارغة من الخادم');
      }

      final data = json.decode(response.body);
      if (response.statusCode != 200) {
        throw Exception(
          data['message'] ??
              'فشل في التسجيل (رمز الحالة: ${response.statusCode})',
        );
      }

      // طباعة نجاح العملية
      print('تم التسجيل بنجاح');
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('خطأ في الاتصال بالخادم: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('خطأ في تنسيق البيانات المستلمة من الخادم');
      } else if (e.toString().contains('Exception:')) {
        // إعادة إرسال الخطأ كما هو إذا كان محدداً بالفعل
        rethrow;
      } else {
        throw Exception('فشل في الاتصال بالخادم: ${e.toString()}');
      }
    }
  }

  // إرسال رمز التحقق
  Future<void> sendOtp(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/send/otp?email=$email'),
      headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'فشل في إرسال رمز التحقق');
    }
  }

  // التحقق من رمز التحقق
  Future<void> checkOtp(String email, String otp) async {
    final response = await http.get(
      Uri.parse('$baseUrl/check/otp?email=$email&otp=$otp'),
      headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'رمز التحقق غير صحيح');
    }
  }

  // إكمال عملية التسجيل (إرسال بيانات المستخدم الكاملة)
  Future<void> completeRegistration(UserModel user) async {
    try {
      print('إرسال طلب إكمال التسجيل إلى: $baseUrl/complete/register');

      final userData = user.toJson();
      print('البيانات المرسلة: $userData');
      print('البيانات المرسلة بصيغة JSON: ${json.encode(userData)}');

      // استخدام http.Client
      final client = http.Client();

      try {
        final response = await client.post(
          Uri.parse('$baseUrl/complete/register'),
          headers: {
            'Accept': 'application/json',
            'Accept-Language': 'ar',
            'Content-Type': 'application/json',
          },
          body: json.encode(userData),
        );

        print('استجابة الخادم: الرمز - ${response.statusCode}');
        print('استجابة الخادم: الـHeaders - ${response.headers}');
        print('استجابة الخادم: النص - ${response.body}');

        // التحقق من وجود استجابة
        if (response.body.isEmpty) {
          throw Exception('استجابة فارغة من الخادم');
        }

        final data = json.decode(response.body);
        print('استجابة الخادم بعد التحويل إلى JSON: $data');

        // نجح الطلب
        if (response.statusCode == 200) {
          print('تم إكمال التسجيل بنجاح');
          return;
        }
        // فشل الطلب
        else {
          String errorMessage =
              'فشل في إكمال التسجيل (رمز الحالة: ${response.statusCode})';

          if (data is Map<String, dynamic>) {
            if (data.containsKey('message')) {
              if (data['message'] is String) {
                errorMessage = data['message'];
              } else if (data['message'] is Map) {
                errorMessage = _formatMapErrors(data['message']);
              }
            } else if (data.containsKey('error')) {
              errorMessage = data['error'].toString();
            }
          }

          throw Exception(errorMessage);
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('خطأ في إكمال التسجيل: $e');
      if (e is http.ClientException) {
        throw Exception('خطأ في الاتصال بالخادم: ${e.message}');
      } else if (e is FormatException) {
        throw Exception('خطأ في تنسيق البيانات المستلمة من الخادم');
      } else if (e.toString().contains('Exception:')) {
        rethrow;
      } else {
        throw Exception('فشل في إكمال البيانات: ${e.toString()}');
      }
    }
  }

  // مساعدة لتنسيق أخطاء Map
  String _formatMapErrors(Map<String, dynamic> errors) {
    final errorsList = <String>[];

    errors.forEach((key, value) {
      if (value is List) {
        for (var error in value) {
          errorsList.add(error.toString());
        }
      } else {
        errorsList.add(value.toString());
      }
    });

    return errorsList.join(', ');
  }

  // تسجيل الدخول
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        body: {'email': email, 'password': password},
      );

      // التحقق من استجابة الخادم
      if (response.body.isEmpty) {
        throw Exception('استجابة فارغة من الخادم');
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          data['message'] ?? 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }

      // تحقق من وجود token
      final String token = data['token']?.toString() ?? '';

      // تحقق من وجود data في الاستجابة
      if (data['data'] == null) {
        // إذا كانت data غير موجودة، إنشاء UserModel بقيم افتراضية
        return UserModel(
          id: '0',
          firstName: '',
          lastName: '',
          email: email,
          phone: '',
          password: '',
          confirmPassword: '',
          token: token,
        );
      }

      try {
        return UserModel.fromJson(data['data']);
      } catch (e) {
        // إذا حدث خطأ أثناء تحليل البيانات، إنشاء نموذج بقيم افتراضية
        return UserModel(
          id: '0',
          firstName: data['data']['f_name']?.toString() ?? '',
          lastName: data['data']['l_name']?.toString() ?? '',
          email: email,
          phone: data['data']['phone']?.toString() ?? '',
          password: '',
          confirmPassword: '',
          token: token,
        );
      }
    } catch (e) {
      throw Exception('فشل في الاتصال بالخادم: ${e.toString()}');
    }
  }

  // نسيت كلمة المرور (إرسال رمز تحقق)
  Future<void> forgotPassword(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/send/otp?email=$email'),
      headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'فشل في إرسال رمز التحقق');
    }
  }

  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(
    String email,
    String password,
    String confirmPassword,
    String otp,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resetPassword'),
      headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
      body: {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'otp': otp,
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'فشل في إعادة تعيين كلمة المرور');
    }
  }
}
