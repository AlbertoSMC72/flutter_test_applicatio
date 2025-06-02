import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Fondo de pantalla
          
          const CustomTopBar(),
          const CustomNavigationBar(),
        ],
      ),
    );
  }
}