/// A service class for managing payment operations.
///
/// Features:
/// - PyMob payment integration
/// - Payment checkout process
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Initiating payment checkout
/// - Token management
/// - Arabic language support
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all payment-related API operations.
///
/// This class manages the payment functionality including:
/// - Payment checkout process
/// - PyMob payment integration
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class PaymentService {
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

  /// Initiates a payment checkout process using PyMob.
  ///
  /// This method makes a GET request to the payment checkout endpoint
  /// to start the payment process.
  ///
  /// Returns:
  /// - Response: API response containing payment checkout data
  ///
  /// Throws:
  /// - Exception: If the payment initiation fails
  Future<Response> payWithPymob() async {
    try {
      final options = Options(
        headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
      );

      return await _dio.get(
        'https://albakr-ac.com/payment/checkout',
        options: options,
      );
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }
}
