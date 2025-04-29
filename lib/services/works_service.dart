import 'package:dio/dio.dart';
import 'api_base_service.dart';

class WorksService extends ApiBaseService {
  // Get All Works
  Future<Response> getAllWorks() async {
    try {
      return await authenticatedGet('works');
    } catch (e) {
      throw Exception('Failed to get works: $e');
    }
  }

  // Get Works by Type
  Future<Response> getWorksByType(String type) async {
    try {
      return await authenticatedGet(
        'works/show',
        queryParameters: {'type': type},
      );
    } catch (e) {
      throw Exception('Failed to get works by type: $e');
    }
  }
} 