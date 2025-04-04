class Constants {
  // API Base URL
  static const String baseUrl = "https://albakr-ac.com/api";

  // API Endpoints - Auth
  static const String loginEndpoint = "$baseUrl/login";
  static const String registerEndpoint = "$baseUrl/register";
  static const String sendOtpEndpoint = "$baseUrl/send/otp";
  static const String checkOtpEndpoint = "$baseUrl/check/otp";
  static const String completeRegisterEndpoint = "$baseUrl/complete/register";
  static const String resetPasswordEndpoint = "$baseUrl/resetPassword";
  static const String logoutEndpoint = "$baseUrl/logout";
  static const String profileEndpoint = "$baseUrl/profile";
  static const String updateProfileEndpoint = "$baseUrl/update/profile";
  static const String changePasswordEndpoint = "$baseUrl/change/password";
  static const String deleteAccountEndpoint = "$baseUrl/deleteAccount";

  // Shared Preferences Keys
  static const String tokenKey = "user_token";
  static const String userDataKey = "user_data";
  static const String isLoggedInKey = "is_logged_in";
} 