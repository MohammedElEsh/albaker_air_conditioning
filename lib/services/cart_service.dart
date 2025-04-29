import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Cart
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

  // Add Product to Cart
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

  // Add Accessory to Cart
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

  // Update Product in Cart
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

  // Update Accessory in Cart
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

  // Get Additions
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

  // Get Addresses
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

  // Choose Address for Cart
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

  // Get Cart Payment
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

  // Update Cart Payment
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
