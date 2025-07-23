// lib/features/book/presentation/book_detail_view.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../../core/services/download_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/image_utils.dart';
import '../../book/domain/entities/book_detail_entity.dart';
import '../../writenBook/domain/usecases/books_usecases.dart' show GetAllGenresUseCase;
import '../../writenBook/domain/entities/genre_entity.dart' as writen_book_entity;
import 'cubit/book_detail_cubit.dart';
import 'cubit/book_detail_state.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../components/searchUserBar/searchUserBar.dart';
import 'package:go_router/go_router.dart';
import 'cubit/book_likes_cubit.dart';
import 'package:get_it/get_it.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController chapterTitleController = TextEditingController();
  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editDescriptionController =
      TextEditingController();
  final TextEditingController newGenreController = TextEditingController();
  bool _isBookDownloaded = false;

  late final BookDetailCubit _cubit;
  
  // Caso de uso para obtener géneros (similar al de writenBook)
  late final GetAllGenresUseCase _getAllGenresUseCase;
  BookLikesCubit? _likesCubit;
  String? _userId;

  Map<String, bool> _downloadedChapters = {};

  @override
  void initState() {
    super.initState();
    
    // Obtener instancias desde GetIt
    _getAllGenresUseCase = GetIt.I<GetAllGenresUseCase>();
    _cubit = GetIt.I<BookDetailCubit>();
    _cubit.loadBookDetail(widget.bookId);
    StorageServiceImpl().getUserId().then((id) {
      setState(() {
        _userId = id;
        _likesCubit = GetIt.I<BookLikesCubit>();
      });
    });
    // Verificar si el libro ya está descargado
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isDownloaded = await DownloadService().isBookDownloaded(widget.bookId);
      if (mounted) {
        setState(() {
          _isBookDownloaded = isDownloaded;
        });
      }
    });
    // Verificar capítulos descargados
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_cubit.state is BookDetailLoaded) {
        final book = (_cubit.state as BookDetailLoaded).bookDetail;
        if (book.chapters != null) {
          final Map<String, bool> chapterStates = {};
          for (final chapter in book.chapters!) {
            final isDownloaded = await DownloadService().isChapterDownloaded(chapter.id);
            chapterStates[chapter.id] = isDownloaded;
          }
          if (mounted) {
            setState(() {
              _downloadedChapters = chapterStates;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    chapterTitleController.dispose();
    editTitleController.dispose();
    editDescriptionController.dispose();
    newGenreController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _showAddChapterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar capítulo'),
          content: TextField(
            controller: chapterTitleController,
            decoration: const InputDecoration(hintText: 'Título del capítulo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                chapterTitleController.clear();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = chapterTitleController.text.trim();
                if (title.isNotEmpty) {
                  _cubit.addChapter(title);
                  Navigator.of(context).pop();
                  chapterTitleController.clear();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBookModal(BookDetailEntity book) {
    // Inicializar controladores con datos actuales
    editTitleController.text = book.title;
    editDescriptionController.text = book.description;

    // Variables locales para el modal
    List<writen_book_entity.GenreEntity> modalGenres = [];
    List<int> modalSelectedGenres = [];
    List<String> modalNewGenres = [];
    bool isLoadingGenres = false;
    bool isUpdatingBook = false;
    bool isProcessingImage = false;
    String? errorMessage;
    String? selectedImageBase64 = book.coverImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (modalContext) => StatefulBuilder(
            builder: (builderContext, setState) {
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
                        'Editar Historia',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Sección de imagen de portada
                      Text(
                        'Portada del libro:',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Contenedor de imagen
                      GestureDetector(
                        onTap:
                            isProcessingImage
                                ? null
                                : () async {
                                  try {
                                    final ImagePicker picker = ImagePicker();

                                    final source =
                                        await showDialog<ImageSource>(
                                          context: context,
                                          builder: (
                                            BuildContext dialogContext,
                                          ) {
                                            return AlertDialog(
                                              backgroundColor: const Color(
                                                0xFF2A2A2A,
                                              ),
                                              title: const Text(
                                                'Seleccionar imagen',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.photo_library,
                                                      color: Color(0xFFECEC3D),
                                                    ),
                                                    title: const Text(
                                                      'Galería',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onTap:
                                                        () => Navigator.pop(
                                                          dialogContext,
                                                          ImageSource.gallery,
                                                        ),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.camera_alt,
                                                      color: Color(0xFFECEC3D),
                                                    ),
                                                    title: const Text(
                                                      'Cámara',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onTap:
                                                        () => Navigator.pop(
                                                          dialogContext,
                                                          ImageSource.camera,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        dialogContext,
                                                      ),
                                                  child: const Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                    if (source != null) {
                                      setState(() {
                                        isProcessingImage = true;
                                        errorMessage = null;
                                      });

                                      final XFile? image = await picker
                                          .pickImage(
                                            source: source,
                                            imageQuality: 85,
                                            maxWidth: 800,
                                            maxHeight: 600,
                                          );

                                      if (image != null) {
                                        final imageFile = File(image.path);
                                        final base64Image =
                                            await ImageUtils.fileToBase64(
                                              imageFile,
                                            );

                                        if (base64Image != null) {
                                          setState(() {
                                            selectedImageBase64 = base64Image;
                                            isProcessingImage = false;
                                          });
                                        } else {
                                          setState(() {
                                            isProcessingImage = false;
                                            errorMessage =
                                                'Error al procesar la imagen';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          isProcessingImage = false;
                                        });
                                      }
                                    }
                                  } catch (e) {
                                    setState(() {
                                      isProcessingImage = false;
                                      errorMessage = 'Error: ${e.toString()}';
                                    });
                                  }
                                },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0x35606060),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFFECEC3D),
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (selectedImageBase64 != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ImageUtils.buildImageWidget(
                                    base64Image: selectedImageBase64,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isProcessingImage
                                            ? Icons.hourglass_empty
                                            : Icons.add_photo_alternate,
                                        color: const Color(0xFFECEC3D),
                                        size: 50,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        isProcessingImage
                                            ? 'Procesando imagen...'
                                            : 'Tocar para cambiar portada',
                                        style: GoogleFonts.monomaniacOne(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),

                              if (selectedImageBase64 != null)
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImageBase64 = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Campo título
                      _buildTextField(editTitleController, 'Título del libro'),
                      const SizedBox(height: 15),

                      // Campo descripción
                      _buildTextField(
                        editDescriptionController,
                        'Descripción',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),

                      // Sección de géneros
                      Text(
                        'Géneros:',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Botón para cargar géneros
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D165C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            isLoadingGenres
                                ? null
                                : () async {
                                  setState(() {
                                    isLoadingGenres = true;
                                    errorMessage = null;
                                  });

                                  try {
                                    // Cargar todos los géneros disponibles
                                    final allGenres = await _getAllGenresUseCase.call();
                                    
                                    setState(() {
                                      modalGenres = allGenres;
                                      // Marcar como seleccionados los géneros actuales del libro
                                      modalSelectedGenres = book.genres
                                          ?.map((g) => int.tryParse(g.id) ?? 0)
                                          .toList() ?? [];
                                      isLoadingGenres = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoadingGenres = false;
                                      errorMessage = e.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      );
                                    });
                                  }
                                },
                        child:
                            isLoadingGenres
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Cargar Géneros',
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),

                      const SizedBox(height: 15),

                      // Mostrar error si existe
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Error: $errorMessage',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Lista de géneros
                      if (modalGenres.isNotEmpty) ...[
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: modalGenres.length,
                            itemBuilder: (context, index) {
                              final genre = modalGenres[index];
                              final genreId = genre.id ?? 0;
                              final isSelected = modalSelectedGenres.contains(
                                genreId,
                              );

                              return CheckboxListTile(
                                title: Text(
                                  genre.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (isSelected) {
                                      modalSelectedGenres.remove(genreId);
                                    } else {
                                      modalSelectedGenres.add(genreId);
                                    }
                                  });
                                },
                                checkColor: Colors.black,
                                activeColor: const Color(0xFFECEC3D),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Crear nuevo género
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                newGenreController,
                                'Nuevo género',
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3D165C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (newGenreController.text.isNotEmpty) {
                                  setState(() {
                                    modalNewGenres.add(
                                      newGenreController.text.trim(),
                                    );
                                    newGenreController.clear();
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Género "${modalNewGenres.last}" agregado',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Añadir',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        // Mostrar géneros nuevos agregados
                        if (modalNewGenres.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Géneros nuevos:',
                            style: GoogleFonts.monomaniacOne(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 8,
                            children:
                                modalNewGenres
                                    .map(
                                      (genre) => Chip(
                                        label: Text(genre),
                                        backgroundColor: const Color(
                                          0xFFECEC3D,
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 18,
                                        ),
                                        onDeleted: () {
                                          setState(() {
                                            modalNewGenres.remove(genre);
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ],
                      ] else if (!isLoadingGenres) ...[
                        const Text(
                          'Presiona "Cargar Géneros" para ver las opciones',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],

                      const SizedBox(height: 25),

                      // Botón actualizar libro
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isUpdatingBook
                                  ? Colors.grey
                                  : const Color(0xFFECEC3D),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed:
                            isUpdatingBook
                                ? null
                                : () async {
                                  if (editTitleController.text.isEmpty ||
                                      editDescriptionController.text.isEmpty ||
                                      (modalSelectedGenres.isEmpty &&
                                          modalNewGenres.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Complete todos los campos y seleccione al menos un género',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    isUpdatingBook = true;
                                  });

                                  try {
                                    final updates = <String, dynamic>{
                                      'title': editTitleController.text.trim(),
                                      'description':
                                          editDescriptionController.text.trim(),
                                      'genreIds': modalSelectedGenres,
                                      if (modalNewGenres.isNotEmpty)
                                        'newGenres': modalNewGenres,
                                      if (selectedImageBase64 != null)
                                        'coverImage': selectedImageBase64,
                                    };

                                    _cubit.updateBook(updates);

                                    Navigator.pop(modalContext);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Libro actualizado exitosamente',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() {
                                      isUpdatingBook = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error: ${e.toString().replaceFirst('Exception: ', '')}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                        child:
                            isUpdatingBook
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                                : Text(
                                  'Actualizar Historia',
                                  style: GoogleFonts.monomaniacOne(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                      ),

                      const SizedBox(height: 10),

                      // Botón cerrar
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
                            color: Colors.white,
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

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.monomaniacOne(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0x35606060),
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

@override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        if (_likesCubit != null) BlocProvider.value(value: _likesCubit!),
      ],
      child: BlocConsumer<BookDetailCubit, BookDetailState>(
        listener: (context, state) {
          if (state is BookDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ChapterAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Capítulo agregado'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is CommentAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Comentario publicado'),
                backgroundColor: Colors.green,
              ),
            );
            commentController.clear();
          }
          if (state is BookUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Libro actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is BookPublished) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.published ? 'Libro publicado' : 'Libro despublicado',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is BookDeleted) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is BookDetailLoading || state is BookDetailInitial) {
            return const Scaffold(
              backgroundColor: AppColors.background,
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is BookDetailLoaded) {
            final book = state.bookDetail;
            final isAuthor = state.isAuthor;
            // Cargar likes solo si no es autor y cubit está listo
            if (!isAuthor && _userId != null && _likesCubit != null) {
              final chapterIds = (book.chapters ?? []).map((c) => int.tryParse(c.id) ?? 0).toList();
              _likesCubit!.loadLikes(_userId!, book.id, chapterIds);
            }
            return BlocBuilder<BookLikesCubit, BookLikesState>(
              builder: (context, likesState) {
                return Scaffold(
                  backgroundColor: AppColors.background,
                  body: Stack(
                    children: [
                      // Círculos decorativos de fondo
                      Positioned(
                        left: -13,
                        top: 676,
                        child: Container(
                          width: 257,
                          height: 260,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 231,
                        top: -80,
                        child: Container(
                          width: 257,
                          height: 260,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Contenido principal
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 120),
                            // Título
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                              child: Text(
                                book.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.monomaniacOne(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Imagen
                            Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: SizedBox(
                                      width: 150,
                                      height: 200,
                                      child: (book.coverImage != null && book.coverImage!.isNotEmpty)
                                          ? Image.memory(
                                              base64Decode(book.coverImage!),
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 200,
                                            )
                                          : const Icon(Icons.book, size: 50),
                                    ),
                                  ),
                                  // Seguidores (solo para lectores)
                                  if (!isAuthor && _userId != null)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(bottom: 8),
                                      alignment: Alignment.bottomCenter,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.white70,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              '${likesState.bookLikesCount} likes',
                                              style: GoogleFonts.monomaniacOne(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Descripción
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                book.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.monomaniacOne(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Géneros
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 20,
                              ),
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
                              child: Column(
                                children: [
                                  Text(
                                    'Géneros:',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 5,
                                    children:
                                        (book.genres ?? [])
                                            .map(
                                              (genre) => Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                  genre.name,
                                                  style: GoogleFonts.monomaniacOne(
                                                    color: AppColors.textDark,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            // Botones de acción (seguir y descargar)
                            if (!isAuthor && _userId != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Botón seguir libro (solo ícono)
                                  IconButton(
                                    icon: Icon(
                                      likesState.isBookLiked ? Icons.favorite : Icons.favorite_border,
                                      color: likesState.isBookLiked ? Colors.red : Colors.grey,
                                      size: 32,
                                    ),
                                    tooltip: likesState.isBookLiked ? 'Dejar de seguir' : 'Seguir libro',
                                    onPressed: likesState.loading ? null : () {
                                      _likesCubit!.toggleBook(_userId!, book.id);
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  // Botón descargar
                                  IconButton(
                                    icon: Icon(
                                      Icons.download,
                                      color: _isBookDownloaded ? Colors.blue : Colors.grey,
                                      size: 40,
                                    ),
                                    tooltip: _isBookDownloaded ? 'Eliminar descarga' : 'Descargar libro',
                                    onPressed: () async {
                                      if (_isBookDownloaded) {
                                        // Borrar libro de la base local
                                        await DownloadService().deleteBook(book.id);
                                        if (mounted) {
                                          setState(() {
                                            _isBookDownloaded = false;
                                          });
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Libro eliminado de descargas'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      } else {
                                        try {
                                          await DownloadService().saveBook(book);
                                          if (mounted) {
                                            setState(() {
                                              _isBookDownloaded = true;
                                            });
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Libro descargado correctamente'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error al descargar:  [${e.toString()}]'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            
                            const SizedBox(height: 20),
                            
                            // Autor - Adaptable al contenido
                            GestureDetector(
                              onTap: () {
                                if (book.authorId.isNotEmpty) {
                                  GoRouter.of(context).push(
                                    '/profile',
                                    extra: {'userId': book.authorId},
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 20,
                                ),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Por: ${book.author?.username ?? 'Autor Desconocido'}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.monomaniacOne(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.person,
                                      color: AppColors.textPrimary,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Botones de autor
                            if (isAuthor) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => _showEditBookModal(book),
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Editar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.textDark,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed:
                                        () => _cubit.publishBook(
                                          !(book.published ?? false),
                                        ),
                                    icon: Icon(
                                      book.published == true
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    label: Text(
                                      book.published == true
                                          ? 'Despublicar'
                                          : 'Publicar',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          book.published == true
                                              ? Colors.orange
                                              : Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Capítulos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'Capítulos',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                if (isAuthor)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: _showAddChapterDialog,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Agregar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                              ],
                            ),


                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: book.chapters?.length ?? 0,
                              itemBuilder: (context, index) {
                                final chapter = book.chapters![index];
                                final chapterId = chapter.id;
                                final isDownloaded = _downloadedChapters[chapterId] ?? false;
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    title: Text(chapter.title),
                                    subtitle:
                                        isAuthor && chapter.published != null
                                            ? Text(
                                              chapter.published!
                                                  ? 'Publicado'
                                                  : 'No publicado',
                                            )
                                            : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isAuthor && chapter.published != null) ...[
                                          IconButton(
                                            icon: Icon(
                                              chapter.published == true ? Icons.visibility : Icons.visibility_off,
                                              color: chapter.published == true ? Colors.green : Colors.grey,
                                            ),
                                            tooltip: chapter.published == true ? 'Despublicar' : 'Publicar',
                                            onPressed: () => _cubit.toggleChapterPublish(
                                              chapter.id,
                                              !(chapter.published ?? false),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Eliminar capítulo',
                                            onPressed: () => _cubit.deleteChapter(chapter.id),
                                          ),
                                        ]
                                        else if (!isAuthor && _userId != null) ...[
                                          IconButton(
                                            icon: Icon(
                                              (likesState.chaptersLikeStatus[int.parse(chapter.id)]?['isLiked'] ?? false)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: (likesState.chaptersLikeStatus[int.parse(chapter.id)]?['isLiked'] ?? false)
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: likesState.loading ? null : () {
                                              _likesCubit!.toggleChapter(_userId!, int.parse(chapter.id));
                                            },
                                          ),
                                          Text(
                                            '${likesState.chaptersLikeStatus[int.parse(chapter.id)]?['likesCount'] ?? 0}',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                        // Botón de descarga de capítulo (siempre visible)
                                        IconButton(
                                          icon: Icon(
                                            Icons.download,
                                            color: isDownloaded ? Colors.blue : Colors.grey,
                                          ),
                                          tooltip: isDownloaded ? 'Eliminar descarga' : 'Descargar capítulo',
                                          onPressed: () async {
                                            if (isDownloaded) {
                                              await DownloadService().deleteChapter(chapterId);
                                              setState(() {
                                                _downloadedChapters[chapterId] = false;
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Capítulo eliminado de descargas'),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            } else {
                                              try {
                                                await DownloadService().saveChapterById(book.id, chapterId);
                                                setState(() {
                                                  _downloadedChapters[chapterId] = true;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Capítulo descargado correctamente'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error al descargar capítulo: [${e.toString()}]'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      GoRouter.of(context).push(
                                        '/chapterReader',
                                        extra: {
                                          'chapterId': chapter.id,
                                          'bookTitle': book.title,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            if (isAuthor)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () => _cubit.deleteBook(),
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Eliminar libro'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 30),
                            // Comentarios
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  const Icon(
                                    Icons.comment,
                                    color: AppColors.textPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Comentarios (${book.comments?.length ?? 0})',
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Campo para nuevo comentario
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.all(18),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: commentController,
                                      maxLines: 2,
                                      style: GoogleFonts.monomaniacOne(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Escribe tu comentario...',
                                        hintStyle: GoogleFonts.monomaniacOne(
                                          color: AppColors.textSecondary,
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.withOpacity(
                                          AppColors.surfaceTransparent,
                                          0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {
                                      final text = commentController.text.trim();
                                      if (text.isNotEmpty) {
                                        _cubit.addComment(text);
                                      }
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.shadowColor,
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.send,
                                        color: AppColors.textDark,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Lista de comentarios
                            ...(book.comments ?? []).map(
                              (comment) => Container(
                                margin: const EdgeInsets.only(
                                  bottom: 18,
                                  left: 15,
                                  right: 15,
                                ),
                                padding: const EdgeInsets.all(18),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.primary,
                                          child: Text(
                                            (comment.user?.username ?? 'U')[0]
                                                .toUpperCase(),
                                            style: GoogleFonts.monomaniacOne(
                                              color: AppColors.textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            comment.user?.username ?? 'Usuario',
                                            style: GoogleFonts.monomaniacOne(
                                              color: AppColors.textPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        // Aquí podrías formatear la fecha si lo deseas
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      comment.comment,
                                      style: GoogleFonts.monomaniacOne(
                                        color: AppColors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                      // TopBar
                      const CustomTopBar(),
                      // NavigationBar
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CustomNavigationBar(currentRoute: '/BookDetail'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Error cargando el libro')),
          );
        },
      ),
    );
  }
}