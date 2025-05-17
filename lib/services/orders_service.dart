/// A service class for managing order-related operations.
///
/// Features:
/// - Current orders management
/// - Completed orders tracking
/// - Order details retrieval
/// - Review submission
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching current orders
/// - Loading completed orders
/// - Viewing order details
/// - Adding product/accessory reviews
/// - Arabic language support
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all order-related API operations.
///
/// This class manages the order functionality including:
/// - Order tracking
/// - Order details
/// - Review management
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class OrderService {
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

  /// Retrieves the user's current (active) orders.
  ///
  /// Returns:
  /// - Response: API response containing current orders data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getCurrentOrders() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/order/current',
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
      throw Exception('Failed to get current orders: $e');
    }
  }

  /// Retrieves the user's completed orders.
  ///
  /// Returns:
  /// - Response: API response containing completed orders data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getCompletedOrders() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/order/completed',
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
      throw Exception('Failed to get completed orders: $e');
    }
  }

  /// Retrieves detailed information for a specific order.
  ///
  /// Parameters:
  /// - orderId: ID of the order to fetch details for
  ///
  /// Returns:
  /// - Response: API response containing order details
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getOrderDetails(int orderId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/order/details',
        queryParameters: {'order_id': orderId},
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
      throw Exception('Failed to get order details: $e');
    }
  }

  /// Submits a review for a product or accessory.
  ///
  /// Parameters:
  /// - comment: The review text
  /// - rate: Rating value (typically 1-5)
  /// - productId: Optional ID of the product being reviewed
  /// - accessoryId: Optional ID of the accessory being reviewed
  ///
  /// Note: Either productId or accessoryId must be provided, but not both
  ///
  /// Returns:
  /// - Response: API response confirming the review submission
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> addReview({
    required String comment,
    required int rate,
    int? productId,
    int? accessoryId,
  }) async {
    try {
      final data = {'comment': comment, 'rate': rate};

      if (productId != null) {
        data['product_id'] = productId;
      }

      if (accessoryId != null) {
        data['accessory_id'] = accessoryId;
      }

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/review/create',
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
      throw Exception('Failed to add review: $e');
    }
  }
}
