import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/api_response_model.dart';
import '../utils/constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // تسجيل الدخول
  Future<ApiResponseModel<UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      // إنشاء FormData للطلب
      final formData = FormData.fromMap({'email': email, 'password': password});

      // إرسال طلب تسجيل الدخول
      final response = await _apiService.post<UserModel>(
        endpoint: Constants.loginEndpoint,
        data: formData,
        fromJson: (data) => UserModel.fromJson(data),
      );

      // إذا كان التسجيل ناجحاً، قم بحفظ بيانات المستخدم
      if (response.isSuccess && response.data != null) {
        await _storageService.saveUserData(response.data!);
        _apiService.setAuthToken(response.data!.token!);
      }

      return response;
    } catch (e) {
      return ApiResponseModel<UserModel>(
        status: 500,
        message: 'حدث خطأ أثناء تسجيل الدخول: $e',
      );
    }
  }

  // إرسال رمز التحقق
  Future<ApiResponseModel<Map<String, dynamic>>> sendOtp(String email) async {
    try {
      // إرسال طلب رمز التحقق
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${Constants.sendOtpEndpoint}',
        queryParameters: {'email': email},
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponseModel<Map<String, dynamic>>(
        status: 500,
        message: 'حدث خطأ أثناء إرسال رمز التحقق: $e',
      );
    }
  }

  // التحقق من رمز التحقق
  Future<ApiResponseModel<Map<String, dynamic>>> checkOtp(
    String email,
    String otp,
  ) async {
    try {
      // إرسال طلب التحقق من الرمز
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '${Constants.checkOtpEndpoint}',
        queryParameters: {'email': email, 'otp': otp},
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponseModel<Map<String, dynamic>>(
        status: 500,
        message: 'حدث خطأ أثناء التحقق من الرمز: $e',
      );
    }
  }

  // تسجيل مستخدم جديد
  Future<ApiResponseModel<Map<String, dynamic>>> register(String email) async {
    try {
      // إنشاء FormData للطلب
      final formData = FormData.fromMap({'email': email});

      // إرسال طلب التسجيل
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: Constants.registerEndpoint,
        data: formData,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponseModel<Map<String, dynamic>>(
        status: 500,
        message: 'حدث خطأ أثناء تسجيل المستخدم: $e',
      );
    }
  }

  // استكمال تسجيل المستخدم الجديد
  Future<ApiResponseModel<UserModel>> completeRegister({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String email,
    required String otp,
    required String fcmToken,
  }) async {
    try {
      // إنشاء FormData للطلب
      final formData = FormData.fromMap({
        'f_name': firstName,
        'l_name': lastName,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'email': email,
        'otp': otp,
        'fcm_token': fcmToken,
      });

      // إرسال طلب استكمال التسجيل
      final response = await _apiService.post<UserModel>(
        endpoint: Constants.completeRegisterEndpoint,
        data: formData,
        fromJson: (data) => UserModel.fromJson(data),
      );

      // إذا كان التسجيل ناجحاً، قم بحفظ بيانات المستخدم
      if (response.isSuccess && response.data != null) {
        await _storageService.saveUserData(response.data!);
        _apiService.setAuthToken(response.data!.token!);
      }

      return response;
    } catch (e) {
      return ApiResponseModel<UserModel>(
        status: 500,
        message: 'حدث خطأ أثناء استكمال التسجيل: $e',
      );
    }
  }

  // إعادة تعيين كلمة المرور
  Future<ApiResponseModel<Map<String, dynamic>>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String otp,
  }) async {
    try {
      // إنشاء FormData للطلب
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'otp': otp,
      });

      // إرسال طلب إعادة تعيين كلمة المرور
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: Constants.resetPasswordEndpoint,
        data: formData,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponseModel<Map<String, dynamic>>(
        status: 500,
        message: 'حدث خطأ أثناء إعادة تعيين كلمة المرور: $e',
      );
    }
  }

  // تسجيل الخروج
  Future<ApiResponseModel<Map<String, dynamic>>> logout() async {
    try {
      // الحصول على بيانات المستخدم
      final UserModel? user = await _storageService.getUserData();

      if (user == null || user.email == null) {
        return ApiResponseModel<Map<String, dynamic>>(
          status: 400,
          message: 'لا توجد بيانات مستخدم متاحة',
        );
      }

      // إنشاء FormData للطلب
      final formData = FormData.fromMap({'email': user.email});

      // إرسال طلب تسجيل الخروج
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: Constants.logoutEndpoint,
        data: formData,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      // حذف بيانات المستخدم المحلية بغض النظر عن نتيجة الطلب
      await _storageService.clearUserData();
      _apiService.clearAuthToken();

      return response;
    } catch (e) {
      // حذف بيانات المستخدم المحلية حتى في حالة الخطأ
      await _storageService.clearUserData();
      _apiService.clearAuthToken();

      return ApiResponseModel<Map<String, dynamic>>(
        status: 500,
        message: 'حدث خطأ أثناء تسجيل الخروج: $e',
      );
    }
  }

  // عرض رسالة توست للمستخدم
  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    final isLoggedIn = await _storageService.isLoggedIn();

    if (isLoggedIn) {
      // استرجاع التوكن وتعيينه في خدمة API
      final token = await _storageService.getToken();
      if (token != null) {
        _apiService.setAuthToken(token);
        return true;
      }
    }

    return false;
  }
}
