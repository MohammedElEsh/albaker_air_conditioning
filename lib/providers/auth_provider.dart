import 'package:flutter/material.dart';
import '../models/user_model.dart';
// import '../models/api_response_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _error = '';
  UserModel? _user;
  String _email = '';
  String _otp = '';

  // الحصول على البيانات
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get error => _error;
  UserModel? get user => _user;
  String get email => _email;
  String get otp => _otp;

  // تعيين حالة التحميل
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // تعيين رسالة الخطأ
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  // تعيين البريد الإلكتروني للاستخدام في مراحل التسجيل المختلفة
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // تعيين رمز التحقق للاستخدام في مراحل التسجيل المختلفة
  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> checkAuthStatus() async {
    setLoading(true);
    try {
      _isAuthenticated = await _authService.isLoggedIn();

      if (_isAuthenticated) {
        _user = await _storageService.getUserData();
      }

      setLoading(false);
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      setError('حدث خطأ أثناء التحقق من حالة تسجيل الدخول: $e');
      setLoading(false);
      return false;
    }
  }

  // تسجيل الدخول
  Future<bool> login(String email, String password) async {
    setLoading(true);
    setError('');

    try {
      final response = await _authService.login(email, password);

      if (response.isSuccess) {
        _user = response.data;
        _isAuthenticated = true;
        setLoading(false);
        notifyListeners();
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء تسجيل الدخول: $e');
      setLoading(false);
      return false;
    }
  }

  // إرسال رمز التحقق
  Future<bool> sendOtp(String email) async {
    setLoading(true);
    setError('');
    setEmail(email); // حفظ البريد للاستخدام في الخطوات اللاحقة

    try {
      final response = await _authService.sendOtp(email);

      if (response.isSuccess) {
        _authService.showToast(response.message);
        setLoading(false);
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء إرسال رمز التحقق: $e');
      setLoading(false);
      return false;
    }
  }

  // التحقق من رمز التحقق
  Future<bool> checkOtp(String otp) async {
    setLoading(true);
    setError('');
    setOtp(otp); // حفظ الرمز للاستخدام في الخطوات اللاحقة

    try {
      final response = await _authService.checkOtp(_email, otp);

      if (response.isSuccess) {
        _authService.showToast(response.message);
        setLoading(false);
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء التحقق من الرمز: $e');
      setLoading(false);
      return false;
    }
  }

  // التسجيل (الخطوة الأولى)
  Future<bool> register(String email) async {
    setLoading(true);
    setError('');
    setEmail(email); // حفظ البريد للاستخدام في الخطوات اللاحقة

    try {
      final response = await _authService.register(email);

      if (response.isSuccess) {
        _authService.showToast(response.message);
        setLoading(false);
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء التسجيل: $e');
      setLoading(false);
      return false;
    }
  }

  // استكمال التسجيل
  Future<bool> completeRegister({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String fcmToken,
  }) async {
    setLoading(true);
    setError('');

    try {
      final response = await _authService.completeRegister(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        email: _email,
        otp: _otp,
        fcmToken: fcmToken,
      );

      if (response.isSuccess) {
        _user = response.data;
        _isAuthenticated = true;
        _authService.showToast(response.message);
        setLoading(false);
        notifyListeners();
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء استكمال التسجيل: $e');
      setLoading(false);
      return false;
    }
  }

  // إعادة تعيين كلمة المرور
  Future<bool> resetPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    setLoading(true);
    setError('');

    try {
      final response = await _authService.resetPassword(
        email: _email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        otp: _otp,
      );

      if (response.isSuccess) {
        _authService.showToast(response.message);
        setLoading(false);
        return true;
      } else {
        setError(response.message);
        setLoading(false);
        return false;
      }
    } catch (e) {
      setError('حدث خطأ أثناء إعادة تعيين كلمة المرور: $e');
      setLoading(false);
      return false;
    }
  }

  // تسجيل الخروج
  Future<bool> logout() async {
    setLoading(true);
    setError('');

    try {
      final response = await _authService.logout();

      // بغض النظر عن نتيجة الطلب، نقوم بتسجيل الخروج محلياً
      _user = null;
      _isAuthenticated = false;

      if (response.isSuccess) {
        _authService.showToast(response.message);
      } else {
        setError(response.message);
      }

      setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _user = null;
      _isAuthenticated = false;
      setError('حدث خطأ أثناء تسجيل الخروج: $e');
      setLoading(false);
      notifyListeners();
      return false;
    }
  }
}
