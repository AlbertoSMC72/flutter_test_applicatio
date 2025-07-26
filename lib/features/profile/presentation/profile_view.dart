import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/bookImage/bookImage.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';
import 'package:flutter_application_1/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_application_1/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_application_1/features/profile/presentation/widgets/edit_profile_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../../features/writenBook/domain/entities/genre_entity.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile(widget.userId);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _updateBannerImage(String source) {
    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;
    if (state is ProfileLoaded) {
      cubit.updateBannerImage(state.profileUserId, source);
    }
  }

  void _updateProfileImage(String source) {
    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;
    if (state is ProfileLoaded) {
      cubit.updateProfileImage(state.profileUserId, source);
    }
  }

  void _showEditProfileModal() {
    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;
    if (state is ProfileLoaded) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (modalContext) => BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: EditProfileModal(profileState: state),
          ),
        ),
      );
    }
  }

  void _handleFollow(bool isFollowing) {
    print('[DEBUG] _handleFollow - isFollowing: $isFollowing');
    final cubit = context.read<ProfileCubit>();
    cubit.toggleFollow(isFollowing ? 'unfollow' : 'follow');
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

  Widget _buildScrollableGenreGrid(List<Genre> favoriteGenres) {
    final List<List<Genre>> genreRows = [];
    for (int i = 0; i < favoriteGenres.length; i += 3) {
      List<Genre> row = [];
      for (int j = 0; j < 3 && (i + j) < favoriteGenres.length; j++) {
        row.add(favoriteGenres[i + j]);
      }
      if (row.isNotEmpty) {
        genreRows.add(row);
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: genreRows.map((rowGenres) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                if (rowGenres.isNotEmpty)
                  _buildScrollableGenreChip(rowGenres[0]),
                if (rowGenres.length > 1) ...[
                  const SizedBox(width: 5),
                  _buildScrollableGenreChip(rowGenres[1]),
                ],
                if (rowGenres.length > 2) ...[
                  const SizedBox(width: 5),
                  _buildScrollableGenreChip(rowGenres[2]),
                ],
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
        debugPrint('Tapped on genre:  [38;5;2m${genre.name} [0m (ID: ${genre.id})');
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

  Widget _buildOwnBooksGrid(List ownBooks) {
    final List<List> bookColumns = [];
    for (int i = 0; i < ownBooks.length; i += 2) {
      List column = [];
      for (int j = 0; j < 2 && (i + j) < ownBooks.length; j++) {
        column.add(ownBooks[i + j]);
      }
      if (column.isNotEmpty) {
        bookColumns.add(column);
      }
    }
    return Row(
      children: bookColumns.map((columnBooks) {
        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              if (columnBooks.isNotEmpty)
                BookImage(
                  imageUrl: columnBooks[0].coverImage ?? "https://placehold.co/150x200/4A90E2/FFFFFF?text=Libro+Propio",
                  title: columnBooks[0].title,
                  category: columnBooks[0].published ? "Publicado" : "Borrador",
                  onTap: () {
                    debugPrint('Tapped on own book: ${columnBooks[0].title} (ID: ${columnBooks[0].id})');
                    context.push("/bookDetail", extra: {"bookId": columnBooks[0].id});
                  },
                ),
              if (columnBooks.length > 1) const SizedBox(height: 10),
              if (columnBooks.length > 1)
                BookImage(
                  imageUrl: columnBooks[1].coverImage ?? "https://placehold.co/150x200/4A90E2/FFFFFF?text=Libro+Propio",
                  title: columnBooks[1].title,
                  category: columnBooks[1].published ? "Publicado" : "Borrador",
                  onTap: () {
                    debugPrint('Tapped on own book: ${columnBooks[1].title} (ID: ${columnBooks[1].id})');
                    context.push("/bookDetail", extra: {"bookId": columnBooks[1].id});
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLikedBooksGrid(List books) {
    final List<List> bookColumns = [];
    for (int i = 0; i < books.length; i += 2) {
      List column = [];
      for (int j = 0; j < 2 && (i + j) < books.length; j++) {
        column.add(books[i + j]);
      }
      if (column.isNotEmpty) {
        bookColumns.add(column);
      }
    }
    return Row(
      children: bookColumns.map((columnBooks) {
        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              if (columnBooks.isNotEmpty)
                BookImage(
                  imageUrl: columnBooks[0].coverImage ?? "https://placehold.co/150x200/E24A4A/FFFFFF?text=Favorito",
                  title: columnBooks[0].title,
                  onTap: () {
                    debugPrint('Tapped on liked book: ${columnBooks[0].title} (ID: ${columnBooks[0].id})');
                    context.push("/bookDetail", extra: {"bookId": columnBooks[0].id});
                  },
                ),
              if (columnBooks.length > 1) const SizedBox(height: 10),
              if (columnBooks.length > 1)
                BookImage(
                  imageUrl: columnBooks[1].coverImage ?? "https://placehold.co/150x200/E24A4A/FFFFFF?text=Favorito",
                  title: columnBooks[1].title,
                  onTap: () {
                    debugPrint('Tapped on liked book: ${columnBooks[1].title} (ID: ${columnBooks[1].id})');
                    context.push("/bookDetail", extra: {"bookId": columnBooks[1].id});
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _calculateContainerHeight(int bookCount) {
    if (bookCount == 1) {
      return 200 + 30;
    } else {
      return 200 + 10 + 200 + 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is ProfileImageUpdated) {
          // Opcional: mostrar mensaje de éxito
        }
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }
        if (state is ProfileLoaded) {
          final profileImageUrl = state.profileImageUrl;
          final bannerImageUrl = state.bannerImageUrl;
          final isOwnProfile = state.isOwnProfile;
          final username = state.username;
          final friendCode = state.friendCode;
          final bio = state.bio;
          final friendsCount = state.friendsCount;
          final followersCount = state.followersCount;
          final showFollowOptions = state.showFollowOptions;
          final isFollowed = state.isFollowed;
          final favoriteGenres = state.favoriteGenres;
          final ownBooks = state.ownBooks;
          final favoriteBooks = state.favoriteBooks;

          debugPrint('[DEBUG_FOLLOW] '
          'profileImageUrl: $profileImageUrl, '
          'bannerImageUrl: $bannerImageUrl, '
          'isOwnProfile: $isOwnProfile, '
          'username: $username, '
          'friendCode: $friendCode, '
          'bio: $bio, '
          'friendsCount: $friendsCount, '
          'followersCount: $followersCount, '
          'showFollowOptions: $showFollowOptions, '
          'isFollowed: $isFollowed, '
          'favoriteGenres: ${favoriteGenres.map((g) => g.name).join(', ')}, '
          'ownBooks: ${ownBooks.length}, '
          'favoriteBooks: ${favoriteBooks.length}');


          return Scaffold(
            backgroundColor: AppColors.background,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Banner del perfil con ícono de cámara
                      Container(
                        width: double.infinity,
                        height: 163,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 163,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                                height: 163,
                                decoration: BoxDecoration(
                                  image: bannerImageUrl.isNotEmpty
                                      ? DecorationImage(
                                          image: Image.memory(base64Decode(bannerImageUrl)).image,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            if (isOwnProfile)
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
                      Transform.translate(
                        offset: const Offset(0, -111),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 156,
                                height: 150,
                                child: Stack(
                                  children: [
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
                                        child: profileImageUrl.isNotEmpty
                                            ? Image.memory(
                                                base64Decode(profileImageUrl),
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
                                    if (isOwnProfile)
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
                              Row(
                                children: [
                                  Text(
                                    username,
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                    friendCode,
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.primary,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Amigos $friendsCount',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    'Seguidores $followersCount',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  bio,
                                  style: GoogleFonts.cantarell(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
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
                                        onTap: isOwnProfile ? _showEditProfileModal : () => _handleFollow(isFollowed),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isOwnProfile) ...[
                                                Icon(
                                                  Icons.edit,
                                                  color: AppColors.textDark,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                              Text(
                                                isOwnProfile
                                                    ? 'Editar Perfil'
                                                    : (isFollowed ? 'Siguiendo' : 'Seguir'),
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
                                  if (!isOwnProfile && showFollowOptions)
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
                                      ),
                                    ),
                                ],
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
                                    Container(
                                      width: double.infinity,
                                      height: 106,
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
                                        child: _buildScrollableGenreGrid(favoriteGenres.cast<Genre>()),
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
                                          isOwnProfile ? 'Mis Libros' : 'Libros Publicados',
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
                                      height: ownBooks.isEmpty ? 60 : _calculateContainerHeight(ownBooks.length),
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
                                      child: ownBooks.isEmpty
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
                                              child: _buildOwnBooksGrid(ownBooks),
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
                                      height: favoriteBooks.isEmpty ? 60 : _calculateContainerHeight(favoriteBooks.length),
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
                                      child: favoriteBooks.isEmpty
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
                                              child: _buildLikedBooksGrid(favoriteBooks),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomNavigationBar(currentRoute: '/Profile'),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(
            child: Text('Error al cargar el perfil'),
          ),
        );
      },
    );
  }
}

