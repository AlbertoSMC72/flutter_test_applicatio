import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final bool isVisible;
  final int currentIndex;
  final Function(int)? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onEdit;
  final VoidCallback? onHome;
  final VoidCallback? onFavorite;
  final VoidCallback? onMessages;

  const CustomNavigationBar({
    Key? key,
    this.isVisible = true,
    this.currentIndex = 2, // Home por defecto
    this.onTap,
    this.onDownload,
    this.onEdit,
    this.onHome,
    this.onFavorite,
    this.onMessages,
  }) : super(key: key);

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
          color: const Color(0xFFECEC3D), // Amarillo
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
              // Botón Download
              _NavBarItem(
                icon: Icons.download,
                index: 0,
                currentIndex: currentIndex,
                onTap: () {
                  if (onTap != null) {
                    onTap!(0);
                  }
                  if (onDownload != null) {
                    onDownload!();
                  } else {
                    // _showDefaultAction(context, 'Descargas presionado');
                  }
                },
              ),
              
              // Botón Edit
              _NavBarItem(
                icon: Icons.edit,
                index: 1,
                currentIndex: currentIndex,
                onTap: () {
                  if (onTap != null) {
                    onTap!(1);
                  }
                  if (onEdit != null) {
                    onEdit!();
                  } else {
                    // _showDefaultAction(context, 'Editar presionado');
                  }
                },
              ),
              
              // Botón Home (Centro - más grande)
              _NavBarItem(
                icon: Icons.home,
                index: 2,
                currentIndex: currentIndex,
                isCenter: true,
                onTap: () {
                  if (onTap != null) {
                    onTap!(2);
                  }
                  if (onHome != null) {
                    onHome!();
                  } else {
                    //_showDefaultAction(context, 'Home presionado');
                  }
                },
              ),
              
              // Botón Favorite
              _NavBarItem(
                icon: Icons.favorite,
                index: 3,
                currentIndex: currentIndex,
                onTap: () {
                  if (onTap != null) {
                    onTap!(3);
                  }
                  if (onFavorite != null) {
                    onFavorite!();
                  } else {
                    //_showDefaultAction(context, 'Favoritos presionado');
                  }
                },
              ),
              
              // Botón Messages
              _NavBarItem(
                icon: Icons.chat_bubble,
                index: 4,
                currentIndex: currentIndex,
                onTap: () {
                  if (onTap != null) {
                    onTap!(4);
                  }
                  if (onMessages != null) {
                    onMessages!();
                  } else {
                    //_showDefaultAction(context, 'Mensajes presionado');
                  }
                },
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

// Widget helper para usar la NavigationBar en Stack
class ScreenWithNavBar extends StatelessWidget {
  final Widget child;
  final bool showNavBar;
  final int currentNavIndex;
  final Function(int)? onNavTap;
  final VoidCallback? onDownload;
  final VoidCallback? onEdit;
  final VoidCallback? onHome;
  final VoidCallback? onFavorite;
  final VoidCallback? onMessages;

  const ScreenWithNavBar({
    Key? key,
    required this.child,
    this.showNavBar = true,
    this.currentNavIndex = 2,
    this.onNavTap,
    this.onDownload,
    this.onEdit,
    this.onHome,
    this.onFavorite,
    this.onMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          Positioned.fill(
            bottom: showNavBar ? 80 : 0,
            child: child,
          ),
          
          // Navigation Bar
          CustomNavigationBar(
            isVisible: showNavBar,
            currentIndex: currentNavIndex,
            onTap: onNavTap,
            onDownload: onDownload,
            onEdit: onEdit,
            onHome: onHome,
            onFavorite: onFavorite,
            onMessages: onMessages,
          ),
        ],
      ),
    );
  }
}

// Implementación como BottomNavigationBar para Scaffold
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onEdit;
  final VoidCallback? onHome;
  final VoidCallback? onFavorite;
  final VoidCallback? onMessages;

  const CustomBottomNavBar({
    Key? key,
    this.currentIndex = 2,
    this.onTap,
    this.onDownload,
    this.onEdit,
    this.onHome,
    this.onFavorite,
    this.onMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFECEC3D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomNavItem(
              icon: Icons.download,
              index: 0,
              currentIndex: currentIndex,
              onTap: () {
                if (onTap != null) onTap!(0);
                if (onDownload != null) {
                  onDownload!();
                } else {
                  // _showDefaultAction(context, 'Descargas presionado');
                }
              },
            ),
            _BottomNavItem(
              icon: Icons.edit,
              index: 1,
              currentIndex: currentIndex,
              onTap: () {
                if (onTap != null) onTap!(1);
                if (onEdit != null) {
                  onEdit!();
                } else {
                  // _showDefaultAction(context, 'Editar presionado');
                }
              },
            ),
            _BottomNavItem(
              icon: Icons.home,
              index: 2,
              currentIndex: currentIndex,
              isCenter: true,
              onTap: () {
                if (onTap != null) onTap!(2);
                if (onHome != null) {
                  onHome!();
                } else {
                  // _showDefaultAction(context, 'Home presionado');
                }
              },
            ),
            _BottomNavItem(
              icon: Icons.favorite,
              index: 3,
              currentIndex: currentIndex,
              onTap: () {
                if (onTap != null) onTap!(3);
                if (onFavorite != null) {
                  onFavorite!();
                } else {
                  // _showDefaultAction(context, 'Favoritos presionado');
                }
              },
            ),
            _BottomNavItem(
              icon: Icons.chat_bubble,
              index: 4,
              currentIndex: currentIndex,
              onTap: () {
                if (onTap != null) onTap!(4);
                if (onMessages != null) {
                  onMessages!();
                } else {
                  // _showDefaultAction(context, 'Mensajes presionado');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final bool isCenter;
  final VoidCallback? onTap;

  const _BottomNavItem({
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
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isCenter ? 60 : 50,
        height: isCenter ? 60 : 50,
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.black.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: isCenter ? 32 : 24,
          color: isSelected 
              ? const Color(0xFF1E1E1E)
              : const Color(0xFF1E1E1E).withOpacity(0.7),
        ),
      ),
    );
  }
}