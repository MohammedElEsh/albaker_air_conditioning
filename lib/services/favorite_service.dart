/// A service class for managing favorite items operations.
///
/// Features:
/// - Favorite products and accessories management
/// - Favorite status checking
/// - Adding/removing items from favorites
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching favorite items
/// - Checking favorite status
/// - Adding items to favorites
/// - Removing items from favorites
/// - Arabic language support
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all favorite-related API operations.
///
/// This class manages the favorites functionality including:
/// - Favorite items listing
/// - Favorite status management
/// - Adding/removing favorites
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class FavoriteService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  /// Retrieves the authentication token from SharedPreferences.
  ///
  /// Returns:
  /// - String?: The stored token or null if not found
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Retrieves all favorite items (products and accessories).
  ///
  /// Returns:
  /// - Response: API response containing favorite items data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getFavorites() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/favourites',
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
      throw Exception('Failed to get favorites: $e');
    }
  }

  /// Checks if a product is in the user's favorites.
  ///
  /// Parameters:
  /// - productId: ID of the product to check
  ///
  /// Returns:
  /// - Response: API response containing favorite status
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getProductFavoriteStatus(int productId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/favourite/product/status/$productId',
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
      throw Exception('Failed to check product favorite status: $e');
    }
  }

  /// Checks if an accessory is in the user's favorites.
  ///
  /// Parameters:
  /// - accessoryId: ID of the accessory to check
  ///
  /// Returns:
  /// - Response: API response containing favorite status
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getAccessoryFavoriteStatus(int accessoryId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/favourite/accessory/status/$accessoryId',
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
      throw Exception('Failed to check accessory favorite status: $e');
    }
  }

  /// Adds a product to the user's favorites.
  ///
  /// Parameters:
  /// - productId: ID of the product to add
  ///
  /// Returns:
  /// - Response: API response confirming the addition
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> addProductToFavorites(int productId) async {
    try {
      final data = {'product_id': productId};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/favourite/product',
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
      throw Exception('Failed to add product to favorites: $e');
    }
  }

  /// Removes a product from the user's favorites.
  ///
  /// Parameters:
  /// - productId: ID of the product to remove
  ///
  /// Returns:
  /// - Response: API response confirming the removal
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> removeProductFromFavorites(int productId) async {
    try {
      final data = {'product_id': productId};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/unFavourite/product',
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
      throw Exception('Failed to remove product from favorites: $e');
    }
  }

  /// Adds an accessory to the user's favorites.
  ///
  /// Parameters:
  /// - accessoryId: ID of the accessory to add
  ///
  /// Returns:
  /// - Response: API response confirming the addition
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> addAccessoryToFavorites(int accessoryId) async {
    try {
      final data = {'accessory_id': accessoryId};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/favourite/accessory',
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
      throw Exception('Failed to add accessory to favorites: $e');
    }
  }

  // Remove Accessory from Favorites
  Future<Response> removeAccessoryFromFavorites(int accessoryId) async {
    try {
      final data = {'accessory_id': accessoryId};
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/unFavourite/accessory',
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
      throw Exception('Failed to remove accessory from favorites: $e');
    }
  }
}
