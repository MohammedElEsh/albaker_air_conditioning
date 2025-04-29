import 'package:dio/dio.dart';
import 'api_base_service.dart';

class FavoriteService extends ApiBaseService {
  // Get Favorite Products
  Future<Response> getFavorites() async {
    try {
      return await authenticatedGet('favourites');
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  // Check Product Favorite Status
  Future<Response> getProductFavoriteStatus(int productId) async {
    try {
      return await authenticatedGet('favourite/product/status/$productId');
    } catch (e) {
      throw Exception('Failed to check product favorite status: $e');
    }
  }

  // Check Accessory Favorite Status
  Future<Response> getAccessoryFavoriteStatus(int accessoryId) async {
    try {
      return await authenticatedGet('favourite/accessory/status/$accessoryId');
    } catch (e) {
      throw Exception('Failed to check accessory favorite status: $e');
    }
  }

  // Add Product to Favorites
  Future<Response> addProductToFavorites(int productId) async {
    try {
      final data = {'product_id': productId};
      return await authenticatedPost('favourite/product', data: data);
    } catch (e) {
      throw Exception('Failed to add product to favorites: $e');
    }
  }

  // Remove Product from Favorites
  Future<Response> removeProductFromFavorites(int productId) async {
    try {
      final data = {'product_id': productId};
      return await authenticatedPost('unFavourite/product', data: data);
    } catch (e) {
      throw Exception('Failed to remove product from favorites: $e');
    }
  }

  // Add Accessory to Favorites
  Future<Response> addAccessoryToFavorites(int accessoryId) async {
    try {
      final data = {'accessory_id': accessoryId};
      return await authenticatedPost('favourite/accessory', data: data);
    } catch (e) {
      throw Exception('Failed to add accessory to favorites: $e');
    }
  }

  // Remove Accessory from Favorites
  Future<Response> removeAccessoryFromFavorites(int accessoryId) async {
    try {
      final data = {'accessory_id': accessoryId};
      return await authenticatedPost('unFavourite/accessory', data: data);
    } catch (e) {
      throw Exception('Failed to remove accessory from favorites: $e');
    }
  }
}
