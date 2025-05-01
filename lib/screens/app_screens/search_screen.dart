import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Header title "البحث"
              Positioned(
                top: 50,
                left: 200,
                child: SizedBox(
                  width: 53,
                  height: 25,
                  child: const Text(
                    "البحث",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
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

              // Search field
              Positioned(
                top: 134,
                left: 40,
                child: Container(
                  width: 363,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(38),
                  ),
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "أدخل كلمة البحث",
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        color: Color(0xFF878383),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(27),
                        child: Image.asset(
                          'assets/images/search-normal_broken.png',
                          width: 21,
                          height: 21,
                          color: const Color(0xFF1D75B1),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 22, right: 33),
                    ),
                  ),
                ),
              ),

              // Logo in middle
              Positioned(
                top: 440,
                left: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Group 176217.png',
                        width: 172,
                        height: 188,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
