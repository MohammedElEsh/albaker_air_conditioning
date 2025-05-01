import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Project Categories
  Future<Response> getProjectCategories() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/project/categories',
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
      throw Exception('Failed to get project categories: $e');
    }
  }

  // Get Projects by Category
  Future<Response> getProjectsByCategory(int categoryId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/project/show',
        queryParameters: {'category_id': categoryId},
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
      throw Exception('Failed to get projects by category: $e');
    }
  }
}
