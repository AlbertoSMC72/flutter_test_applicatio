import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/../../core/theme/app_colors.dart';

class CustomNavigationBar extends StatefulWidget {
  final bool isVisible;
  final String currentRoute;

  const CustomNavigationBar({
    Key? key,
    this.isVisible = true,
    required this.currentRoute,
  }) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  bool _isExpanded = false;

  // Determina el índice actual basado en la ruta
  int get currentIndex {
    switch (widget.currentRoute) {
      case '/downloaded':
        return 0;
      case '/writening':
        return 1;
      case '/home':
        return 2;
      case '/favorites':
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
        route = '/downloaded';
        break;
      case 1:
        route = '/writening';
        break;
      case 2:
        route = '/home';
        break;
      case 3:
        route = '/favorites';
        break;
      case 4:
        route = '/login';
        break;
      default:
        route = '/home';
    }
    // Solo navegar si no estamos en la misma ruta
    if (widget.currentRoute.toLowerCase() != route) {
      context.push(route);
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Ajustes dinámicos
    final double barThickness = isLandscape
        ? screenHeight * 0.7 // Alto de la barra lateral
        : 60.0; // Alto de la barra inferior
    final double iconSize = isLandscape
        ? screenHeight * 0.045
        : screenWidth * 0.065;
    final double centerIconSize = isLandscape
        ? screenHeight * 0.055
        : screenWidth * 0.08;
    final double itemExtent = isLandscape
        ? screenHeight * 0.11
        : screenWidth * 0.1;
    final double centerItemExtent = isLandscape
        ? screenHeight * 0.13
        : screenWidth * 0.12;

    if (isLandscape) {
      // Barra lateral derecha en horizontal, colapsable
      final double collapsedWidth = 40.0;
      final double expandedWidth = 70.0;
      return Positioned(
        top: (screenHeight - barThickness) / 2,
        right: widget.isVisible ? 0 : -80,
        bottom: null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: _isExpanded ? expandedWidth : collapsedWidth,
          height: barThickness,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 8,
                offset: const Offset(-4, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                // Botón de menú para expandir/colapsar
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: IconButton(
                    icon: Icon(_isExpanded ? Icons.arrow_back_ios : Icons.menu),
                    iconSize: 20,
                    onPressed: _toggleExpand,
                    tooltip: _isExpanded ? 'Colapsar' : 'Expandir',
                  ),
                ),
                // Íconos distribuidos en el espacio restante
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calcula el tamaño máximo posible para los íconos
                      final double availableHeight = constraints.maxHeight;
                      final int iconCount = 5;
                      final double minIconExtent = 36.0;
                      final double maxIconExtent = _isExpanded ? centerItemExtent : minIconExtent;
                      final double itemExtent = (availableHeight / iconCount).clamp(minIconExtent, maxIconExtent);
                      final double iconSize = itemExtent * 0.65;
                      final double centerIconSize = itemExtent * 0.8;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavBarItem(
                            icon: Icons.download,
                            index: 0,
                            currentIndex: currentIndex,
                            iconSize: iconSize,
                            itemExtent: itemExtent,
                            onTap: () {
                              if (!_isExpanded) _toggleExpand();
                              _navigateToPage(context, 0);
                            },
                          ),
                          _NavBarItem(
                            icon: Icons.edit,
                            index: 1,
                            currentIndex: currentIndex,
                            iconSize: iconSize,
                            itemExtent: itemExtent,
                            onTap: () {
                              if (!_isExpanded) _toggleExpand();
                              _navigateToPage(context, 1);
                            },
                          ),
                          _NavBarItem(
                            icon: Icons.home,
                            index: 2,
                            currentIndex: currentIndex,
                            isCenter: true,
                            iconSize: centerIconSize,
                            itemExtent: itemExtent,
                            onTap: () {
                              if (!_isExpanded) _toggleExpand();
                              _navigateToPage(context, 2);
                            },
                          ),
                          _NavBarItem(
                            icon: Icons.favorite,
                            index: 3,
                            currentIndex: currentIndex,
                            iconSize: iconSize,
                            itemExtent: itemExtent,
                            onTap: () {
                              if (!_isExpanded) _toggleExpand();
                              _navigateToPage(context, 3);
                            },
                          ),
                          _NavBarItem(
                            icon: Icons.chat_bubble,
                            index: 4,
                            currentIndex: currentIndex,
                            iconSize: iconSize,
                            itemExtent: itemExtent,
                            onTap: () {
                              if (!_isExpanded) _toggleExpand();
                              _navigateToPage(context, 4);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Barra inferior en vertical
    return Positioned(
      bottom: widget.isVisible ? 0 : -80,
      left: 0,
      right: 0,
      child: Container(
        width: screenWidth,
        height: barThickness,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
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
              _NavBarItem(
                icon: Icons.download,
                index: 0,
                currentIndex: currentIndex,
                iconSize: iconSize,
                itemExtent: itemExtent,
                onTap: () => _navigateToPage(context, 0),
              ),
              _NavBarItem(
                icon: Icons.edit,
                index: 1,
                currentIndex: currentIndex,
                iconSize: iconSize,
                itemExtent: itemExtent,
                onTap: () => _navigateToPage(context, 1),
              ),
              _NavBarItem(
                icon: Icons.home,
                index: 2,
                currentIndex: currentIndex,
                isCenter: true,
                iconSize: centerIconSize,
                itemExtent: centerItemExtent,
                onTap: () => _navigateToPage(context, 2),
              ),
              _NavBarItem(
                icon: Icons.favorite,
                index: 3,
                currentIndex: currentIndex,
                iconSize: iconSize,
                itemExtent: itemExtent,
                onTap: () => _navigateToPage(context, 3),
              ),
              _NavBarItem(
                icon: Icons.chat_bubble,
                index: 4,
                currentIndex: currentIndex,
                iconSize: iconSize,
                itemExtent: itemExtent,
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
  final double? iconSize;
  final double? itemExtent;
  final VoidCallback? onTap;

  const _NavBarItem({
    Key? key,
    required this.icon,
    required this.index,
    required this.currentIndex,
    this.isCenter = false,
    this.iconSize,
    this.itemExtent,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemExtent ?? 40,
        height: itemExtent ?? 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.textDark.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: iconSize ?? 24,
          color: isSelected 
              ? AppColors.textDark
              : AppColors.textDark.withOpacity(0.7),
        ),
      ),
    );
  }
}