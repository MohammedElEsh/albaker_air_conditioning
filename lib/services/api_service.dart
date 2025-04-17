import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

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
}
