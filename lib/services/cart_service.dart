import 'package:dio/dio.dart';
import 'api_base_service.dart';

class CartService extends ApiBaseService {
  // Get Cart
  Future<Response> getCart() async {
    try {
      return await authenticatedGet('cart');
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

      return await authenticatedPost('cart/add/product', data: data);
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

      return await authenticatedPost('cart/add/accessory', data: data);
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

      return await authenticatedPost('cart/update/product', data: data);
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

      return await authenticatedPost('cart/update/accessory', data: data);
    } catch (e) {
      throw Exception('Failed to update accessory in cart: $e');
    }
  }

  // Get Additions
  Future<Response> getAdditions() async {
    try {
      return await authenticatedGet('additions');
    } catch (e) {
      throw Exception('Failed to get additions: $e');
    }
  }

  // Get Addresses
  Future<Response> getAddresses() async {
    try {
      return await authenticatedGet('addresses');
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }

  // Choose Address for Cart
  Future<Response> chooseAddress(int addressId) async {
    try {
      return await authenticatedGet(
        'cart/address',
        queryParameters: {'address_id': addressId},
      );
    } catch (e) {
      throw Exception('Failed to choose address for cart: $e');
    }
  }

  // Get Cart Payment
  Future<Response> getCartPayment() async {
    try {
      return await authenticatedGet('cart/payment');
    } catch (e) {
      throw Exception('Failed to get cart payment: $e');
    }
  }

  // Update Cart Payment
  Future<Response> updateCartPayment(String code) async {
    try {
      return await authenticatedPost(
        'cart/Updatepayment',
        data: {'code': code},
      );
    } catch (e) {
      throw Exception('Failed to update cart payment: $e');
    }
  }
}
