import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorksService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get All Works
  Future<Response> getAllWorks() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/works',
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
      throw Exception('Failed to get works: $e');
    }
  }

  // Get Works by Type
  Future<Response> getWorksByType(String type) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/works/show',
        queryParameters: {'type': type},
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
      throw Exception('Failed to get works by type: $e');
    }
  }
}
