import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Current Orders
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

  // Get Completed Orders
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

  // Get Order Details
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

  // Add Review
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
