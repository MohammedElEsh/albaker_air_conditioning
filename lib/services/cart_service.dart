/// A service class for managing shopping cart operations.
///
/// Features:
/// - Cart management (view, add, update items)
/// - Product and accessory handling
/// - Address management
/// - Payment processing
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Retrieving cart contents
/// - Adding products and accessories
/// - Updating item quantities
/// - Managing delivery addresses
/// - Processing payments
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all cart-related API operations.
///
/// This class manages the shopping cart functionality including:
/// - Cart item management
/// - Product and accessory handling
/// - Address selection
/// - Payment processing
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class CartService {
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

  /// Retrieves the current cart contents.
  ///
  /// Returns:
  /// - Response: API response containing cart data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getCart() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/cart',
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
      throw Exception('Failed to get cart: $e');
    }
  }

  /// Adds a product to the cart.
  ///
  /// Parameters:
  /// - productId: ID of the product to add
  /// - quantity: Number of items to add
  /// - addId: ID of any additional options
  ///
  /// Returns:
  /// - Response: API response confirming the addition
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> addProductToCart({
    required int productId,
    required int quantity,
    required int addId,
  }) async {
    try {
      final data = {
        'product_id': productId,
        'quantity': quantity,
        'add_id': addId,
      };

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/cart/add/product',
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
      throw Exception('Failed to add product to cart: $e');
    }
  }

  /// Adds an accessory to the cart.
  ///
  /// Parameters:
  /// - accessoryId: ID of the accessory to add
  /// - quantity: Number of items to add
  ///
  /// Returns:
  /// - Response: API response confirming the addition
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> addAccessoryToCart({
    required int accessoryId,
    required int quantity,
  }) async {
    try {
      final data = {'accessory_id': accessoryId, 'quantity': quantity};

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/cart/add/accessory',
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
      throw Exception('Failed to add accessory to cart: $e');
    }
  }

  /// Updates the quantity of a product in the cart.
  ///
  /// Parameters:
  /// - itemId: ID of the cart item to update
  /// - quantity: New quantity value
  /// - addId: ID of any additional options
  ///
  /// Returns:
  /// - Response: API response confirming the update
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> updateProductInCart({
    required int itemId,
    required int quantity,
    required int addId,
  }) async {
    try {
      final data = {'item_id': itemId, 'quantity': quantity, 'add_id': addId};

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/cart/update/product',
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
      throw Exception('Failed to update product in cart: $e');
    }
  }

  /// Updates the quantity of an accessory in the cart.
  ///
  /// Parameters:
  /// - itemId: ID of the cart item to update
  /// - quantity: New quantity value
  ///
  /// Returns:
  /// - Response: API response confirming the update
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> updateAccessoryInCart({
    required int itemId,
    required int quantity,
  }) async {
    try {
      final data = {'item_id': itemId, 'quantity': quantity};

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/cart/update/accessory',
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
      throw Exception('Failed to update accessory in cart: $e');
    }
  }

  /// Retrieves available product additions/options.
  ///
  /// Returns:
  /// - Response: API response containing additions data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getAdditions() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/additions',
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
      throw Exception('Failed to get additions: $e');
    }
  }

  /// Retrieves the user's saved addresses.
  ///
  /// Returns:
  /// - Response: API response containing addresses data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getAddresses() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/addresses',
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
      throw Exception('Failed to get addresses: $e');
    }
  }

  /// Selects a delivery address for the cart.
  ///
  /// Parameters:
  /// - addressId: ID of the address to select
  ///
  /// Returns:
  /// - Response: API response confirming the selection
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> chooseAddress(int addressId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/cart/address',
        queryParameters: {'address_id': addressId},
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
      throw Exception('Failed to choose address for cart: $e');
    }
  }

  /// Retrieves payment information for the cart.
  ///
  /// Returns:
  /// - Response: API response containing payment data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getCartPayment() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/cart/payment',
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
      throw Exception('Failed to get cart payment: $e');
    }
  }

  /// Updates the payment method for the cart.
  ///
  /// Parameters:
  /// - code: Payment method code
  ///
  /// Returns:
  /// - Response: API response confirming the update
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> updateCartPayment(String code) async {
    try {
      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/cart/Updatepayment',
        data: FormData.fromMap({'code': code}),
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
      throw Exception('Failed to update cart payment: $e');
    }
  }
}
