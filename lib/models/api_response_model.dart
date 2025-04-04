class ApiResponseModel<T> {
  final String message;
  final int status;
  final T? data;

  ApiResponseModel({
    required this.message,
    required this.status,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponseModel(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
    );
  }

  bool get isSuccess => status == 200;
} 