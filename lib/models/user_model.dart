class UserModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String? verificationCode;
  final String? token;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.verificationCode,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _stringValueOrEmpty(json['id']),
      firstName: _stringValueOrEmpty(json['f_name']),
      lastName: _stringValueOrEmpty(json['l_name']),
      email: _stringValueOrEmpty(json['email']),
      phone: _stringValueOrEmpty(json['phone']),
      password: _stringValueOrEmpty(json['password']),
      confirmPassword: _stringValueOrEmpty(json['password_confirmation']),
      verificationCode: _stringValueOrEmpty(json['otp']),
      token: _stringValueOrEmpty(json['token']),
    );
  }

  static String _stringValueOrEmpty(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'f_name': firstName,
      'l_name': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': confirmPassword,
      'otp': verificationCode ?? '',
      'fcm_token': 'fcm_token_placeholder', // قيمة افتراضية للـ FCM token
    };
  }
}
