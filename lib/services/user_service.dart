import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Register with email
  Future<Response> register(String email) async {
    try {
      final data = {'email': email};
      final response = await _dio.post(
        '$baseUrl/register',
        data: FormData.fromMap(data),
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Send OTP
  Future<Response> sendOtp(String email) async {
    try {
      final response = await _dio.get(
        '$baseUrl/send/otp',
        queryParameters: {'email': email},
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Check OTP
  Future<Response> checkOtp(String email, String otp) async {
    try {
      final response = await _dio.get(
        '$baseUrl/check/otp',
        queryParameters: {'email': email, 'otp': otp},
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to check OTP: $e');
    }
  }

  // Complete Registration
  Future<Response> completeRegister({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String email,
    required String otp,
    String? fcmToken,
  }) async {
    try {
      final data = {
        'f_name': firstName,
        'l_name': lastName,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'email': email,
        'otp': otp,
      };

      if (fcmToken != null) {
        data['fcm_token'] = fcmToken;
      }

      final response = await _dio.post(
        '$baseUrl/complete/register',
        data: FormData.fromMap(data),
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to complete registration: $e');
    }
  }

  // Login
  Future<Response> login(String email, String password) async {
    try {
      final data = {'email': email, 'password': password};
      final response = await _dio.post(
        '$baseUrl/login',
        data: FormData.fromMap(data),
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Reset Password
  Future<Response> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String otp,
  }) async {
    try {
      final data = {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'otp': otp,
      };

      final response = await _dio.post(
        '$baseUrl/resetPassword',
        data: FormData.fromMap(data),
        options: Options(
          headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  // Get Profile
  Future<Response> getProfile() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Update Profile
  Future<Response> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final formData = FormData();

      if (firstName != null && firstName.isNotEmpty) {
        formData.fields.add(MapEntry('f_name', firstName));
      }

      if (lastName != null && lastName.isNotEmpty) {
        formData.fields.add(MapEntry('l_name', lastName));
      }

      if (phone != null && phone.isNotEmpty) {
        formData.fields.add(MapEntry('phone', phone));
      }

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/update/profile',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Change Password
  Future<Response> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final data = {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/change/password',
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  // Logout
  Future<Response> logout() async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Delete Account
  Future<Response> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final data = {'email': email, 'password': password};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/deleteAccount',
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // Clear Token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ===== ADDRESS METHODS =====

  // Get Areas
  Future<Response> getAreas() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/areas',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get areas: $e');
    }
  }

  // Get Cities by Area ID
  Future<Response> getCities(int areaId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/cities/$areaId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get cities: $e');
    }
  }

  // Get Towns by City ID
  Future<Response> getTowns(int cityId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/towns/$cityId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get towns: $e');
    }
  }

  // Add Address
  Future<Response> addAddress({
    required int townId,
    required String street,
    required String buildingNum,
    required String landmark,
  }) async {
    try {
      final data = {
        'town_id': townId,
        'street': street,
        'building_num': buildingNum,
        'landmark': landmark,
      };

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/add/address',
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  // Update Address
  Future<Response> updateAddress({
    required int addressId,
    required int townId,
    required String street,
    required String buildingNum,
    required String landmark,
  }) async {
    try {
      final data = {
        'address_id': addressId,
        'town_id': townId,
        'street': street,
        'building_num': buildingNum,
        'landmark': landmark,
      };

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/update/address',
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  // Delete Address
  Future<Response> deleteAddress(int addressId) async {
    try {
      final data = {'address_id': addressId};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/delete/address',
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  // Get User Addresses
  Future<Response> getAddresses() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/addresses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }
}