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

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(
        20,
        topPadding + 10,
        20,
        10,
      ),
      child: Container(
        width: screenWidth,
        height: 60,
        child: Row(
          children: [
            // Barra de búsqueda
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(15),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 30,
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
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 15),
            
            // Botón de usuario con notificaciones
            Stack(
              children: [
                GestureDetector(
                  onTap: _navigateToProfile,
                  child: Container(
                    width: 60,
                    height: 60,
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
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF1E1E1E),
                      size: 30,
                    ),
                  ),
                ),
                
                // Badge de notificaciones
                if (widget.notificationCount > 2)
                  Positioned(
                    right: -8,
                    bottom: -8,
                    child: Container(
                      width: 37,
                      height: 37,
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
                            fontSize: 13,
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