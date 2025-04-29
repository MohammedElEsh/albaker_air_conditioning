import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://albakr-ac.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Home Data
  Future<Response> getHomeData() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/home',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  // Get Home Slider
  Future<Response> getHomeSlider() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/home/slider',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get home slider: $e');
    }
  }

  // Get Privacy Policy
  Future<Response> getPrivacyPolicy() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/privacy_policy',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get privacy policy: $e');
    }
  }

  // Get Social URLs
  Future<Response> getSocialUrls() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/social-urls',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get social URLs: $e');
    }
  }

  // Get Who Are We
  Future<Response> getWhoAreWe() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/who-are-we',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get who are we: $e');
    }
  }

  // Get Exchange Policy
  Future<Response> getExchangePolicy() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/settings/exchange_policy',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get exchange policy: $e');
    }
  }

  // Get Best Seller Products
  Future<Response> getBestSellerProducts() async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        '$baseUrl/bestseller/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get best seller accessories: $e');
    }
  }
}
