/// Service class that handles all user-related API operations.
///
/// This service manages:
/// - User authentication (login, register, logout)
/// - Profile management (get, update)
/// - Password operations (reset, change)
/// - OTP verification
/// - Token management
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// and include proper headers for JSON acceptance and Arabic language.
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  /// Dio instance for making HTTP requests
  final Dio _dio = Dio();

  /// Base URL for all API endpoints
  final String baseUrl = 'https://albakr-ac.com/api';

  /// Retrieves the stored authentication token from SharedPreferences.
  ///
  /// Returns:
  /// - String? containing the token if it exists
  /// - null if no token is stored
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Registers a new user with their email address.
  ///
  /// Parameters:
  /// - email: The user's email address
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if registration fails
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

  /// Sends an OTP (One-Time Password) to the user's email.
  ///
  /// Parameters:
  /// - email: The user's email address
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if OTP sending fails
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

  /// Verifies the OTP code entered by the user.
  ///
  /// Parameters:
  /// - email: The user's email address
  /// - otp: The OTP code to verify
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if OTP verification fails
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

  /// Completes the user registration process with additional information.
  ///
  /// Parameters:
  /// - firstName: User's first name
  /// - lastName: User's last name
  /// - phone: User's phone number
  /// - password: User's chosen password
  /// - passwordConfirmation: Confirmation of the password
  /// - email: User's email address
  /// - otp: The verified OTP code
  /// - fcmToken: Optional Firebase Cloud Messaging token
  ///
  /// Returns:
  /// - Response object containing the API response and authentication token
  ///
  /// Throws:
  /// - Exception if registration completion fails
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

  /// Authenticates a user with their email and password.
  ///
  /// Parameters:
  /// - email: User's email address
  /// - password: User's password
  ///
  /// Returns:
  /// - Response object containing the API response and authentication token
  ///
  /// Throws:
  /// - Exception if login fails
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

  /// Resets a user's password using OTP verification.
  ///
  /// Parameters:
  /// - email: User's email address
  /// - password: New password
  /// - passwordConfirmation: Confirmation of the new password
  /// - otp: The verified OTP code
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if password reset fails
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

  /// Retrieves the user's profile information.
  ///
  /// Returns:
  /// - Response object containing the user's profile data
  ///
  /// Throws:
  /// - Exception if profile retrieval fails
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

  /// Updates the user's profile information.
  ///
  /// Parameters:
  /// - firstName: Optional new first name
  /// - lastName: Optional new last name
  /// - phone: Optional new phone number
  ///
  /// Returns:
  /// - Response object containing the updated profile data
  ///
  /// Throws:
  /// - Exception if profile update fails
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

  /// Changes the user's password.
  ///
  /// Parameters:
  /// - currentPassword: User's current password
  /// - password: New password
  /// - passwordConfirmation: Confirmation of the new password
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if password change fails
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

  /// Logs out the current user and invalidates their token.
  ///
  /// Returns:
  /// - Response object containing the API response
  ///
  /// Throws:
  /// - Exception if logout fails
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
