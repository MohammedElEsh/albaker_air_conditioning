import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import '../models/api_response_model.dart';

class ApiService {
  late Dio _dio;
  String? _authToken;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
        validateStatus: (status) {
          return status! < 500; // تقبل الاستجابات بكود أقل من 500
        },
        headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
      ),
    );

    // إضافة interceptors للتسجيل والتعديل على الطلبات
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إضافة token إذا كان متوفراً
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }

          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('REQUEST BODY: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            print('RESPONSE BODY: ${response.data}');
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
            print('ERROR MESSAGE: ${e.message}');
          }

          return handler.next(e);
        },
      ),
    );
  }

  // تعيين token للاستخدام في الطلبات المستقبلية
  void setAuthToken(String token) {
    _authToken = token;
  }

  // إزالة token عند تسجيل الخروج
  void clearAuthToken() {
    _authToken = null;
  }

  // طلب HTTP GET
  Future<ApiResponseModel<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return ApiResponseModel<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponseModel<T>(status: 500, message: 'حدث خطأ غير متوقع: $e');
    }
  }

  // طلب HTTP POST
  Future<ApiResponseModel<T>> post<T>({
    required String endpoint,
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);

      return ApiResponseModel<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponseModel<T>(status: 500, message: 'حدث خطأ غير متوقع: $e');
    }
  }

  // معالجة أخطاء Dio
  ApiResponseModel<T> _handleDioError<T>(DioException e) {
    if (e.response != null) {
      // الخادم رد بخطأ
      try {
        return ApiResponseModel<T>.fromJson(e.response!.data, null);
      } catch (_) {
        return ApiResponseModel<T>(
          status: e.response!.statusCode ?? 400,
          message: e.response!.statusMessage ?? 'حدث خطأ في الاتصال بالخادم',
        );
      }
    } else {
      // لم يتمكن من الاتصال بالخادم
      return ApiResponseModel<T>(
        status: 500,
        message: 'تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت',
      );
    }
  }
}
