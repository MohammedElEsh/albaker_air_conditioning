/// A service class for managing works-related operations.
///
/// Features:
/// - Works listing and filtering
/// - Works type-based filtering
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching all works
/// - Filtering works by type
/// - Token management
/// - Arabic language support
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all works-related API operations.
///
/// This class manages the works functionality including:
/// - Works listing
/// - Works type filtering
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class WorksService {
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

  /// Retrieves all works from the API.
  ///
  /// This method fetches a list of all available works.
  ///
  /// Returns:
  /// - Response: API response containing works data
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Retrieves works filtered by a specific type.
  ///
  /// Parameters:
  /// - type: The type of works to filter by
  ///
  /// Returns:
  /// - Response: API response containing filtered works data
  ///
  /// Throws:
  /// - Exception: If the API call fails
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
