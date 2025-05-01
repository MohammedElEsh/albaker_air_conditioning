// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// App-specific imports
import '../../services/home_service.dart';

/// MoreScreen - Display social links and more options
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  // Services
  final HomeService _homeService = HomeService();

  // State variables
  List<dynamic> _socialLinks = [];
  bool _isLoading = true;

  // App information
  final Map<String, String> _appInfo = {
    'appName': 'البكر للتكييف',
    'appVersion': '1.0.0',
    'appDeveloper': 'شركة البكر للتكييف',
    'appEmail': 'info@albakr-ac.com',
  };

  @override
  void initState() {
    super.initState();
    _loadSocialLinks();
  }

  /// Load social links from API
  Future<void> _loadSocialLinks() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _homeService.getSocialUrls();
      if (response.statusCode == 200) {
        setState(() {
          _socialLinks = response.data['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  /// Launch URL function
  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تعذر فتح الرابط'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء فتح الرابط'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Pull to refresh data
  Future<void> _refreshData() async {
    await _loadSocialLinks();
  }

  /// Build social links grid
  Widget _buildSocialLinksGrid() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_socialLinks.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'لا توجد روابط اجتماعية',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _socialLinks.length,
      itemBuilder: (context, index) {
        final socialLink = _socialLinks[index];
        final String name = socialLink['name'] ?? '';
        final String url = socialLink['url'] ?? '';

        return GestureDetector(
          onTap: () => _launchUrl(url),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getSocialIcon(name.toLowerCase()),
                  size: 30,
                  color: const Color(0xFF1D75B1),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get icon for social platform
  IconData _getSocialIcon(String platform) {
    switch (platform) {
      case 'facebook':
        return Icons.facebook;
      case 'twitter':
      case 'x':
        return Icons.message;
      case 'instagram':
        return Icons.camera_alt;
      case 'youtube':
        return Icons.play_arrow;
      case 'linkedin':
        return Icons.work;
      case 'snapchat':
        return Icons.camera;
      case 'tiktok':
        return Icons.music_note;
      case 'whatsapp':
        return Icons.chat;
      case 'telegram':
        return Icons.send;
      case 'website':
        return Icons.language;
      default:
        return Icons.link;
    }
  }

  /// Build app info section
  Widget _buildAppInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'معلومات التطبيق',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1D75B1),
            ),
          ),
          const SizedBox(height: 15),
          _buildInfoRow('اسم التطبيق', _appInfo['appName']!),
          _buildInfoRow('الإصدار', _appInfo['appVersion']!),
          _buildInfoRow('المطور', _appInfo['appDeveloper']!),
          _buildInfoRow('البريد الإلكتروني', _appInfo['appEmail']!),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton('من نحن', Icons.info_outline, () {
          // Navigate to About Us page
        }),
        _buildActionButton('سياسة الخصوصية', Icons.privacy_tip_outlined, () {
          // Navigate to Privacy Policy page
        }),
        _buildActionButton('سياسة الاستبدال', Icons.swap_horiz, () {
          // Navigate to Exchange Policy page
        }),
        _buildActionButton('اتصل بنا', Icons.support_agent, () {
          // Navigate to Contact Us page
        }),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1D75B1), size: 24),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "المزيد",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Social links section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D75B1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تواصل معنا',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSocialLinksGrid(),
            ),

            const SizedBox(height: 30),

            // Action buttons section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D75B1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'روابط سريعة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            _buildActionButtons(),

            const SizedBox(height: 30),

            // App info section
            _buildAppInfoSection(),

            // Add space at the bottom for the navbar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
