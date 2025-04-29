import 'package:dio/dio.dart';
import 'api_base_service.dart';

class ProjectService extends ApiBaseService {
  // Get Project Categories
  Future<Response> getProjectCategories() async {
    try {
      return await authenticatedGet('project/categories');
    } catch (e) {
      throw Exception('Failed to get project categories: $e');
    }
  }

  // Get Projects by Category
  Future<Response> getProjectsByCategory(int categoryId) async {
    try {
      return await authenticatedGet(
        'project/show',
        queryParameters: {'category_id': categoryId},
      );
    } catch (e) {
      throw Exception('Failed to get projects by category: $e');
    }
  }

  // Get All Works
  Future<Response> getAllWorks() async {
    try {
      return await authenticatedGet('works');
    } catch (e) {
      throw Exception('Failed to get works: $e');
    }
  }

  // Get Works By Type
  Future<Response> getWorksByType(String type) async {
    try {
      return await authenticatedGet(
        'works/show',
        queryParameters: {'type': type},
      );
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

      return await authenticatedPost('ask_price/store', data: data);
    } catch (e) {
      throw Exception('Failed to store ask price: $e');
    }
  }

  // Get Ask Price Categories
  Future<Response> getAskPriceCategories() async {
    try {
      return await authenticatedGet('ask_price/categories');
    } catch (e) {
      throw Exception('Failed to get ask price categories: $e');
    }
  }
}
