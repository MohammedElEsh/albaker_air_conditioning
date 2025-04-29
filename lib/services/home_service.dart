import 'package:dio/dio.dart';
import 'api_base_service.dart';

class HomeService extends ApiBaseService {
  // Get Home Data
  Future<Response> getHomeData() async {
    try {
      return await authenticatedGet('home');
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  // Get Home Slider
  Future<Response> getHomeSlider() async {
    try {
      return await authenticatedGet('home/slider');
    } catch (e) {
      throw Exception('Failed to get home slider: $e');
    }
  }

  // Get Privacy Policy
  Future<Response> getPrivacyPolicy() async {
    try {
      return await authenticatedGet('settings/privacy_policy');
    } catch (e) {
      throw Exception('Failed to get privacy policy: $e');
    }
  }

  // Get Social URLs
  Future<Response> getSocialUrls() async {
    try {
      return await authenticatedGet('settings/social-urls');
    } catch (e) {
      throw Exception('Failed to get social URLs: $e');
    }
  }

  // Get Who Are We
  Future<Response> getWhoAreWe() async {
    try {
      return await authenticatedGet('settings/who-are-we');
    } catch (e) {
      throw Exception('Failed to get who are we: $e');
    }
  }

  // Get Exchange Policy
  Future<Response> getExchangePolicy() async {
    try {
      return await authenticatedGet('settings/exchange_policy');
    } catch (e) {
      throw Exception('Failed to get exchange policy: $e');
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
}
