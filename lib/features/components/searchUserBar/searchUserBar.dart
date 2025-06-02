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
    this.searchHint = "Buscar...",
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

  // Función por defecto para mostrar SnackBar
  void _showDefaultAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(action),
        backgroundColor: const Color(0xFFECEC3D),
        duration: const Duration(seconds: 2),
      ),
    );
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
          screenWidth * 0.05,
          topPadding + 10,
          screenWidth * 0.05,
          10,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                // Barra de búsqueda
                Container(
                  width: _isMenuOpen ? screenWidth * 0.48 - 40 : screenWidth - 120,
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
                      if (!_isMenuOpen)
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
            
            // Menú desplegable como en la imagen
            if (_isMenuOpen)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: screenWidth * 0.48, // 185 de 381 ≈ 48%
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
                  child: Stack(
                    children: [
                      // Ver Perfil
                      Positioned(
                        left: 8,
                        top: 14.86,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu();
                            if (widget.onViewProfile != null) {
                              widget.onViewProfile!();
                            } else {
                              _showDefaultAction(context, 'Ver Perfil presionado');
                            }
                          },
                          child: SizedBox(
                            height: 28.74,
                            child: Text(
                              'Ver Perfil',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Configuración
                      Positioned(
                        left: 8,
                        top: 53.51,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu();
                            if (widget.onSettings != null) {
                              widget.onSettings!();
                            } else {
                              _showDefaultAction(context, 'Configuración presionada');
                            }
                          },
                          child: SizedBox(
                            height: 28.74,
                            child: Text(
                              'Configuración',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Agregar Amigo
                      Positioned(
                        left: 8,
                        top: 92.15,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu();
                            if (widget.onAddFriend != null) {
                              widget.onAddFriend!();
                            } else {
                              _showDefaultAction(context, 'Agregar Amigo presionado');
                            }
                          },
                          child: SizedBox(
                            height: 28.74,
                            child: Text(
                              'Agregar Amigo',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Notificaciones
                      Positioned(
                        left: 8,
                        top: 130.80,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu();
                            if (widget.onNotifications != null) {
                              widget.onNotifications!();
                            } else {
                              _showDefaultAction(context, 'Notificaciones presionadas');
                            }
                          },
                          child: SizedBox(
                            height: 28.74,
                            child: Text(
                              'Notificaciones',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Cerrar Sesión
                      Positioned(
                        left: 8,
                        top: 169.45,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _closeMenu();
                            if (widget.onLogout != null) {
                              widget.onLogout!();
                            } else {
                              _showLogoutDialog(context);
                            }
                          },
                          child: SizedBox(
                            height: 28.74,
                            child: Text(
                              'Cerrar Sesión',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Icono de usuario en la esquina superior derecha del menú
                      Positioned(
                        right: 15,
                        top: 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.person,
                            color: const Color(0xFF1E1E1E),
                            size: 24,
                          ),
                        ),
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

  // Diálogo por defecto para logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Cerrar Sesión',
          style: GoogleFonts.monomaniacOne(
            color: Colors.white,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: GoogleFonts.monomaniacOne(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.monomaniacOne(
                color: const Color(0xFFECEC3D),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDefaultAction(context, 'Sesión cerrada');
            },
            child: Text(
              'Cerrar Sesión',
              style: GoogleFonts.monomaniacOne(
                color: const Color(0xFFD8292C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}