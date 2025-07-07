/// The profile screen of the application that manages user profile information.
///
/// Features:
/// - Profile information display and editing
/// - Password change functionality
/// - Account deletion
/// - Logout functionality
/// - Arabic language support
/// - Responsive design using MediaQuery
///
/// The screen includes:
/// - Profile image
/// - Personal information fields
/// - Password change form
/// - Account deletion form
/// - Logout button
/// - Loading states and error handling
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_password_field.dart';
import '../authorization_screens/auth_screen.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

/// Profile screen widget that manages user profile information and settings.
///
/// This screen implements:
/// - Profile information management
/// - Password change functionality
/// - Account deletion
/// - Logout process
/// - Form validation
/// - Error handling
/// - Responsive design
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Service for user-related operations
  final UserService _userService = UserService();

  /// Text controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _deleteEmailController = TextEditingController();
  final TextEditingController _deletePasswordController =
  TextEditingController();

  /// State flags
  bool _isLoading = true;
  bool _isEditMode = false;
  bool _showChangePassword = false;
  bool _showDeleteAccount = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Loads the user's profile information from the API.
  ///
  /// Updates the form fields with the user's data.
  /// Handles loading states and error cases.
  Future<void> _loadProfile() async {
    try {
      var response = await _userService.getProfile();
      if (response.statusCode == 200) {
        var data = response.data['data'];
        setState(() {
          _firstNameController.text = data['f_name'] ?? '';
          _lastNameController.text = data['l_name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _deleteEmailController.text = data['email'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      AlertUtils.showErrorAlert(context, "خطأ", AlertUtils.profileUpdateFailed);
    }
  }

  /// Updates the user's profile information.
  ///
  /// Sends the updated information to the API.
  /// Handles success and error cases with appropriate alerts.
  Future<void> _updateProfile() async {
    try {
      var response = await _userService.updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
      if (response.statusCode == 200) {
        setState(() => _isEditMode = false);
        AlertUtils.showSuccessAlert(
          context,
          "نجاح",
          AlertUtils.profileUpdateSuccess,
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(context, "خطأ", AlertUtils.profileUpdateFailed);
    }
  }

  /// Changes the user's password.
  ///
  /// Validates password match before sending to API.
  /// Handles success and error cases with appropriate alerts.
  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      AlertUtils.showWarningAlert(
        context,
        "تنبيه",
        AlertUtils.passwordMismatch,
      );
      return;
    }

    try {
      var response = await _userService.changePassword(
        currentPassword: _currentPasswordController.text,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
      if (response.statusCode == 200) {
        setState(() => _showChangePassword = false);
        _clearPasswordFields();
        AlertUtils.showSuccessAlert(
          context,
          "نجاح",
          AlertUtils.passwordChangeSuccess,
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(
        context,
        "تنبيه",
        AlertUtils.passwordChangeFailed,
      );
    }
  }

  /// Deletes the user's account.
  ///
  /// Requires email and password confirmation.
  /// Clears user token and navigates to auth screen on success.
  /// Handles error cases with appropriate alerts.
  Future<void> _deleteAccount() async {
    try {
      var response = await _userService.deleteAccount(
        email: _deleteEmailController.text,
        password: _deletePasswordController.text,
      );
      if (response.statusCode == 200) {
        await _userService.clearToken();
        AlertUtils.showSuccessAlert(
          context,
          "نجاح",
          AlertUtils.accountDeleteSuccess,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(
        context,
        "تنبيه",
        AlertUtils.accountDeleteFailed,
      );
    }
  }

  /// Logs out the user.
  ///
  /// Clears user token and navigates to auth screen.
  /// Handles error cases with appropriate alerts.
  Future<void> _logout() async {
    try {
      var response = await _userService.logout();
      if (response.statusCode == 200) {
        await _userService.clearToken();
        AlertUtils.showSuccessAlert(context, "نجاح", AlertUtils.logoutSuccess);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(context, "تنبيه", AlertUtils.logoutFailed);
    }
  }

  /// Clears password fields after successful password change
  void _clearPasswordFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  /// Clears delete account fields when dialog is closed
  void _clearDeleteFields() {
    _deletePasswordController.clear();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _deleteEmailController.dispose();
    _deletePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),

                    // Header with title and back button
                    Row(
                      children: [
                        // Back button with forward arrow (RTL layout)
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_forward,
                            color: const Color(0xFF1D75B1),
                            size: screenWidth * 0.06,
                          ),
                        ),
                        const Spacer(),
                        // Header title "الملف الشخصي" (Profile)
                        Text(
                          "الملف الشخصي",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        // Empty space for symmetry
                        SizedBox(width: screenWidth * 0.06),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Profile image with user icon
                    Container(
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      child: Center(
                        child: Image.asset(
                          'assets/images/user.png',
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          color: const Color(0xFF1D75B1),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Form fields for profile information
                    // First Name Field
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: TextField(
                        controller: _firstNameController,
                        enabled: _isEditMode,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "الاسم الأول",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF878383),
                          ),
                        ),
                      ),
                    ),

                    // Last Name Field
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: TextField(
                        controller: _lastNameController,
                        enabled: _isEditMode,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "الاسم الأخير",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF878383),
                          ),
                        ),
                      ),
                    ),

                    // Phone Field
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        enabled: _isEditMode,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: "رقم الجوال",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF878383),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Edit/Save Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isEditMode) {
                            _updateProfile();
                          } else {
                            setState(() => _isEditMode = true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D75B1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: Text(
                          _isEditMode ? "حفظ التغييرات" : "تعديل البيانات",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _showChangePassword = true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                            side: const BorderSide(
                              color: Color(0xFF1D75B1),
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "تغيير كلمة المرور",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.055,
                            color: const Color(0xFF1D75B1),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF111111),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: Text(
                          "تسجيل الخروج",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.055,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Delete Account Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _showDeleteAccount = true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "حذف الحساب",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.055,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),

            // Change Password Dialog
            if (_showChangePassword)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "تغيير كلمة المرور",
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomPasswordField(
                          controller: _currentPasswordController,
                          hintText: "كلمة المرور الحالية",
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        CustomPasswordField(
                          controller: _newPasswordController,
                          hintText: "كلمة المرور الجديدة",
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        CustomPasswordField(
                          controller: _confirmPasswordController,
                          hintText: "تأكيد كلمة المرور الجديدة",
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() => _showChangePassword = false);
                                _clearPasswordFields();
                              },
                              child: Text(
                                "إلغاء",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D75B1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "تأكيد",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Delete Account Dialog
            if (_showDeleteAccount)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "حذف الحساب",
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w800,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          "هذا الإجراء لا يمكن التراجع عنه. هل أنت متأكد؟",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          controller: _deleteEmailController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: "البريد الإلكتروني",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015,
                            ),
                            hintStyle: TextStyle(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        CustomPasswordField(
                          controller: _deletePasswordController,
                          hintText: "كلمة المرور",
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() => _showDeleteAccount = false);
                                _clearDeleteFields();
                              },
                              child: Text(
                                "إلغاء",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _deleteAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "حذف الحساب",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}