import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';
import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileModal extends StatefulWidget {
  final ProfileLoaded profileState;

  const EditProfileModal({
    super.key,
    required this.profileState,
  });

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late List<dynamic> _editableGenres;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profileState.username);
    _bioController = TextEditingController(text: widget.profileState.bio);
    // Inicialmente solo los ids de los favoritos
    final favoriteIds = widget.profileState.favoriteGenres.map((g) => g is GenreEntity ? g.id : (g.id ?? '')).toSet();
    // Si ya hay géneros cargados, usa las instancias de allGenres para _editableGenres
    if (widget.profileState.allGenres.isNotEmpty) {
      _editableGenres = widget.profileState.allGenres.where((g) => favoriteIds.contains(g.id)).toList();
    } else {
      _editableGenres = List.from(widget.profileState.favoriteGenres);
    }
    if (widget.profileState.allGenres.isEmpty) {
      context.read<ProfileCubit>().loadAllGenres();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileUpdateSuccess) {
          final cubit = context.read<ProfileCubit>();
          await cubit.loadProfile(widget.profileState.profileUserId);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final currentState = state is ProfileLoaded ? state : widget.profileState;
        final isLoading = state is ProfileUpdateLoading;
        final allGenres = currentState.allGenres;
        // Solo se marca el check si el género está en los favoritos actuales (_editableGenres)

        return Container(
          color: AppColors.background,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
                _buildModalTextField(_usernameController, 'Nombre de usuario'),
                const SizedBox(height: 15),
                _buildModalTextField(_bioController, 'Biografía', maxLines: 3),
                const SizedBox(height: 15),
                Text(
                  'Géneros Favoritos:',
                  style: GoogleFonts.monomaniacOne(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: allGenres.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          shrinkWrap: true,
                          children: allGenres.map<Widget>((genre) {
                            final genreId = genre.id.toString();
                            final isSelected = _editableGenres.any((g) {
                              final gId = (g is GenreEntity ? g.id : (g.id ?? '')).toString();
                              return gId == genreId;
                            });
                            return CheckboxListTile(
                              title: Text(
                                '#${genre.name}',
                                style: GoogleFonts.monomaniacOne(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              value: isSelected,
                              onChanged: isLoading
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        if (isSelected) {
                                          _editableGenres.removeWhere((g) => (g is GenreEntity ? g.id : (g.id ?? '')) == genre.id);
                                        } else {
                                          _editableGenres.add(genre);
                                        }
                                      });
                                    },
                              checkColor: Colors.white,
                              activeColor: Colors.amber,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: isLoading ? null : () async {
                    final username = _usernameController.text.trim();
                    final bio = _bioController.text.trim();
                    if (username.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre de usuario no puede estar vacío'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    final genresToSave = _editableGenres.map((g) {
                      if (g is GenreEntity) {
                        return Genre(id: g.id.toString(), name: g.name);
                      } else {
                        return g;
                      }
                    }).toList();
                    context.read<ProfileCubit>().updateProfile(
                      username: username,
                      bio: bio,
                      favoriteGenres: genresToSave,
                    );
                  },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Guardar Cambios',
                          style: GoogleFonts.monomaniacOne(
                            color: AppColors.textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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
        ),
        );
      },
    );
  }

  Widget _buildModalTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.monomaniacOne(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }


  void _saveProfile() {
    final username = _usernameController.text.trim();
    final bio = _bioController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de usuario no puede estar vacío'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      username: username,
      bio: bio,
      favoriteGenres: _editableGenres,
    );
  }
}