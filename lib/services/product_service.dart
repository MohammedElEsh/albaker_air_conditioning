import 'package:dio/dio.dart';
import 'dart:convert';
import 'api_base_service.dart';

class ProductService extends ApiBaseService {
  // Get Product Details
  Future<Response> getProductDetails(int productId) async {
    try {
      return await authenticatedGet(
        'product/details',
        queryParameters: {'product_id': productId},
      );
    } catch (e) {
      throw Exception('Failed to get product details: $e');
    }
  }

  // Get Accessories Details
  Future<Response> getAccessoriesDetails(int accessoryId) async {
    try {
      return await authenticatedGet('accessories-details/$accessoryId');
    } catch (e) {
      throw Exception('Failed to get accessories details: $e');
    }
  }

  // Get Products by Category
  Future<Response> getProductsByCategory(int categoryId) async {
    try {
      return await authenticatedGet(
        'product/category',
        queryParameters: {'category_id': categoryId},
      );
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  // Get Product Brands
  Future<Response> getProductBrands() async {
    try {
      return await authenticatedGet('product/brands');
    } catch (e) {
      throw Exception('Failed to get product brands: $e');
    }
  }

  // Search Products
  Future<Response> searchProducts(String keyword, {List<int>? brands}) async {
    try {
      // Create query parameters for the search
      final queryParams = {'keyword': keyword};

      // If brands are provided, use POST with form data
      if (brands != null && brands.isNotEmpty) {
        // Create form data with brands
        final formData = FormData.fromMap({'brands': brands.join(', ')});

        return await authenticatedPost(
          'product/search',
          data: formData,
          queryParameters: queryParams,
        );
      }

      // Otherwise, just use GET request with query parameters
      return await authenticatedGet(
        'product/search',
        queryParameters: queryParams,
      );
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Filter Products
  Future<Response> filterProducts({
    required int categoryId,
    List<int>? brandsId,
    int? bestSeller,
    int? price,
    int? rate,
  }) async {
    try {
      final data = FormData.fromMap({'category_id': categoryId});

      if (brandsId != null) {
        data.fields.add(MapEntry('brands_id', jsonEncode(brandsId)));
      }

      if (bestSeller != null) {
        data.fields.add(MapEntry('bestseller', bestSeller.toString()));
      }
      if (price != null) {
        data.fields.add(MapEntry('price', price.toString()));
      }
      if (rate != null) {
        data.fields.add(MapEntry('rate', rate.toString()));
      }

      return await authenticatedPost('product/filter', data: data);
    } catch (e) {
      throw Exception('Failed to filter products: $e');
    }
  }

  // Get Best Seller Products
  Future<Response> getBestSellerProducts() async {
    try {
      return await authenticatedGet('bestseller/products');
    } catch (e) {
      throw Exception('Failed to get best seller products: $e');
    }
  }

  // Get Best Seller Accessories
  Future<Response> getBestSellerAccessories() async {
    try {
      return await authenticatedGet('bestseller/accessories');
    } catch (e) {
      throw Exception('Failed to get best seller accessories: $e');
    }
  }

  // Add Product Review
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

      return await authenticatedPost('review/create', data: data);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}
