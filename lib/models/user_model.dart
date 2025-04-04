class UserModel {
  final String? token;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  UserModel({
    this.token,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  // من JSON إلى كائن
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  // من كائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'f_name': firstName,
      'l_name': lastName,
      'email': email,
      'phone': phone,
    };
  }
}
