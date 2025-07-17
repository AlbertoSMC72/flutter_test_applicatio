import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTopBar extends StatefulWidget {
  final int notificationCount;
  final String searchHint;
  final VoidCallback? onSearchTap;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onUserTap;
  final VoidCallback? onViewProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onAddFriend;
  final VoidCallback? onNotifications;
  final VoidCallback? onLogout;

  const CustomTopBar({
    Key? key,
    this.notificationCount = 0,
    this.searchHint = "Buscar Libro",
    this.onSearchTap,
    this.searchController,
    this.onSearchChanged,
    this.onUserTap,
    this.onViewProfile,
    this.onSettings,
    this.onAddFriend,
    this.onNotifications,
    this.onLogout,
  }) : super(key: key);

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar> {
  void _navigateToProfile() {
    debugPrint('Navegando al perfil');
    context.push('/profile');
    widget.onViewProfile?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    final orientation = MediaQuery.of(context).orientation;

    // Ajustes según orientación
    final isLandscape = orientation == Orientation.landscape;
    final double containerHeight = isLandscape ? 45 : 60;
    final double iconSize = isLandscape ? 22 : 30;
    final double userButtonSize = isLandscape ? 40 : 60;
    final double badgeSize = isLandscape ? 22 : 37;
    final double badgeFontSize = isLandscape ? 9 : 13;
    final double horizontalPadding = isLandscape ? 10 : 20;
    final double verticalPadding = isLandscape ? 5 : 10;
    final double searchIconPadding = isLandscape ? 8 : 15;
    final double searchFieldVertical = isLandscape ? 8 : 15;
    final double searchFieldFontSize = isLandscape ? 13 : 16;
    final double spaceBetween = isLandscape ? 8 : 15;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding + (isLandscape ? 5 : 10),
        horizontalPadding,
        verticalPadding,
      ),
      child: Container(
        width: screenWidth,
        height: containerHeight,
        child: Row(
          children: [
            // Barra de búsqueda
            Expanded(
              child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(isLandscape ? 10 : 15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: searchIconPadding),
                      child: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: iconSize,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.searchController,
                        onChanged: widget.onSearchChanged,
                        onTap: widget.onSearchTap,
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: GoogleFonts.monomaniacOne(
                            color: Colors.black54,
                            fontSize: searchFieldFontSize,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: searchFieldVertical,
                          ),
                        ),
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.black87,
                          fontSize: searchFieldFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(width: spaceBetween),
            
            // Botón de usuario con notificaciones
            Stack(
              children: [
                GestureDetector(
                  onTap: _navigateToProfile,
                  child: Container(
                    width: userButtonSize,
                    height: userButtonSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEC3D),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF1E1E1E),
                      size: iconSize,
                    ),
                  ),
                ),
                
                // Badge de notificaciones
                if (widget.notificationCount > 2)
                  Positioned(
                    right: isLandscape ? -5 : -8,
                    bottom: isLandscape ? -5 : -8,
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8292C),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.notificationCount > 99 
                              ? '+99' 
                              : '${widget.notificationCount}',
                          style: GoogleFonts.monomaniacOne(
                            color: Colors.white,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}