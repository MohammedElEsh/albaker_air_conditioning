/// A service class for managing project-related operations.
///
/// Features:
/// - Project categories retrieval
/// - Projects listing by category
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching project categories
/// - Loading projects for specific categories
/// - Arabic language support
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all project-related API operations.
///
/// This class manages the project functionality including:
/// - Project categories
/// - Project listings
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class ProjectService {
  /// Dio instance for making HTTP requests
  final Dio _dio = Dio();

  /// Base URL for all API endpoints
  final String baseUrl = 'https://albakr-ac.com/api';

  /// Retrieves the authentication token from SharedPreferences.
  ///
  /// Returns:
  /// - String?: The stored token or null if not found
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Retrieves all project categories.
  ///
  /// Returns:
  /// - Response: API response containing project categories data
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Retrieves projects for a specific category.
  ///
  /// Parameters:
  /// - categoryId: ID of the category to fetch projects for
  ///
  /// Returns:
  /// - Response: API response containing projects data for the category
  ///
  /// Throws:
  /// - Exception: If the API call fails
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
