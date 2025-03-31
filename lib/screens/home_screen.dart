import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: const Color(0xFF1D75B1),
      ),
      body: const Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
