import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importa aquí tus componentes:
// import 'custom_top_bar.dart';
// import 'custom_navigation_bar.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int currentNavIndex = 2; // Home seleccionado por defecto
  int notificationCount = 7;
  bool showNavBar = true;
  TextEditingController searchController = TextEditingController();
  String currentScreen = 'Home';

  // Simular datos para la vista
  List<String> searchResults = [
    'Juan Pérez',
    'María García',
    'Carlos López',
    'Ana Martínez',
    'Luis Rodríguez',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    // Si el índice es -1, significa ocultar la barra de navegación
    if (index == -1) {
      setState(() {
        showNavBar = false;
      });
      return;
    }
    
    setState(() {
      currentNavIndex = index;
      // Cambiar contenido según la navegación
      switch (index) {
        case 0:
          currentScreen = 'Descargas';
          break;
        case 1:
          currentScreen = 'Editar';
          break;
        case 2:
          currentScreen = 'Home';
          break;
        case 3:
          currentScreen = 'Favoritos';
          break;
        case 4:
          currentScreen = 'Mensajes';
          break;
      }
    });
  }

  void _handleSearch(String query) {
    setState(() {
      // Simular búsqueda
      if (query.isNotEmpty) {
        searchResults = searchResults
            .where((name) => name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        searchResults = [
          'Juan Pérez',
          'María García',
          'Carlos López',
          'Ana Martínez',
          'Luis Rodríguez',
        ];
      }
    });
  }

  Widget _buildContent() {
    switch (currentScreen) {
      case 'Descargas':
        return _buildDownloadsContent();
      case 'Editar':
        return _buildEditContent();
      case 'Home':
        return _buildHomeContent();
      case 'Favoritos':
        return _buildFavoritesContent();
      case 'Mensajes':
        return _buildMessagesContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Bienvenido a Home',
          style: GoogleFonts.monomaniacOne(
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFFECEC3D),
                      child: Text(
                        searchResults[index][0],
                        style: GoogleFonts.monomaniacOne(
                          fontSize: 20,
                          color: const Color(0xFF1E1E1E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        searchResults[index],
                        style: GoogleFonts.monomaniacOne(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      color: const Color(0xFFECEC3D),
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download,
            size: 80,
            color: const Color(0xFFECEC3D),
          ),
          const SizedBox(height: 20),
          Text(
            'Sección de Descargas',
            style: GoogleFonts.monomaniacOne(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Aquí verás tus descargas',
            style: GoogleFonts.monomaniacOne(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit,
            size: 80,
            color: const Color(0xFFECEC3D),
          ),
          const SizedBox(height: 20),
          Text(
            'Editor',
            style: GoogleFonts.monomaniacOne(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Edita tu contenido aquí',
            style: GoogleFonts.monomaniacOne(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 80,
            color: const Color(0xFFECEC3D),
          ),
          const SizedBox(height: 20),
          Text(
            'Favoritos',
            style: GoogleFonts.monomaniacOne(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tus elementos favoritos',
            style: GoogleFonts.monomaniacOne(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble,
            size: 80,
            color: const Color(0xFFECEC3D),
          ),
          const SizedBox(height: 20),
          Text(
            'Mensajes',
            style: GoogleFonts.monomaniacOne(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tus conversaciones',
            style: GoogleFonts.monomaniacOne(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD8292C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$notificationCount mensajes nuevos',
                  style: GoogleFonts.monomaniacOne(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Elementos decorativos de fondo
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3D175C).withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3D175C).withOpacity(0.3),
              ),
            ),
          ),
          
          // Contenido principal
          Column(
            children: [
              // TopBar
              CustomTopBar(
                notificationCount: notificationCount,
                searchHint: "Buscar amigos...",
                searchController: searchController,
                onSearchChanged: _handleSearch,
                onViewProfile: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ver Perfil presionado'),
                      backgroundColor: const Color(0xFFECEC3D),
                    ),
                  );
                },
                onSettings: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Configuración presionada'),
                      backgroundColor: const Color(0xFFECEC3D),
                    ),
                  );
                },
                onAddFriend: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Agregar Amigo presionado'),
                      backgroundColor: const Color(0xFFECEC3D),
                    ),
                  );
                },
                onNotifications: () {
                  setState(() {
                    notificationCount = 0; // Marcar como leídas
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Notificaciones marcadas como leídas'),
                      backgroundColor: const Color(0xFFECEC3D),
                    ),
                  );
                },
                onLogout: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF2A2A2A),
                      title: Text(
                        'Cerrar Sesión',
                        style: GoogleFonts.monomaniacOne(color: Colors.white),
                      ),
                      content: Text(
                        '¿Estás seguro de que quieres cerrar sesión?',
                        style: GoogleFonts.monomaniacOne(color: Colors.white70),
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
                            // Aquí irías a la pantalla de login
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
                },
              ),
              
              // Contenido de la pantalla
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
          
          // NavigationBar
          CustomNavigationBar(
            isVisible: showNavBar,
            currentIndex: currentNavIndex,
            onTap: _handleNavigation,
            onDownload: () => _handleNavigation(0),
            onEdit: () => _handleNavigation(1),
            onHome: () => _handleNavigation(2),
            onFavorite: () => _handleNavigation(3),
            onMessages: () => _handleNavigation(4),
          ),
          // FAB para mostrar el NavBar cuando está oculto
          if (!showNavBar)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFECEC3D),
                onPressed: () {
                  setState(() {
                    showNavBar = true;
                    // Mantener la pantalla actual cuando se vuelve a mostrar
                  });
                },
                child: const Icon(
                  Icons.visibility,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class CustomTopBar extends StatefulWidget {
  final int notificationCount;
  final String searchHint;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final VoidCallback? onViewProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onAddFriend;
  final VoidCallback? onNotifications;
  final VoidCallback? onLogout;

  const CustomTopBar({
    Key? key,
    this.notificationCount = 0,
    this.searchHint = "Buscar...",
    this.searchController,
    this.onSearchChanged,
    this.onViewProfile,
    this.onSettings,
    this.onAddFriend,
    this.onNotifications,
    this.onLogout,
  }) : super(key: key);

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();
}

class _CustomTopBarState extends State<CustomTopBar>
    with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _searchBarAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchBarAnimation = Tween<double>(begin: 1.0, end: 0.48)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    if (_isMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              // Barra de búsqueda
              AnimatedBuilder(
                animation: _searchBarAnimation,
                builder: (context, child) {
                  return Container(
                    width: _isMenuOpen 
                        ? screenWidth * 0.48 - 40 // Cuando menú abierto: más pequeña
                        : screenWidth - 120,      // Cuando menú cerrado: más grande
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
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: Icon(Icons.search, color: Colors.black54, size: 24),
                        ),
                        if (!_isMenuOpen) // Solo mostrar texto cuando no está abierto el menú
                          Expanded(
                            child: TextField(
                              controller: widget.searchController,
                              onChanged: widget.onSearchChanged,
                              decoration: InputDecoration(
                                hintText: widget.searchHint,
                                hintStyle: GoogleFonts.monomaniacOne(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              style: GoogleFonts.monomaniacOne(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(width: 15),
              
              // Botón de usuario
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
                        size: 28,
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
                              fontSize: 12,
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
          
          // Menú desplegable
          if (_isMenuOpen)
            Positioned(
              top: 70,
              right: 0,
              child: Container(
                width: screenWidth * 0.48,
                decoration: BoxDecoration(
                  color: const Color(0xFFECEC3D),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem('Ver Perfil', widget.onViewProfile, Icons.person),
                    _buildMenuItem('Configuración', widget.onSettings, Icons.settings),
                    _buildMenuItem('Agregar Amigo', widget.onAddFriend, Icons.person_add),
                    _buildMenuItem('Notificaciones', widget.onNotifications, Icons.notifications),
                    _buildMenuItem('Cerrar Sesión', widget.onLogout, Icons.logout, isLast: true),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback? onTap, IconData icon, {bool isLast = false}) {
    return GestureDetector(
      onTap: () {
        _toggleMenu();
        onTap?.call();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: isLast 
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E1E1E),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.monomaniacOne(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: isVisible ? 0 : -80,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFFECEC3D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              // Iconos de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.download, 0),
                  _buildNavItem(Icons.edit, 1),
                  _buildNavItem(Icons.home, 2, isCenter: true),
                  _buildNavItem(Icons.favorite, 3),
                  _buildNavItem(Icons.chat_bubble, 4),
                ],
              ),
              
              // Botón para ocultar NavBar (esquina superior derecha)
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    // Callback para ocultar el NavBar
                    if (onTap != null) {
                      // Usar un índice especial para indicar "ocultar"
                      onTap!(-1);
                    }
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.visibility_off,
                      size: 16,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isCenter = false}) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: Container(
        width: isCenter ? 50 : 40,
        height: isCenter ? 50 : 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.transparent,
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