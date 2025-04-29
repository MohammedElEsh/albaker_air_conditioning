import 'package:dio/dio.dart';
import 'api_base_service.dart';

class AskPriceService extends ApiBaseService {
  // Get Ask Price Categories
  Future<Response> getCategories() async {
    try {
      return await authenticatedGet('ask_price/categories');
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

      return await authenticatedPost('ask_price/store', data: data);
    } catch (e) {
      throw Exception('Failed to store ask price request: $e');
    }
  }
}
