/// A custom bottom navigation bar widget for the app.
///
/// Features:
/// - Five navigation items with icons and labels
/// - Animated active state using Lottie animations
/// - Semi-transparent white background
/// - Rounded top corners
/// - Custom color scheme
/// - Notification system for navigation events
///
/// The navigation bar provides access to:
/// - Home
/// - Cart
/// - Projects
/// - Works
/// - More
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A reusable bottom navigation bar with consistent styling.
///
/// This widget creates a custom navigation bar with the following features:
/// - Fixed height of 100 pixels
/// - White background with rounded top corners
/// - Evenly spaced navigation items
/// - Active state animations using Lottie
/// - Custom color scheme (#1D75B1 for active items)
/// - Notification system for navigation events
///
/// The widget uses:
/// - Lottie animations for active state
/// - Static images for inactive state
/// - Custom color filters for active icons
/// - Gesture detection for item taps
class CustomNavbar extends StatefulWidget {
  const CustomNavbar({Key? key}) : super(key: key);

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  /// Index of the currently selected navigation item
  /// Defaults to home (index 4)
  int _selectedIndex = 4;

  /// List of navigation items with their properties
  /// Each item contains:
  /// - title: Display text
  /// - icon: Static image path for inactive state
  /// - activeIcon: Lottie animation path for active state
  final List<Map<String, String>> _navbarItems = [
    {
      'title': 'المزيد',
      'icon': 'assets/images/dots.png',
      'activeIcon': 'assets/animations/active_dots.json',
    },
    {
      'title': 'أعمالنا',
      'icon': 'assets/images/works.png',
      'activeIcon': 'assets/animations/active_works.json',
    },
    {
      'title': 'مشاريعنا',
      'icon': 'assets/images/trend.png',
      'activeIcon': 'assets/animations/active_trend.json',
    },
    {
      'title': 'العربة',
      'icon': 'assets/images/cart.png',
      'activeIcon': 'assets/animations/active_cart.json',
    },
    {
      'title': 'الرئيسية',
      'icon': 'assets/images/home.png',
      'activeIcon': 'assets/animations/active_home.json',
    },
  ];

  /// Handles navigation item taps
  ///
  /// Updates the selected index and dispatches a notification
  /// to inform parent widgets of the navigation change
  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    NavbarTapNotification(index).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _navbarItems.length,
            (index) => _buildNavItem(index, context),
          ),
        ),
      ),
    );
  }

  /// Builds a single navigation item with icon and label.
  ///
  /// Features:
  /// - Lottie animation for active state
  /// - Static image for inactive state
  /// - Custom color for active state
  /// - Bold text for active state
  /// - Gesture detection for taps
  ///
  /// Parameters:
  /// - index: The index of the navigation item
  /// - context: The build context for notifications
  Widget _buildNavItem(int index, BuildContext context) {
    final bool isActive = _selectedIndex == index;
    final item = _navbarItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child:
                isActive
                    ? Lottie.asset(
                      item['activeIcon']!,
                      repeat: false,
                      fit: BoxFit.contain,
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.colorFilter(
                            const ['**'],
                            value: const ColorFilter.mode(
                              Color(0xFF1D75B1),
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    )
                    : Image.asset(item['icon']!, fit: BoxFit.contain),
          ),
          const SizedBox(height: 4),
          Text(
            item['title']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF1D75B1) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom notification class for navbar taps.
///
/// Used to communicate navigation events to parent widgets.
/// Contains the index of the tapped navigation item.
class NavbarTapNotification extends Notification {
  /// Index of the tapped navigation item
  final int index;

  NavbarTapNotification(this.index);
}
