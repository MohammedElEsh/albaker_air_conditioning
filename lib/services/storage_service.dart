import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage();

  // تخزين بيانات المستخدم
  Future<bool> saveUserData(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // تخزين بيانات المستخدم
      await prefs.setString(Constants.userDataKey, jsonEncode(user.toJson()));

      // تخزين حالة تسجيل الدخول
      await prefs.setBool(Constants.isLoggedInKey, true);

      // تخزين رمز الوصول بطريقة آمنة
      if (user.token != null) {
        await _secureStorage.write(key: Constants.tokenKey, value: user.token);
      }

      return true;
    } catch (e) {
      print('حدث خطأ أثناء حفظ بيانات المستخدم: $e');
      return false;
    }
  }

  // الحصول على بيانات المستخدم
  Future<UserModel?> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString(Constants.userDataKey);

      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }

      return null;
    } catch (e) {
      print('حدث خطأ أثناء استرجاع بيانات المستخدم: $e');
      return null;
    }
  }

  // الحصول على رمز الوصول
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: Constants.tokenKey);
    } catch (e) {
      print('حدث خطأ أثناء استرجاع رمز الوصول: $e');
      return null;
    }
  }

  // التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(Constants.isLoggedInKey) ?? false;
    } catch (e) {
      print('حدث خطأ أثناء التحقق من حالة تسجيل الدخول: $e');
      return false;
    }
  }

  // حذف بيانات المستخدم عند تسجيل الخروج
  Future<bool> clearUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.remove(Constants.userDataKey);
      await prefs.setBool(Constants.isLoggedInKey, false);
      await _secureStorage.delete(key: Constants.tokenKey);

      return true;
    } catch (e) {
      print('حدث خطأ أثناء حذف بيانات المستخدم: $e');
      return false;
    }
  }
}
