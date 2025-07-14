import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/components/bookInfo/bookInfoWriter.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_application_1/core/utils/image_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/books_cubit.dart';
import 'cubit/books_state.dart';

class UserStoriesScreen extends StatefulWidget {
  const UserStoriesScreen({Key? key}) : super(key: key);

  @override
  _UserStoriesScreenState createState() => _UserStoriesScreenState();
}

class _UserStoriesScreenState extends State<UserStoriesScreen> {
  // Controladores de texto para el modal de creación de libro
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newGenreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar libros del usuario al iniciar usando el nuevo método
    context.read<BooksCubit>().getUserWritingBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newGenreController.dispose();
    super.dispose();
  }

  void _showCreateBookModal() {
    final booksCubit = context.read<BooksCubit>();
    
    // Variables locales para el modal
    List<GenreEntity> modalGenres = [];
    List<int> modalSelectedGenres = [];
    List<String> modalNewGenres = [];
    bool isLoadingGenres = false;
    bool isCreatingBook = false;
    bool isProcessingImage = false;
    String? errorMessage;
    String? selectedImageBase64;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => StatefulBuilder(
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
                    'Crear Nueva Historia',
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
                    onTap: isProcessingImage ? null : () async {
                      try {
                        // Usar ImagePicker directamente para evitar problemas de contexto
                        final ImagePicker picker = ImagePicker();
                        
                        // Mostrar diálogo simple de selección
                        final source = await showDialog<ImageSource>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF2A2A2A),
                              title: const Text(
                                'Seleccionar imagen',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.photo_library, color: Color(0xFFECEC3D)),
                                    title: const Text(
                                      'Galería',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () => Navigator.pop(dialogContext, ImageSource.gallery),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt, color: Color(0xFFECEC3D)),
                                    title: const Text(
                                      'Cámara',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () => Navigator.pop(dialogContext, ImageSource.camera),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.grey),
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
                          
                          // Seleccionar imagen
                          final XFile? image = await picker.pickImage(
                            source: source,
                            imageQuality: 85,
                            maxWidth: 800,
                            maxHeight: 600,
                          );
                          
                          if (image != null) {
                            // Convertir a base64
                            final imageFile = File(image.path);
                            final base64Image = await ImageUtils.fileToBase64(imageFile);
                            
                            if (base64Image != null) {
                              setState(() {
                                selectedImageBase64 = base64Image;
                                isProcessingImage = false;
                              });
                            } else {
                              setState(() {
                                isProcessingImage = false;
                                errorMessage = 'Error al procesar la imagen';
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
                                    isProcessingImage ? Icons.hourglass_empty : Icons.add_photo_alternate,
                                    color: const Color(0xFFECEC3D),
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isProcessingImage ? 'Procesando imagen...' : 'Tocar para agregar portada',
                                    style: GoogleFonts.monomaniacOne(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          
                          // Botón para remover imagen
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
                  _buildTextField(_titleController, 'Título del libro'),
                  const SizedBox(height: 15),
                  
                  // Campo descripción
                  _buildTextField(_descriptionController, 'Descripción', maxLines: 3),
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
                    onPressed: isLoadingGenres ? null : () async {
                      setState(() {
                        isLoadingGenres = true;
                        errorMessage = null;
                      });
                      
                      try {
                        final genres = await booksCubit.getAllGenresUseCase.call();
                        
                        setState(() {
                          modalGenres = genres;
                          isLoadingGenres = false;
                        });
                      } catch (e) {
                        setState(() {
                          isLoadingGenres = false;
                          errorMessage = e.toString().replaceFirst('Exception: ', '');
                        });
                      }
                    },
                    child: isLoadingGenres
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                          final isSelected = modalSelectedGenres.contains(genreId);
                          
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
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Crear nuevo género
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(_newGenreController, 'Nuevo género'),
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
                            if (_newGenreController.text.isNotEmpty) {
                              setState(() {
                                modalNewGenres.add(_newGenreController.text.trim());
                                _newGenreController.clear();
                              });
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Género "${modalNewGenres.last}" agregado'),
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
                        children: modalNewGenres.map((genre) => Chip(
                          label: Text(genre),
                          backgroundColor: const Color(0xFFECEC3D),
                          labelStyle: const TextStyle(color: Colors.black),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              modalNewGenres.remove(genre);
                            });
                          },
                        )).toList(),
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
                  
                  // Botón crear libro
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCreatingBook ? Colors.grey : const Color(0xFFECEC3D),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: isCreatingBook ? null : () async {
                      if (_titleController.text.isEmpty || 
                          _descriptionController.text.isEmpty ||
                          (modalSelectedGenres.isEmpty && modalNewGenres.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Complete todos los campos y seleccione al menos un género'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      
                      setState(() {
                        isCreatingBook = true;
                      });
                      
                      try {
                        // Limpiar géneros seleccionados y establecer los nuevos
                        booksCubit.clearSelectedGenres();
                        for (int genreId in modalSelectedGenres) {
                          booksCubit.toggleGenreSelection(genreId);
                        }
                        
                        // Establecer la imagen seleccionada si existe
                        if (selectedImageBase64 != null) {
                          booksCubit.setCoverImageBase64(selectedImageBase64);
                        }
                        
                        // Crear el libro con imagen
                        await booksCubit.createBook(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          newGenres: modalNewGenres.isNotEmpty ? modalNewGenres : null,
                        );
                        
                        // Cerrar modal y mostrar éxito
                        Navigator.pop(modalContext);
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Libro creado exitosamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        
                        // Limpiar campos
                        _titleController.clear();
                        _descriptionController.clear();
                        
                      } catch (e) {
                        setState(() {
                          isCreatingBook = false;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString().replaceFirst('Exception: ', '')}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: isCreatingBook
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : Text(
                            'Crear Historia',
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

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con círculos decorativos
            Positioned(
              left: -13,
              top: 676,
              child: Container(
                width: 257,
                height: 260,
                decoration: const BoxDecoration(
                  color: Color(0xFF3D165C),
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
                  color: Color(0xFF3D165C),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Contenido principal
            BlocListener<BooksCubit, BooksState>(
              listener: (context, state) {
                if (state is BooksError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is BookCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is BookUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is BookPublicationToggled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is BookDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<BooksCubit>().getUserWritingBooks();
                },
                color: const Color(0xFFECEC3D),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100), // Espacio para el título
                      
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D165C),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Tus Historias',
                            style: GoogleFonts.monomaniacOne(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Lista de historias con estado
                      BlocBuilder<BooksCubit, BooksState>(
                        builder: (context, state) {
                          if (state is BooksLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(50),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFECEC3D),
                                ),
                              ),
                            );
                          } else if (state is BooksWritingLoaded) {
                            // AQUÍ ESTÁ EL CAMBIO PRINCIPAL - Usar BooksWritingLoaded en lugar de BooksLoaded
                            if (state.books.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.book_outlined,
                                        size: 64,
                                        color: Colors.white54,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No tienes historias creadas aún',
                                        style: GoogleFonts.monomaniacOne(
                                          color: Colors.white54,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Toca el botón + para crear tu primera historia',
                                        style: GoogleFonts.monomaniacOne(
                                          color: Colors.white38,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            return Column(
                              children: [
                                // Lista de libros
                                ...state.books.map((book) => Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: BookInfoWriter(
                                    title: book.title,
                                    synopsis: book.description,
                                    imageUrl: book.coverImage ?? '', // Usar la imagen base64 del libro
                                    tags: book.genres?.map((g) => g.name).join(', ') ?? 'Sin géneros',
                                    published: book.published ?? false,
                                    onTap: () {
                                      context.push("/bookDetail", extra: {
                                        'bookId': book.id,
                                      });
                                    },
                                    onEdit: () {
                                      _showEditBookModal(book);
                                    },
                                    onTogglePublish: () {
                                      context.read<BooksCubit>().toggleBookPublication(
                                        book.id!,
                                        !(book.published ?? false),
                                      );
                                    },
                                    onDelete: () {
                                      _showDeleteConfirmation(book);
                                    },
                                  ),
                                )),
                              ],
                            );
                          } else if (state is BooksError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error al cargar las historias',
                                      style: GoogleFonts.monomaniacOne(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.message,
                                      style: GoogleFonts.monomaniacOne(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<BooksCubit>().getUserWritingBooks();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFECEC3D),
                                      ),
                                      child: Text(
                                        'Reintentar',
                                        style: GoogleFonts.monomaniacOne(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          return const SizedBox.shrink();
                        },
                      ),
                      
                      const SizedBox(height: 145),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botón flotante para crear nueva historia
            Positioned(
              right: 20,
              bottom: 100,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFECEC3D),
                onPressed: _showCreateBookModal,
                child: const Icon(Icons.add, color: Colors.black, size: 30),
              ),
            ),

            const CustomTopBar(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomNavigationBar(
                currentRoute: '/writening'
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBookModal(book) {
    // Implementar modal de edición similar al de creación
    // Por ahora solo mostrar mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Función de edición para: ${book.title}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteConfirmation(book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            'Eliminar libro',
            style: GoogleFonts.monomaniacOne(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres eliminar "${book.title}"? Esta acción no se puede deshacer.',
            style: GoogleFonts.monomaniacOne(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.monomaniacOne(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<BooksCubit>().deleteBook(book.id!);
              },
              child: Text(
                'Eliminar',
                style: GoogleFonts.monomaniacOne(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}