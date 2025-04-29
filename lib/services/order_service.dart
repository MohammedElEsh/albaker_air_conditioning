import 'package:dio/dio.dart';
import 'api_base_service.dart';

class OrderService extends ApiBaseService {
  // Get Current Orders
  Future<Response> getCurrentOrders() async {
    try {
      return await authenticatedGet('order/current');
    } catch (e) {
      throw Exception('Failed to get current orders: $e');
    }
  }

  // Get Completed Orders
  Future<Response> getCompletedOrders() async {
    try {
      return await authenticatedGet('order/completed');
    } catch (e) {
      throw Exception('Failed to get completed orders: $e');
    }
  }

  // Get Order Details
  Future<Response> getOrderDetails(int orderId) async {
    try {
      return await authenticatedGet(
        'order/details',
        queryParameters: {'order_id': orderId},
      );
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

      return await authenticatedPost('review/create', data: data);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}
