/// A service class for managing home screen and general app data.
///
/// Features:
/// - Home screen data retrieval
/// - Slider content management
/// - Policy and information pages
/// - Social media links
/// - Best seller products and accessories
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching home screen content
/// - Retrieving slider images
/// - Accessing policy documents
/// - Getting social media URLs
/// - Loading best seller items
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all home-related API operations.
///
/// This class manages the home screen functionality including:
/// - Home screen data
/// - Slider content
/// - Policy documents
/// - Social media links
/// - Best seller items
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication.
class HomeService {
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

  /// Retrieves the main home screen data.
  ///
  /// Returns:
  /// - Response: API response containing home screen data
  ///
  /// Throws:
  /// - Exception: If the API call fails or token is missing
  Future<Response> getHomeData() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing, please login again');
      }

      final response = await _dio.get(
        '$baseUrl/home',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  /// Retrieves the home screen slider content.
  ///
  /// Returns:
  /// - Response: API response containing slider data
  ///
  /// Throws:
  /// - Exception: If the API call fails or token is missing
  Future<Response> getHomeSlider() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing, please login again');
      }

      final response = await _dio.get(
        '$baseUrl/home/slider',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get home slider: $e');
    }
  }

  /// Retrieves the privacy policy content.
  ///
  /// Returns:
  /// - Response: API response containing privacy policy data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getPrivacyPolicy() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/privacy_policy',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get privacy policy: $e');
    }
  }

  /// Retrieves social media URLs.
  ///
  /// Returns:
  /// - Response: API response containing social media links
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getSocialUrls() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/social-urls',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get social URLs: $e');
    }
  }

  /// Retrieves the "Who Are We" content.
  ///
  /// Returns:
  /// - Response: API response containing company information
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getWhoAreWe() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/who-are-we',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get who are we: $e');
    }
  }

  /// Retrieves the exchange policy content.
  ///
  /// Returns:
  /// - Response: API response containing exchange policy data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getExchangePolicy() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/exchange_policy',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get exchange policy: $e');
    }
  }

  /// Retrieves best-selling products.
  ///
  /// Returns:
  /// - Response: API response containing best seller products data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getBestSellerProducts() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/bestseller/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get best seller products: $e');
    }
  }

  /// Retrieves best-selling accessories.
  ///
  /// Returns:
  /// - Response: API response containing best seller accessories data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getBestSellerAccessories() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/bestseller/accessories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get best seller accessories: $e');
    }
  }
}
