// lib/features/profile/presentation/profile_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/dependency_injection.dart' as di;
import '../../components/navigationBar/navigationBar.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // ID del usuario a mostrar (null = perfil propio)

  const ProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController searchController = TextEditingController();
  final StorageService _storageService = di.sl<StorageService>();
  
  // Estados de la pantalla
  bool _isLoading = true;
  bool _isOwnProfile = false;
  bool _isFollowed = false;
  bool _showFollowOptions = false;
  
  // Datos del perfil
  String _currentUserId = '';
  String _profileUserId = '';
  String _username = '';
  String _friendCode = '';
  String _bio = '';
  String _profileImageUrl = '';
  String _bannerImageUrl = '';
  int _friendsCount = 0;
  int _followersCount = 0;
  List<String> _favoriteGenres = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Obtener ID del usuario actual del storage
      final userData = await _storageService.getUserData();
      _currentUserId = userData['userId'] ?? '';
      
      // Determinar si es perfil propio o ajeno
      _profileUserId = widget.userId ?? _currentUserId;
      _isOwnProfile = _profileUserId == _currentUserId;

      // Simular llamada al backend
      await Future.delayed(const Duration(seconds: 1));
      
      if (_isOwnProfile) {
        // Datos del perfil propio (desde storage + backend)
        _username = userData['username'] ?? 'Mon mundo';
        _friendCode = '#CODE';
        _bio = 'Lorem ipsum dolor sit amet consectetur. Malesuada tristique arcu feugiat donec semper platea.';
        _profileImageUrl = '';
        _bannerImageUrl = 'https://placehold.co/411x163';
        _friendsCount = 6;
        _followersCount = 12;
        _favoriteGenres = ['ROMANCE', 'SCI-FI', 'AUTO AYUDA', 'HORROR', 'POLITICA', 'FAN FIC', 'DRAMA', 'AVENTURA', 'FANTASÍA', 'THRILLER', 'MISTERIO', 'COMEDIA'];
      } else {
        // Datos de perfil ajeno (desde backend)
        _username = _getStaticUserData(_profileUserId)['username'];
        _friendCode = _getStaticUserData(_profileUserId)['friendCode'];
        _bio = _getStaticUserData(_profileUserId)['bio'];
        _profileImageUrl = _getStaticUserData(_profileUserId)['profileImageUrl'];
        _bannerImageUrl = _getStaticUserData(_profileUserId)['bannerImageUrl'];
        _friendsCount = _getStaticUserData(_profileUserId)['friendsCount'];
        _followersCount = _getStaticUserData(_profileUserId)['followersCount'];
        _favoriteGenres = List<String>.from(_getStaticUserData(_profileUserId)['favoriteGenres']);
        
        // Verificar si ya estamos siguiendo a este usuario
        _isFollowed = await _checkIfFollowing(_profileUserId);
      }

      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      print('[DEBUG_PROFILE] Error cargando perfil: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar el perfil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Datos estáticos para diferentes usuarios (simula respuesta del backend)
  Map<String, dynamic> _getStaticUserData(String userId) {
    final Map<String, Map<String, dynamic>> users = {
      '1': {
        'username': 'Ana García',
        'friendCode': '#ANA123',
        'bio': 'Escritora apasionada de fantasía y romance. Me encanta crear mundos mágicos llenos de aventura.',
        'profileImageUrl': '',
        'bannerImageUrl': 'https://placehold.co/411x163',
        'friendsCount': 15,
        'followersCount': 87,
        'favoriteGenres': ['FANTASÍA', 'ROMANCE', 'AVENTURA', 'DRAMA'],
      },
      '2': {
        'username': 'Carlos López',
        'friendCode': '#CARLOS456',
        'bio': 'Fanático de la ciencia ficción y los thrillers. Siempre en busca de la próxima gran historia.',
        'profileImageUrl': '',
        'bannerImageUrl': 'https://placehold.co/411x163',
        'friendsCount': 23,
        'followersCount': 156,
        'favoriteGenres': ['SCI-FI', 'THRILLER', 'MISTERIO', 'HORROR'],
      },
      '3': {
        'username': 'María Rodríguez',
        'friendCode': '#MARIA789',
        'bio': 'Lectora voraz y crítica literaria. Comparto reseñas y recomendaciones de mis lecturas favoritas.',
        'profileImageUrl': '',
        'bannerImageUrl': 'https://placehold.co/411x163',
        'friendsCount': 8,
        'followersCount': 234,
        'favoriteGenres': ['DRAMA', 'BIOGRAFÍA', 'HISTORIA', 'POLITICA'],
      },
    };
    
    return users[userId] ?? users['1']!; // Default al usuario 1 si no existe
  }

  Future<bool> _checkIfFollowing(String userId) async {
    // Simular verificación en el backend
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Por defecto no seguimos a nadie
  }

  Future<void> _toggleFollow(String option) async {
    try {
      if (_isFollowed) {
        // Dejar de seguir
        await _unfollowUser(_profileUserId);
        setState(() {
          _isFollowed = false;
          _followersCount = _followersCount > 0 ? _followersCount - 1 : 0;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Has dejado de seguir a este usuario'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        // Seguir con opción específica
        await _followUser(_profileUserId, option);
        setState(() {
          _isFollowed = true;
          _followersCount++;
        });

        String message = '';
        switch (option) {
          case 'Todas':
            message = 'Ahora recibirás todas las notificaciones';
            break;
          case 'Personalizadas':
            message = 'Configurando notificaciones personalizadas';
            break;
          case 'Ninguna':
            message = 'Siguiendo sin notificaciones';
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _followUser(String userId, String notificationType) async {
    // Simular llamada al backend para seguir usuario
    await Future.delayed(const Duration(milliseconds: 500));
    print('[DEBUG_PROFILE] Siguiendo usuario $userId con notificaciones: $notificationType');
  }

  Future<void> _unfollowUser(String userId) async {
    // Simular llamada al backend para dejar de seguir
    await Future.delayed(const Duration(milliseconds: 500));
    print('[DEBUG_PROFILE] Dejando de seguir usuario $userId');
  }

  void _showEditProfileModal() {
    final TextEditingController usernameController = TextEditingController(text: _username);
    final TextEditingController bioController = TextEditingController(text: _bio);
    List<String> editableGenres = List.from(_favoriteGenres);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => StatefulBuilder(
        builder: (builderContext, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Editar Perfil',
                    style: GoogleFonts.monomaniacOne(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Campo nombre de usuario
                  _buildModalTextField(usernameController, 'Nombre de usuario'),
                  const SizedBox(height: 15),
                  
                  // Campo biografía
                  _buildModalTextField(bioController, 'Biografía', maxLines: 3),
                  const SizedBox(height: 15),
                  
                  // Sección de géneros favoritos
                  Text(
                    'Géneros Favoritos:',
                    style: GoogleFonts.monomaniacOne(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Lista de géneros disponibles
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        'ROMANCE', 'SCI-FI', 'AUTO AYUDA', 'HORROR', 'POLITICA', 'FAN FIC',
                        'AVENTURA', 'MISTERIO', 'DRAMA', 'COMEDIA', 'FANTASÍA', 'THRILLER'
                      ].map((genre) {
                        final isSelected = editableGenres.contains(genre);
                        return CheckboxListTile(
                          title: Text(
                            '#$genre',
                            style: GoogleFonts.monomaniacOne(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (isSelected) {
                                editableGenres.remove(genre);
                              } else {
                                editableGenres.add(genre);
                              }
                            });
                          },
                          checkColor: AppColors.textDark,
                          activeColor: AppColors.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Botón guardar cambios
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        // Simular actualización en backend
                        await Future.delayed(const Duration(milliseconds: 500));
                        
                        // Actualizar datos localmente
                        setState(() {
                          _username = usernameController.text;
                          _bio = bioController.text;
                          _favoriteGenres = editableGenres;
                        });
                        
                        Navigator.pop(modalContext);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perfil actualizado exitosamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al actualizar: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Guardar Cambios',
                      style: GoogleFonts.monomaniacOne(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Botón cancelar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(modalContext);
                    },
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.monomaniacOne(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModalTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.monomaniacOne(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceTransparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
      ),
    );
  }

  void _handleFollowButtonTap() {
    if (!_isFollowed) {
      setState(() {
        _showFollowOptions = !_showFollowOptions;
      });
    } else {
      _toggleFollow('unfollow');
    }
  }

  void _handleFollowOption(String option) {
    setState(() {
      _showFollowOptions = false;
    });
    _toggleFollow(option);
  }

  void _showChangeBannerImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Cambiar imagen de portada',
            style: GoogleFonts.monomaniacOne(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(
                  'Tomar foto',
                  style: GoogleFonts.monomaniacOne(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateBannerImage('camera');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(
                  'Elegir de galería',
                  style: GoogleFonts.monomaniacOne(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateBannerImage('gallery');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangeProfileImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Cambiar foto de perfil',
            style: GoogleFonts.monomaniacOne(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text(
                  'Tomar foto',
                  style: GoogleFonts.monomaniacOne(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateProfileImage('camera');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text(
                  'Elegir de galería',
                  style: GoogleFonts.monomaniacOne(color: AppColors.textPrimary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateProfileImage('gallery');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateBannerImage(String source) async {
    try {
      // Simular actualización de imagen
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _bannerImageUrl = 'https://placehold.co/411x163?text=Nueva+Portada';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen de portada actualizada desde $source'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProfileImage(String source) async {
    try {
      // Simular actualización de imagen
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _profileImageUrl = 'https://placehold.co/150x150?text=Nuevo+Perfil';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto de perfil actualizada desde $source'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildScrollableGenreGrid() {
    // Crear grupos de géneros para las 2 filas
    final List<List<String>> genreRows = [];
    
    // Dividir géneros en grupos de 3 para cada fila
    for (int i = 0; i < _favoriteGenres.length; i += 6) {
      // Primera fila (índices 0, 1, 2)
      List<String> firstRow = [];
      if (i < _favoriteGenres.length) firstRow.add(_favoriteGenres[i]);
      if (i + 1 < _favoriteGenres.length) firstRow.add(_favoriteGenres[i + 1]);
      if (i + 2 < _favoriteGenres.length) firstRow.add(_favoriteGenres[i + 2]);
      
      // Segunda fila (índices 3, 4, 5)
      List<String> secondRow = [];
      if (i + 3 < _favoriteGenres.length) secondRow.add(_favoriteGenres[i + 3]);
      if (i + 4 < _favoriteGenres.length) secondRow.add(_favoriteGenres[i + 4]);
      if (i + 5 < _favoriteGenres.length) secondRow.add(_favoriteGenres[i + 5]);
      
      if (firstRow.isNotEmpty || secondRow.isNotEmpty) {
        genreRows.add([...firstRow, ...secondRow]);
      }
    }
    
    // Crear las columnas scrolleables
    return Row(
      children: genreRows.map((columnGenres) {
        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              // Primera fila
              Row(
                children: [
                  if (columnGenres.isNotEmpty) 
                    _buildScrollableGenreChip(columnGenres[0], width: 117),
                  if (columnGenres.length > 1) ...[
                    const SizedBox(width: 5),
                    _buildScrollableGenreChip(columnGenres[1], width: 77),
                  ],
                  if (columnGenres.length > 2) ...[
                    const SizedBox(width: 5),
                    _buildScrollableGenreChip(columnGenres[2], width: 127),
                  ],
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Segunda fila
              Row(
                children: [
                  if (columnGenres.length > 3) 
                    _buildScrollableGenreChip(columnGenres[3], width: 106),
                  if (columnGenres.length > 4) ...[
                    const SizedBox(width: 5),
                    _buildScrollableGenreChip(columnGenres[4], width: 117),
                  ],
                  if (columnGenres.length > 5) ...[
                    const SizedBox(width: 5),
                    _buildScrollableGenreChip(columnGenres[5], width: 99),
                  ],
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScrollableGenreChip(String genre, {required double width}) {
    return Container(
      width: width,
      height: 35,
      decoration: BoxDecoration(
        color: AppColors.withOpacity(AppColors.surfaceLight, 0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '#$genre',
          textAlign: TextAlign.center,
          style: GoogleFonts.monomaniacOne(
            color: AppColors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowOption(String option) {
    IconData icon;
    switch (option) {
      case 'Todas':
        icon = Icons.notifications_active;
        break;
      case 'Personalizadas':
        icon = Icons.notifications;
        break;
      case 'Ninguna':
        icon = Icons.notifications_off;
        break;
      default:
        icon = Icons.circle;
    }

    return Container(
      width: double.infinity,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleFollowOption(option),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  option,
                  style: GoogleFonts.monomaniacOne(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Contenido principal
          SingleChildScrollView(
            child: Column(
              children: [
                // Banner del perfil con ícono de cámara - Posición exacta
                Container(
                  width: double.infinity,
                  height: 163,
                  child: Stack(
                    children: [
                      // Banner de fondo
                        // Fondo blanco detrás del banner
                        Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 163,
                          color: Colors.white,
                        ),
                        ),
                        // Banner de imagen encima del fondo blanco
                        Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                          height: 163,
                          decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_bannerImageUrl),
                            fit: BoxFit.cover,
                          ),
                          ),
                        ),
                        ),
                      
                      // Ícono de cámara - Posición exacta (solo en perfil propio)
                      if (_isOwnProfile)
                        Positioned(
                          left: 352,
                          top: 115,
                          child: GestureDetector(
                            onTap: _showChangeBannerImageDialog,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceTransparent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Sección principal del perfil
                Transform.translate(
                  offset: const Offset(0, -111),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Foto de perfil con ícono de cámara - Posición exacta
                        Container(
                          width: 156,
                          height: 150,
                          child: Stack(
                            children: [
                              // Contenedor amarillo de fondo
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowColor,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Imagen de perfil centrada
                              Positioned(
                                left: 25,
                                top: 25,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: _profileImageUrl.isNotEmpty
                                      ? Image.network(
                                          _profileImageUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.transparent,
                                              child: Icon(
                                                Icons.person,
                                                size: 60,
                                                color: AppColors.textDark,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.transparent,
                                          child: Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                ),
                              ),
                              
                              // Ícono de cámara - Posición exacta (solo en perfil propio)
                              if (_isOwnProfile)
                                Positioned(
                                  left: 116,
                                  top: 110,
                                  child: GestureDetector(
                                    onTap: _showChangeProfileImageDialog,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceTransparent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.shadowColor,
                                            blurRadius: 4,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 20.8,
                                          height: 20.8,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: AppColors.textPrimary,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Información del usuario
                        Row(
                          children: [
                            Text(
                              _username,
                              style: GoogleFonts.monomaniacOne(
                                color: AppColors.textPrimary,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Badge del código de amigo con ícono
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceTransparent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowColor,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    color: AppColors.textPrimary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _friendCode,
                                  style: GoogleFonts.monomaniacOne(
                                    color: AppColors.primary,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Estadísticas de amigos y seguidores
                        Row(
                          children: [
                            Text(
                              'Amigos $_friendsCount',
                              style: GoogleFonts.monomaniacOne(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              'Seguidores $_followersCount',
                              style: GoogleFonts.monomaniacOne(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Biografía
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            _bio,
                            style: GoogleFonts.cantarell(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Botón principal (Editar Perfil o Seguir)
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 35,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: _isOwnProfile ? _showEditProfileModal : _handleFollowButtonTap,
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_isOwnProfile) ...[
                                          Icon(
                                            Icons.edit,
                                            color: AppColors.textDark,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        Text(
                                          _isOwnProfile 
                                              ? 'Editar Perfil' 
                                              : (_isFollowed ? 'Siguiendo' : 'Seguir'),
                                          style: GoogleFonts.monomaniacOne(
                                            color: AppColors.textDark,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Menú desplegable de opciones de seguimiento
                            if (!_isOwnProfile && _showFollowOptions)
                              Positioned(
                                top: 45,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceTransparent,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowColor,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      _buildFollowOption('Todas'),
                                      _buildFollowOption('Personalizadas'),
                                      _buildFollowOption('Ninguna'),
                                      Container(
                                        width: double.infinity,
                                        height: 40,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _showFollowOptions = false;
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                'Anular suscripción',
                                                style: GoogleFonts.monomaniacOne(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Sección de géneros favoritos - Scrolleable horizontal con altura fija
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header de géneros preferidos
                              Container(
                                width: 200,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceTransparent,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowColor,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Géneros Preferidos',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // Contenedor principal de géneros - Scrolleable horizontal
                              Container(
                                width: double.infinity,
                                height: 106, // Altura ajustada para solo 2 filas
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceTransparent,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowColor,
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(15),
                                  child: _buildScrollableGenreGrid(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 100), // Espacio para NavigationBar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          // NavigationBar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavigationBar(
              currentRoute: '/Profile'
            ),
          ),
        ],
      ),
    );
  }
}