import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

// App-specific imports
import '../../services/home_service.dart';

/// Theme extension for custom app colors - for internal use within MoreScreen
class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color dividerColor;

  // Social media brand colors
  final Map<String, Color> socialBrandColors;

  AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.dividerColor,
    required this.socialBrandColors,
  });

  // Light mode colors
  factory AppColors.light() {
    return AppColors(
      primaryColor: const Color(0xFF4DA8DA), // أزرق فاتح
      secondaryColor: const Color(0xFFB0E0E6), // سماوي فاتح
      accentColor: const Color(0xFF22C55E),
      backgroundColor: Colors.white,
      cardColor: Colors.white,
      textPrimaryColor: const Color(0xFF333333),
      textSecondaryColor: const Color(0xFF757575),
      dividerColor: const Color(0xFFE0E0E0), // رمادي فاتح
      socialBrandColors: {
        'facebook': const Color(0xFF1877F2),
        'twitter': const Color(0xFF1DA1F2),
        'x': const Color(0xFF000000),
        'instagram': const Color(0xFFE1306C),
        'youtube': const Color(0xFFFF0000),
        'linkedin': const Color(0xFF0077B5),
        'snapchat': const Color(0xFFFFFC00),
        'tiktok': const Color(0xFF000000),
        'whatsapp': const Color(0xFF25D366),
        'website': const Color(0xFF4DA8DA),
      },
    );
  }

  // Dark mode colors
  factory AppColors.dark() {
    return AppColors(
      primaryColor: const Color(0xFF4DA8DA),
      secondaryColor: const Color(0xFFB0E0E6),
      accentColor: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFF1E1E1E),
      cardColor: const Color(0xFF2C2C2C),
      textPrimaryColor: Colors.white,
      textSecondaryColor: const Color(0xFFBDBDBD),
      dividerColor: const Color(0xFF424242),
      socialBrandColors: {
        'facebook': const Color(0xFF1877F2),
        'twitter': const Color(0xFF1DA1F2),
        'x': const Color(0xFFFFFFFF),
        'instagram': const Color(0xFFE1306C),
        'youtube': const Color(0xFFFF0000),
        'linkedin': const Color(0xFF0077B5),
        'snapchat': const Color(0xFFFFFC00),
        'tiktok': const Color(0xFFFFFFFF),
        'whatsapp': const Color(0xFF25D366),
        'website': const Color(0xFF4DA8DA),
      },
    );
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? backgroundColor,
    Color? cardColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? dividerColor,
    Map<String, Color>? socialBrandColors,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      dividerColor: dividerColor ?? this.dividerColor,
      socialBrandColors: socialBrandColors ?? this.socialBrandColors,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      textPrimaryColor: Color.lerp(textPrimaryColor, other.textPrimaryColor, t)!,
      textSecondaryColor:
      Color.lerp(textSecondaryColor, other.textSecondaryColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      socialBrandColors: socialBrandColors, // Can't lerp a map, so just return this one
    );
  }
}

/// State class to manage social links data and loading states
class SocialLinksController extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<dynamic> socialLinks = [];
  DateTime? lastUpdated;

  // Loading states
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  SocialLinksController() {
    loadSocialLinks();
  }

  Future<void> loadSocialLinks() async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      notifyListeners();

      final response = await _homeService.getSocialUrls();
      if (response.statusCode == 200) {
        socialLinks = response.data['data'] ?? [];
        lastUpdated = DateTime.now();
        isLoading = false;
        notifyListeners();
      } else {
        _handleError('فشل في تحميل الروابط. الرجاء المحاولة مرة أخرى');
      }
    } catch (e) {
      _handleError('حدث خطأ أثناء الاتصال بالخادم');
    }
  }

  void _handleError(String message) {
    isLoading = false;
    hasError = true;
    errorMessage = message;
    notifyListeners();
  }
}

/// Reusable SectionHeader component
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const SectionHeader({Key? key, required this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color textColor =
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF333333);

    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        children: [
          Container(
            width: 4,
            height: screenWidth * 0.06,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
              color: textColor,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          if (icon != null)
            Icon(icon, size: screenWidth * 0.05, color: primaryColor),
        ],
      ),
    );
  }
}

/// Animated social link card with brand colors
class SocialLinkCard extends StatefulWidget {
  final String name;
  final String url;
  final Function(String) onTap;

  const SocialLinkCard({
    Key? key,
    required this.name,
    required this.url,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SocialLinkCard> createState() => _SocialLinkCardState();
}

class _SocialLinkCardState extends State<SocialLinkCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final Map<String, Color> _socialColors = {
    'facebook': const Color(0xFF1877F2),
    'twitter': const Color(0xFF1DA1F2),
    'x': Color.fromARGB(255, 0, 0, 0),
    'instagram': const Color(0xFFE1306C),
    'youtube': const Color(0xFFFF0000),
    'linkedin': const Color(0xFF0077B5),
    'snapchat': const Color(0xFFFFFC00),
    'tiktok': Color.fromARGB(255, 0, 0, 0),
    'whatsapp': const Color(0xFF25D366),
    'website': const Color(0xFF4DA8DA),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = widget.name.toLowerCase();
    final brandColor =
        _socialColors[platform] ?? Theme.of(context).primaryColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;

    return GestureDetector(
      onTap: () => widget.onTap(widget.url),
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSocialIcon(widget.name.toLowerCase()),
                    size: 24,
                    color: brandColor,
                    semanticLabel: 'رمز ${widget.name}',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDarkMode ? Colors.white : const Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform) {
      case 'facebook':
        return Ionicons.logo_facebook;
      case 'twitter':
      case 'x':
        return Ionicons.logo_twitter;
      case 'instagram':
        return Ionicons.logo_instagram;
      case 'youtube':
        return Ionicons.logo_youtube;
      case 'linkedin':
        return Ionicons.logo_linkedin;
      case 'snapchat':
        return Ionicons.logo_snapchat;
      case 'tiktok':
        return Ionicons.logo_tiktok;
      case 'whatsapp':
        return Ionicons.logo_whatsapp;
      case 'website':
        return Ionicons.globe_outline;
      default:
        return Ionicons.link_outline;
    }
  }
}

/// Custom key-value row for information display
class KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool alternate;

  const KeyValueRow({
    Key? key,
    required this.label,
    required this.value,
    this.actionIcon,
    this.onActionPressed,
    this.alternate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: alternate
            ? (isDarkMode
            ? const Color(0xFF2C2C2C)
            : const Color(0xFFF5F7FA))
            : (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDarkMode ? const Color(0xFFBDBDBD) : const Color(0xFF757575),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : const Color(0xFF333333),
              ),
              textAlign: TextAlign.end,
            ),
          ),
          if (actionIcon != null && onActionPressed != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(actionIcon, size: 18, color: primaryColor),
              onPressed: onActionPressed,
              tooltip: 'نسخ',
              splashRadius: 18,
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom quick action button component
class QuickActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : const Color(0xFF333333),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.grey : Colors.grey.shade600,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom pull-to-refresh indicator with branded styling
class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      color: primaryColor,
      strokeWidth: 2,
      displacement: 30,
      child: child,
    );
  }
}

/// Error state widget with retry button
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 50,
              color: primaryColor.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget with illustration
class EmptyStateWidget extends StatelessWidget {
  final String message;

  const EmptyStateWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link_off,
              size: 50,
              color: (isDarkMode ? Colors.grey : Colors.grey.shade400)
                  .withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// MoreScreen - Main screen implementation
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  /// Controller for social links data
  final SocialLinksController _controller = SocialLinksController();

  /// App information including name, version, developer, and contact
  final Map<String, String> _appInfo = {
    'appName': 'البكر للتكييف',
    'appVersion': '1.0.0',
    'appDeveloper': 'شركة البكر للتكييف',
    'appEmail': 'info@albakr-ac.com',
  };

  // Animation controller for header
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    // Setup header animation
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Refreshes social links data with animation
  Future<void> _refreshData() async {
    _headerAnimationController.forward();
    await _controller.loadSocialLinks();
    await Future.delayed(const Duration(milliseconds: 300));
    _headerAnimationController.reverse();
  }

  /// Launches a URL in the device's default browser with error handling
  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar('تعذر فتح الرابط');
      }
    } catch (e) {
      _showErrorSnackbar('حدث خطأ أثناء فتح الرابط');
    }
  }

  /// Shows error snackbar with themed styling
  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Copies text to clipboard with feedback
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم النسخ إلى الحافظة'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    double screenWidth = size.width;
    double screenHeight = size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: backgroundColor,
          child: CustomRefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenHeight * 0.07),

                      // Header with animation
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _headerAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _headerAnimation.value,
                                  child: child,
                                );
                              },
                              child: Text(
                                "المزيد",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: screenWidth * 0.06,
                                  color: isDarkMode ? Colors.white : const Color(0xFF333333),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            if (_controller.lastUpdated != null)
                              Text(
                                'آخر تحديث: ${_controller.lastUpdated!.year}-${_controller.lastUpdated!.month.toString().padLeft(2, '0')}-${_controller.lastUpdated!.day.toString().padLeft(2, '0')} – ${_controller.lastUpdated!.hour.toString().padLeft(2, '0')}:${_controller.lastUpdated!.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Social links section
                      const SectionHeader(
                        title: 'تواصل معنا',
                        icon: Ionicons.share_social_outline,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Social links grid
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: _buildSocialLinksSection(
                          isTablet,
                          screenWidth,
                          screenHeight,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Quick links section
                      const SectionHeader(
                        title: 'روابط سريعة',
                        icon: Ionicons.link_outline,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Quick links list
                      _buildQuickLinksSection(screenWidth, screenHeight),

                      SizedBox(height: screenHeight * 0.04),

                      // App info section
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: _buildAppInfoSection(screenWidth, screenHeight),
                      ),

                      SizedBox(height: screenHeight * 0.08),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // لوجيك تسجيل الخروج هنا
                          },
                          child: Text('تسجيل الخروج'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the social links section with loading/error states
  Widget _buildSocialLinksSection(
      bool isTablet,
      double screenWidth,
      double screenHeight,
      ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    if (_controller.isLoading) {
      return SizedBox(
        height: screenHeight * 0.25,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.1,
                height: screenWidth * 0.1,
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'جاري تحميل الروابط...',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller.hasError) {
      return ErrorStateWidget(
        message: _controller.errorMessage,
        onRetry: _refreshData,
      );
    }

    if (_controller.socialLinks.isEmpty) {
      return const EmptyStateWidget(
        message: 'لا توجد روابط اجتماعية متاحة حالياً',
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 3,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenWidth * 0.03,
      ),
      itemCount: _controller.socialLinks.length,
      itemBuilder: (context, index) {
        final socialLink = _controller.socialLinks[index];
        final String name = socialLink['name'] ?? '';
        final String url = socialLink['url'] ?? '';

        return SocialLinkCard(name: name, url: url, onTap: _launchUrl);
      },
    );
  }

  /// Builds the quick links section with action buttons
  Widget _buildQuickLinksSection(double screenWidth, double screenHeight) {
    return Column(
      children: [
        QuickActionTile(
          title: 'من نحن',
          icon: Icons.info_outline,
          onTap: () {},
        ),
        SizedBox(height: screenHeight * 0.01),
        QuickActionTile(
          title: 'سياسة الخصوصية',
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
        SizedBox(height: screenHeight * 0.01),
        QuickActionTile(
          title: 'سياسة الاستبدال',
          icon: Icons.swap_horiz,
          onTap: () {},
        ),
        SizedBox(height: screenHeight * 0.01),
        QuickActionTile(
          title: 'اتصل بنا',
          icon: Icons.support_agent,
          onTap: () {},
        ),
      ],
    );
  }

  /// Builds the app information section with styled cards
  Widget _buildAppInfoSection(double screenWidth, double screenHeight) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.015),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  Text(
                    'معلومات التطبيق',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _appInfo.length,
              separatorBuilder:
                  (context, index) => SizedBox(height: screenHeight * 0.01),
              itemBuilder: (context, index) {
                final entry = _appInfo.entries.elementAt(index);
                final isEmail = entry.key == 'appEmail';

                return KeyValueRow(
                  label: _getInfoLabel(entry.key),
                  value: entry.value,
                  actionIcon: isEmail ? Icons.copy : null,
                  onActionPressed:
                  isEmail ? () => _copyToClipboard(entry.value) : null,
                  alternate: index.isOdd,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to get human-readable labels for app info
  String _getInfoLabel(String key) {
    switch (key) {
      case 'appName':
        return 'اسم التطبيق';
      case 'appVersion':
        return 'الإصدار';
      case 'appDeveloper':
        return 'المطور';
      case 'appEmail':
        return 'البريد الإلكتروني';
      default:
        return key;
    }
  }
}