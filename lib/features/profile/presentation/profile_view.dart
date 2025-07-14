import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/bookImage/bookImage.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';
import 'package:flutter_application_1/features/profile/domain/usecases/profile_usecases.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/dependency_injection.dart' as di;
import '../../components/navigationBar/navigationBar.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; 

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
  final GetProfileUseCase _getProfileUseCase = di.sl<GetProfileUseCase>();
  
  bool _isLoading = true;
  bool _isOwnProfile = false;
  bool _isFollowed = false;
  bool _showFollowOptions = false;
  
  String _currentUserId = '';
  String _profileUserId = '';
  String _username = '';
  String _friendCode = '';
  String _bio = '';
  String _profileImageUrl = '';
  String _bannerImageUrl = '';
  int _friendsCount = 0;
  int _followersCount = 0;
  List<Genre> _favoriteGenres = [];
  List<OwnBook> _ownBooks = [];
  List<Book> _favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData().then((_) {
      print("username después de cargar: ${_username}");
    });
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

    final userData = await _storageService.getUserData();
    _currentUserId = userData['userId'] ?? '';
    
    _profileUserId = widget.userId ?? _currentUserId;
    _isOwnProfile = _profileUserId == _currentUserId;
    
    if (_isOwnProfile) {
      final logUserProfile = await _getProfileUseCase.call(userData['userId']!);
      
      // Actualiza las variables de estado
      setState(() {
        _username = logUserProfile.username;
        _friendCode = logUserProfile.friendCode;
        _bio = logUserProfile.biography ?? '';
        _profileImageUrl = logUserProfile.profilePicture ?? 'https://placehold.co/150x150?text=Perfil+desconocido';
        _bannerImageUrl = logUserProfile.banner ?? 'https://placehold.co/411x163?text=Portada+desconocida';
        _friendsCount = logUserProfile.stats?.friendsCount ?? 0;
        _followersCount = logUserProfile.stats?.followersCount ?? 0;
        _favoriteGenres = logUserProfile.favoriteGenres;
        _ownBooks = logUserProfile.ownBooks;
        _favoriteBooks = logUserProfile.likedBooks;
      });
      
      print("Usuario loggeado: "
          "ID: ${logUserProfile.id}, "
          "Nombre: ${logUserProfile.username}, "
          "Biografía: ${logUserProfile.biography}, "
          "Imagen de perfil: ${logUserProfile.profilePicture}, "
          "Banner: ${logUserProfile.banner}, "
          "Géneros favoritos: ${logUserProfile.favoriteGenres}, "
          "Libros propios: ${logUserProfile.ownBooks}, "
          "Libros favoritos: ${logUserProfile.likedBooks}");
    } else {
      final profile = await _getProfileUseCase.call(_profileUserId);
      
      // Actualiza las variables de estado
      setState(() {
        _username = profile.username;
        _friendCode = profile.friendCode;
        _bio = profile.biography ?? '';
        _profileImageUrl = profile.profilePicture ?? 'https://placehold.co/150x150?text=Perfil+desconocido';
        _bannerImageUrl = profile.banner ?? 'https://placehold.co/411x163?text=Portada+desconocida';
        _friendsCount = profile.stats?.friendsCount ?? 0;
        _followersCount = profile.stats?.followersCount ?? 0;
        _favoriteGenres = profile.favoriteGenres;
      });
      
      print("Usuario visitado: "
          "ID: ${profile.id}, "
          "Nombre: ${profile.username}, "
          "Biografía: ${profile.biography}, "
          "Imagen de perfil: ${profile.profilePicture}, "
          "Banner: ${profile.banner}, "
          "Géneros favoritos: ${profile.favoriteGenres.map((g) => g.name).join(', ')}");
      
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
                          _favoriteGenres = editableGenres.cast<Genre>();
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
  // Crear grupos de géneros para las filas (3 por fila)
  final List<List<Genre>> genreRows = [];
  
  // Dividir géneros en grupos de 3
  for (int i = 0; i < _favoriteGenres.length; i += 3) {
    List<Genre> row = [];
    
    // Agregar hasta 3 géneros por fila
    for (int j = 0; j < 3 && (i + j) < _favoriteGenres.length; j++) {
      row.add(_favoriteGenres[i + j]);
    }
    
    if (row.isNotEmpty) {
      genreRows.add(row);
    }
  }
  
  // Crear las filas scrolleables
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Column(
      children: genreRows.map((rowGenres) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              // Primer género de la fila
              if (rowGenres.isNotEmpty) 
                _buildScrollableGenreChip(rowGenres[0]),
              
              // Segundo género de la fila
              if (rowGenres.length > 1) ...[
                const SizedBox(width: 5),
                _buildScrollableGenreChip(rowGenres[1]),
              ],
              
              // Tercer género de la fila
              if (rowGenres.length > 2) ...[
                const SizedBox(width: 5),
                _buildScrollableGenreChip(rowGenres[2]),
              ],
              
              // Espaciado al final de cada fila
              const SizedBox(width: 15),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildScrollableGenreChip(Genre genre) {
  return GestureDetector(
    onTap: () {
      print('Tapped on genre: ${genre.name} (ID: ${genre.id})');
    },
    child: Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12), 
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
          '#${genre.name}',
          textAlign: TextAlign.center,
          style: GoogleFonts.monomaniacOne(
            color: AppColors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w400,
          ),
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
                            image: Image.memory(base64Decode(_bannerImageUrl)).image,
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
                                      ? Image.memory(
                                          base64Decode(_profileImageUrl),
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
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    'Mis Libros',
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
                                height: _ownBooks.isEmpty ? 60 : _calculateContainerHeight(_ownBooks.length),
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
                                child: _ownBooks.isEmpty 
                                  ? Center(
                                      child: Text(
                                        'No has escrito libros',
                                        style: GoogleFonts.monomaniacOne(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.all(15),
                                      child: _buildOwnBooksGrid(_ownBooks),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
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
                                    'Libros Favoritos',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 10),
                              
                              Container(
                                width: double.infinity,
                                height: _favoriteBooks.isEmpty ? 60 : _calculateContainerHeight(_favoriteBooks.length),
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
                                child: _favoriteBooks.isEmpty 
                                  ? Center(
                                      child: Text(
                                        'No tienes libros favoritos',
                                        style: GoogleFonts.monomaniacOne(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.all(15),
                                      child: _buildLikedBooksGrid(_favoriteBooks),
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

  // Widget para crear la grilla de libros propios (2 por columna)
Widget _buildOwnBooksGrid(List<OwnBook> books) {
  // Dividir libros en grupos de 2 para crear columnas
  final List<List<OwnBook>> bookColumns = [];
  
  for (int i = 0; i < books.length; i += 2) {
    List<OwnBook> column = [];
    
    // Agregar hasta 2 libros por columna
    for (int j = 0; j < 2 && (i + j) < books.length; j++) {
      column.add(books[i + j]);
    }
    
    if (column.isNotEmpty) {
      bookColumns.add(column);
    }
  }
  
  // Crear las columnas scrolleables
  return Row(
    children: bookColumns.map((columnBooks) {
      return Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            // Primer libro de la columna
            if (columnBooks.isNotEmpty)
              BookImage(
                imageUrl: "https://placehold.co/150x200/4A90E2/FFFFFF?text=Libro+Propio",
                title: columnBooks[0].title,
                category: columnBooks[0].published ? "Publicado" : "Borrador",
                onTap: () {
                  print('Tapped on own book: ${columnBooks[0].title} (ID: ${columnBooks[0].id})');
                  // Aquí puedes navegar a la pantalla de edición del libro
                },
              ),
            
            // Espacio entre libros
            if (columnBooks.length > 1) const SizedBox(height: 10),
            
            // Segundo libro de la columna
            if (columnBooks.length > 1)
              BookImage(
                imageUrl: "https://placehold.co/150x200/4A90E2/FFFFFF?text=Libro+Propio",
                title: columnBooks[1].title,
                category: columnBooks[1].published ? "Publicado" : "Borrador",
                onTap: () {
                  print('Tapped on own book: ${columnBooks[1].title} (ID: ${columnBooks[1].id})');
                  // Aquí puedes navegar a la pantalla de edición del libro
                },
              ),
          ],
        ),
      );
    }).toList(),
  );
}

// Widget para crear la grilla de libros favoritos (2 por columna)
Widget _buildLikedBooksGrid(List<Book> books) {
  // Dividir libros en grupos de 2 para crear columnas
  final List<List<Book>> bookColumns = [];
  
  for (int i = 0; i < books.length; i += 2) {
    List<Book> column = [];
    
    // Agregar hasta 2 libros por columna
    for (int j = 0; j < 2 && (i + j) < books.length; j++) {
      column.add(books[i + j]);
    }
    
    if (column.isNotEmpty) {
      bookColumns.add(column);
    }
  }
  
  // Crear las columnas scrolleables
  return Row(
    children: bookColumns.map((columnBooks) {
      return Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            // Primer libro de la columna
            if (columnBooks.isNotEmpty)
              BookImage(
                imageUrl: "https://placehold.co/150x200/E24A4A/FFFFFF?text=Favorito",
                title: columnBooks[0].title,
                onTap: () {
                  print('Tapped on liked book: ${columnBooks[0].title} (ID: ${columnBooks[0].id})');
                  // Aquí puedes navegar a la pantalla de detalles del libro
                },
              ),
            
            // Espacio entre libros
            if (columnBooks.length > 1) const SizedBox(height: 10),
            
            // Segundo libro de la columna
            if (columnBooks.length > 1)
              BookImage(
                imageUrl: "https://placehold.co/150x200/E24A4A/FFFFFF?text=Favorito",
                title: columnBooks[1].title,
                onTap: () {
                  print('Tapped on liked book: ${columnBooks[1].title} (ID: ${columnBooks[1].id})');
                  // Aquí puedes navegar a la pantalla de detalles del libro
                },
              ),
          ],
        ),
      );
    }).toList(),
  );
}

// Función para calcular la altura del contenedor según el número de libros
double _calculateContainerHeight(int bookCount) {
  // Si hay 1 libro, altura para 1 libro + padding
  // Si hay 2 o más libros, altura para 2 libros + espacio entre ellos + padding
  if (bookCount == 1) {
    return 200 + 30; // Altura del libro + padding
  } else {
    return 200 + 10 + 200 + 30; // Dos libros + espacio + padding
  }
}

}

