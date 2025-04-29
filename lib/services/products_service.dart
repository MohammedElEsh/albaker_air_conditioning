import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Product Details
  Future<Response> getProductDetails(int productId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/product/details',
        queryParameters: {'product_id': productId},
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
      throw Exception('Failed to get product details: $e');
    }
  }

  // Get Accessories Details
  Future<Response> getAccessoriesDetails(int accessoryId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/accessories-details/$accessoryId',
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
      throw Exception('Failed to get accessories details: $e');
    }
  }

  // Get Products by Category
  Future<Response> getProductsByCategory(int categoryId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/product/category',
        queryParameters: {'category_id': categoryId},
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
      throw Exception('Failed to get products by category: $e');
    }
  }

  // Get Product Brands
  Future<Response> getProductBrands() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/product/brands',
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
      throw Exception('Failed to get product brands: $e');
    }
  }

  // Search Products
  Future<Response> searchProducts(String keyword, {List<int>? brands}) async {
    try {
      // Create query parameters for the search
      final queryParams = {'keyword': keyword};
      final token = await getToken();

      // If brands are provided, use POST with form data
      if (brands != null && brands.isNotEmpty) {
        // Create form data with brands
        final formData = FormData.fromMap({'brands': brands.join(', ')});

        return await _dio.post(
          '$baseUrl/product/search',
          data: formData,
          queryParameters: queryParams,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Accept-Language': 'ar',
            },
          ),
        );
      }

      // Otherwise, just use GET request with query parameters
      return await _dio.get(
        '$baseUrl/product/search',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
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

      final token = await getToken();
      final response = await _dio.post(
        '$baseUrl/product/filter',
        data: data,
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
      throw Exception('Failed to filter products: $e');
    }
  }

  // Get Best Seller Products
  Future<Response> getBestSellerProducts() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/bestseller/products',
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
      throw Exception('Failed to get best seller products: $e');
    }
  }

  // Get Best Seller Accessories
  Future<Response> getBestSellerAccessories() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/bestseller/accessories',
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
