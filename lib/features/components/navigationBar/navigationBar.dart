import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationBar extends StatelessWidget {
  final bool isVisible;
  final String currentRoute;

  const CustomNavigationBar({
    Key? key,
    this.isVisible = true,
    required this.currentRoute,
  }) : super(key: key);

  // Determina el índice actual basado en la ruta
  int get currentIndex {
    switch (currentRoute) {
      case '/page2':
        return 0;
      case '/writening':
        return 1;
      case '/home':
        return 2;
      case '/test':
        return 3;
      case '/login':
        return 4;
      default:
        return 2; // Home por defecto
    }
  }

  void _navigateToPage(BuildContext context, int index) {
    String route;
    
    switch (index) {
      case 0:
        route = '/page2';
        break;
      case 1:
        route = '/writening';
        break;
      case 2:
        route = '/home';
        break;
      case 3:
        route = '/profile';
        break;
      case 4:
        route = '/login';
        break;
      default:
        route = '/home';
    }

    // Solo navegar si no estamos en la misma ruta
    if (currentRoute.toLowerCase() != route) {
      context.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Positioned(
      bottom: isVisible ? 0 : -80,
      left: 0,
      right: 0,
      child: Container(
        width: screenWidth,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFECEC3D),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Posts/Download
              _NavBarItem(
                icon: Icons.download,
                index: 0,
                currentIndex: currentIndex,
                onTap: () => _navigateToPage(context, 0),
              ),
              
              // Writing/Edit
              _NavBarItem(
                icon: Icons.edit,
                index: 1,
                currentIndex: currentIndex,
                onTap: () => _navigateToPage(context, 1),
              ),
              
              // Home (Centro)
              _NavBarItem(
                icon: Icons.home,
                index: 2,
                currentIndex: currentIndex,
                isCenter: true,
                onTap: () => _navigateToPage(context, 2),
              ),
              
              // Test/Favorite
              _NavBarItem(
                icon: Icons.favorite,
                index: 3,
                currentIndex: currentIndex,
                onTap: () => _navigateToPage(context, 3),
              ),
              
              // Login/Messages
              _NavBarItem(
                icon: Icons.chat_bubble,
                index: 4,
                currentIndex: currentIndex,
                onTap: () => _navigateToPage(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final bool isCenter;
  final VoidCallback? onTap;

  const _NavBarItem({
    Key? key,
    required this.icon,
    required this.index,
    required this.currentIndex,
    this.isCenter = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCenter ? screenWidth * 0.12 : screenWidth * 0.1,
        height: isCenter ? screenWidth * 0.12 : screenWidth * 0.1,
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.black.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: isCenter ? screenWidth * 0.08 : screenWidth * 0.065,
          color: isSelected 
              ? const Color(0xFF1E1E1E)
              : const Color(0xFF1E1E1E).withOpacity(0.7),
        ),
      ),
    );
  }
}