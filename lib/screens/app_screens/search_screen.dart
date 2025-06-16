/// The search screen of the application that allows users to search for products.
///
/// Features:
/// - Search input field with custom styling
/// - Back navigation button
/// - Arabic language support
/// - Custom search icon
/// - Placeholder illustration
///
/// The screen includes:
/// - Header with title "البحث" (Search)
/// - Back button with forward arrow icon
/// - Search field with custom styling
/// - Centered logo illustration
import 'package:flutter/material.dart';

/// Search screen widget that provides product search functionality.
///
/// This screen implements a search interface with:
/// - Custom styled search input
/// - Arabic text alignment
/// - Navigation controls
/// - Visual feedback
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.06),

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
                    // Header title "البحث" (Search)
                    Text(
                      "البحث",
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

                SizedBox(height: screenHeight * 0.08),

                // Custom styled search input field
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.08,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "أدخل كلمة البحث",
                      hintStyle: TextStyle(
                        fontSize: screenWidth * 0.037,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        color: const Color(0xFF878383),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.065),
                        child: Image.asset(
                          'assets/images/search-normal_broken.png',
                          width: screenWidth * 0.05,
                          height: screenWidth * 0.05,
                          color: const Color(0xFF1D75B1),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top: screenHeight * 0.025,
                        right: screenWidth * 0.08,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.25),

                // Centered logo illustration
                Center(
                  child: Image.asset(
                    'assets/images/Group 176217.png',
                    width: screenWidth * 0.43,
                    height: screenHeight * 0.23,
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
