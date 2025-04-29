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

  // Get Works By Type
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

  // Store Ask Price
  Future<Response> storeAskPrice({
    required int categoryId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String message,
  }) async {
    try {
      final data = {
        'category_id': categoryId,
        'f_name': firstName,
        'l_name': lastName,
        'email': email,
        'phone': phone,
        'message': message,
      };

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/ask_price/store',
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
      throw Exception('Failed to store ask price: $e');
    }
  }

  // Get Ask Price Categories
  Future<Response> getAskPriceCategories() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/ask_price/categories',
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
      throw Exception('Failed to get ask price categories: $e');
    }
  }
}
