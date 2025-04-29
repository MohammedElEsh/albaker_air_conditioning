import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AskPriceService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Ask Price Categories
  Future<Response> getCategories() async {
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

  // Store Ask Price Request
  Future<Response> storeRequest({
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
      throw Exception('Failed to store ask price request: $e');
    }
  }
}
