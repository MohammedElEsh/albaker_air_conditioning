import 'package:dio/dio.dart';
import 'api_base_service.dart';

class PaymentService extends ApiBaseService {
  // Pay with PyMob
  Future<Response> payWithPymob() async {
    try {
      final dio = Dio();
      final options = Options(
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ar',
        },
      );
      
      return await dio.get(
        'https://albakr-ac.com/payment/checkout',
        options: options,
      );
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }
} 