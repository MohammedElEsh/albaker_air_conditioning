import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseService {
  final Dio dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Options> getAuthenticatedOptions() async {
    final token = await getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      },
    );
  }

  Future<Options> getUnauthenticatedOptions() async {
    return Options(
      headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
    );
  }

  // Helper method for authenticated GET requests
  Future<Response> authenticatedGet(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final options = await getAuthenticatedOptions();
      final response = await dio.get(
        '$baseUrl/$endpoint',
        options: options,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      throw Exception('Error during GET request to $endpoint: $e');
    }
  }

  // Helper method for authenticated POST requests
  Future<Response> authenticatedPost(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final options = await getAuthenticatedOptions();
      final response = await dio.post(
        '$baseUrl/$endpoint',
        options: options,
        queryParameters: queryParameters,
        data: data is FormData ? data : FormData.fromMap(data ?? {}),
      );
      return response;
    } catch (e) {
      throw Exception('Error during POST request to $endpoint: $e');
    }
  }

  // Helper method for unauthenticated GET requests
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final options = await getUnauthenticatedOptions();
      final response = await dio.get(
        '$baseUrl/$endpoint',
        options: options,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      throw Exception('Error during GET request to $endpoint: $e');
    }
  }

  // Helper method for unauthenticated POST requests
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final options = await getUnauthenticatedOptions();
      final response = await dio.post(
        '$baseUrl/$endpoint',
        options: options,
        data: data is FormData ? data : FormData.fromMap(data ?? {}),
      );
      return response;
    } catch (e) {
      throw Exception('Error during POST request to $endpoint: $e');
    }
  }
}
