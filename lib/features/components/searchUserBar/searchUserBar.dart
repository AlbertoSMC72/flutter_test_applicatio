import 'package:flutter/material.dart';
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
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    widget.onUserTap?.call();
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: _closeMenu,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.fromLTRB(
          20,
          topPadding + 10,
          20,
          10,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Barra superior (siempre visible)
            Container(
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
                        onTap: _toggleMenu,
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
                          child: Icon(
                            _isMenuOpen ? Icons.close : Icons.person,
                            color: const Color(0xFF1E1E1E),
                            size: 30,
                          ),
                        ),
                      ),
                      
                      // Badge de notificaciones
                      if (widget.notificationCount > 0 && !_isMenuOpen)
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
            
            // Menú desplegable simplificado
            if (_isMenuOpen)
              Positioned(
                left: screenWidth - 40 - 181, // Más margen de la derecha (20 + 20)
                top: 73,
                child: Container(
                  width: 181,
                  height: 218,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEC3D),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Ver Perfil
                      _buildMenuItem(
                        'Ver Perfil',
                        () {
                          _closeMenu();
                          widget.onViewProfile?.call();
                        },
                        isFirst: true,
                      ),
                      
                      // Configuración
                      _buildMenuItem(
                        'Configuración',
                        () {
                          _closeMenu();
                          widget.onSettings?.call();
                        },
                      ),
                      
                      // Agregar Amigo
                      _buildMenuItem(
                        'Agregar Amigo',
                        () {
                          _closeMenu();
                          widget.onAddFriend?.call();
                        },
                      ),
                      
                      // Notificaciones
                      _buildMenuItem(
                        'Notificaciones',
                        () {
                          _closeMenu();
                          widget.onNotifications?.call();
                        },
                      ),
                      
                      // Cerrar Sesión
                      _buildMenuItem(
                        'Cerrar Sesión',
                        () {
                          _closeMenu();
                          widget.onLogout?.call();
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback onTap, {bool isFirst = false, bool isLast = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 181,
        height: 43.6, // 218 / 5 = 43.6
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.monomaniacOne(
              color: const Color(0xFF1E1E1E),
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}