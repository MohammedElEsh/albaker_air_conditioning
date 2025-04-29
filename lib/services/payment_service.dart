import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Pay with PyMob
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
