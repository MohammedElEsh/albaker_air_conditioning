import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../widgets/custom_password_field.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
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
  bool _isLoading = true;
  bool _isEditMode = false;
  bool _showChangePassword = false;
  bool _showDeleteAccount = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تحميل البيانات: $e')));
    }
  }

  Future<void> _updateProfile() async {
    try {
      var response = await _userService.updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
      );
      if (response.statusCode == 200) {
        setState(() => _isEditMode = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تحديث البيانات: $e')));
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تغيير كلمة المرور: $e')));
    }
  }

  Future<void> _deleteAccount() async {
    try {
      var response = await _userService.deleteAccount(
        email: _deleteEmailController.text,
        password: _deletePasswordController.text,
      );
      if (response.statusCode == 200) {
        await _userService.clearToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في حذف الحساب: $e')));
    }
  }

  Future<void> _logout() async {
    try {
      var response = await _userService.logout();
      if (response.statusCode == 200) {
        await _userService.clearToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تسجيل الخروج: $e')));
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    // Header
                    Positioned(
                      top: 50,
                      left: 160,
                      child: const Text(
                        "الملف الشخصي",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Back button
                    Positioned(
                      top: 50,
                      right: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF1D75B1),
                          size: 24,
                        ),
                      ),
                    ),

                    // Profile Image
                    Positioned(
                      top: 100,
                      left: 165,
                      child: Container(
                        width: 123,
                        height: 123,
                        child: Center(
                          child: Image.asset(
                            'assets/images/user.png',
                            width: 100,
                            height: 100,
                            color: const Color(0xFF1D75B1),
                          ),
                        ),
                      ),
                    ),

                    // Form Fields
                    Positioned(
                      top: 250,
                      left: 33,
                      right: 33,
                      child: Column(
                        children: [
                          // First Name Field
                          Container(
                            width: 363,
                            height: 76,
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: TextField(
                              controller: _firstNameController,
                              enabled: _isEditMode,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "الاسم الأول",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF878383),
                                ),
                              ),
                            ),
                          ),

                          // Last Name Field
                          Container(
                            width: 363,
                            height: 76,
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: TextField(
                              controller: _lastNameController,
                              enabled: _isEditMode,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "الاسم الأخير",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF878383),
                                ),
                              ),
                            ),
                          ),

                          // Phone Field
                          Container(
                            width: 363,
                            height: 76,
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: TextField(
                              controller: _phoneController,
                              enabled: _isEditMode,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: "رقم الجوال",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF878383),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Edit/Save Button
                          SizedBox(
                            width: 363,
                            height: 76,
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
                                _isEditMode
                                    ? "حفظ التغييرات"
                                    : "تعديل البيانات",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Change Password Button
                          SizedBox(
                            width: 363,
                            height: 76,
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
                              child: const Text(
                                "تغيير كلمة المرور",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Color(0xFF1D75B1),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Logout Button
                          SizedBox(
                            width: 363,
                            height: 76,
                            child: ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1111),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(38),
                                ),
                              ),
                              child: const Text(
                                "تسجيل الخروج",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Delete Account Button
                          SizedBox(
                            width: 363,
                            height: 76,
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
                              child: const Text(
                                "حذف الحساب",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Change Password Dialog
                    if (_showChangePassword)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: Container(
                              width: 363,
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(38),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "تغيير كلمة المرور",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  CustomPasswordField(
                                    controller: _currentPasswordController,
                                    hintText: "كلمة المرور الحالية",
                                  ),
                                  const SizedBox(height: 15),
                                  CustomPasswordField(
                                    controller: _newPasswordController,
                                    hintText: "كلمة المرور الجديدة",
                                  ),
                                  const SizedBox(height: 15),
                                  CustomPasswordField(
                                    controller: _confirmPasswordController,
                                    hintText: "تأكيد كلمة المرور الجديدة",
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(
                                            () => _showChangePassword = false,
                                          );
                                        },
                                        child: const Text("إلغاء"),
                                      ),
                                      ElevatedButton(
                                        onPressed: _changePassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1D75B1,
                                          ),
                                          foregroundColor:
                                              Colors
                                                  .white, // <-- this makes the text white
                                        ),
                                        child: const Text("تأكيد"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Delete Account Dialog
                    if (_showDeleteAccount)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: Center(
                            child: Container(
                              width: 363,
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(38),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "حذف الحساب",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "هذا الإجراء لا يمكن التراجع عنه. هل أنت متأكد؟",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: _deleteEmailController,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      hintText: "البريد الإلكتروني",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 15,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  CustomPasswordField(
                                    controller: _deletePasswordController,
                                    hintText: "كلمة المرور",
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(
                                            () => _showDeleteAccount = false,
                                          );
                                        },
                                        child: const Text("إلغاء"),
                                      ),
                                      ElevatedButton(
                                        onPressed: _deleteAccount,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text(
                                          "حذف الحساب",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
