import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Login API
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Register API
  Future<Response> register(String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/register',
        data: {'email': email},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Complete Registration API
  Future<Response> completeRegister(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '$baseUrl/complete/register',
        data: data,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to complete registration: $e');
    }
  }

  // Reset Password API
  Future<Response> resetPassword(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$baseUrl/resetPassword', data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Send OTP API
  Future<Response> sendOtp(String email) async {
    try {
      final response = await _dio.get(
        '$baseUrl/send/otp',
        queryParameters: {'email': email},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Check OTP API
  Future<Response> checkOtp(String email, String otp) async {
    try {
      final response = await _dio.get(
        '$baseUrl/check/otp',
        queryParameters: {'email': email, 'otp': otp},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  // Get Profile API
  Future<Response> getProfile() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update Profile API
  Future<Response> updateProfile(
    String firstName,
    String lastName,
    String phone,
  ) async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/update/profile',
        data: {'f_name': firstName, 'l_name': lastName, 'phone': phone},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Change Password API
  Future<Response> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/change/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Logout API
  Future<Response> logout() async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Delete Account API
  Future<Response> deleteAccount(String email, String password) async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/deleteAccount',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
