/// A service class for managing product-related operations.
///
/// Features:
/// - Product details retrieval
/// - Accessory details management
/// - Category-based product listing
/// - Brand management
/// - Product search and filtering
/// - Best seller products
/// - Review submission
/// - API integration with albakr-ac.com
///
/// The service provides methods for:
/// - Fetching product and accessory details
/// - Loading products by category
/// - Managing product brands
/// - Searching and filtering products
/// - Accessing best seller items
/// - Submitting reviews
/// - Arabic language support
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for handling all product-related API operations.
///
/// This class manages the product functionality including:
/// - Product and accessory details
/// - Category and brand management
/// - Search and filtering
/// - Best seller items
/// - Review management
///
/// All API calls are made to the base URL 'https://albakr-ac.com/api'
/// with proper authentication and Arabic language support.
class ProductService {
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

  /// Retrieves detailed information for a specific product.
  ///
  /// Parameters:
  /// - productId: ID of the product to fetch details for
  ///
  /// Returns:
  /// - Response: API response containing product details
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Retrieves detailed information for a specific accessory.
  ///
  /// Parameters:
  /// - accessoryId: ID of the accessory to fetch details for
  ///
  /// Returns:
  /// - Response: API response containing accessory details
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Retrieves products for a specific category.
  ///
  /// Parameters:
  /// - categoryId: ID of the category to fetch products for
  /// - page: Optional page number for pagination (default is 1)
  ///
  /// Returns:
  /// - Response: API response containing products data
  ///
  /// Throws:
  /// - Exception: If the API call fails
  Future<Response> getProductsByCategory(int categoryId, {int page = 1}) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/product/category',
        queryParameters: {'category_id': categoryId, 'page': page},
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

  /// Retrieves all available product brands.
  ///
  /// Returns:
  /// - Response: API response containing brands data
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Searches for products based on keyword and optional brand filters.
  ///
  /// Parameters:
  /// - keyword: Search term to look for in products
  /// - brands: Optional list of brand IDs to filter by
  ///
  /// Returns:
  /// - Response: API response containing search results
  ///
  /// Throws:
  /// - Exception: If the API call fails
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

  /// Filters products based on various criteria.
  ///
  /// Parameters:
  /// - categoryId: ID of the category to filter by
  /// - brandsId: Optional list of brand IDs to filter by
  /// - bestSeller: Optional flag to filter best sellers
  /// - price: Optional price filter
  /// - rate: Optional rating filter
  ///
  /// Returns:
  /// - Response: API response containing filtered products
  ///
  /// Throws:
  /// - Exception: If the API call fails
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
