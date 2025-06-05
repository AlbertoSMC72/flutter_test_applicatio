// features/writenBook/presentation/writenBook_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/components/bookInfo/bookInfoWriter.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
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
    // Cargar libros del usuario al iniciar
    context.read<BooksCubit>().getUserBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newGenreController.dispose();
    super.dispose();
  }

  void _showCreateBookModal() {
    print('[DEBUG] Abriendo modal de creación...');
    
    // CAPTURAR EL CUBIT ANTES DE ABRIR EL MODAL
    final booksCubit = context.read<BooksCubit>();
    
    // Variables locales para el modal
    List<GenreEntity> modalGenres = [];
    List<int> modalSelectedGenres = [];
    bool isLoadingGenres = false;
    bool isCreatingBook = false;
    String? errorMessage;
    
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
                        // USA LA REFERENCIA CAPTURADA, NO context.read
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
                          final isSelected = modalSelectedGenres.contains(genre.id);
                          
                          return CheckboxListTile(
                            title: Text(
                              genre.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (isSelected) {
                                  modalSelectedGenres.remove(genre.id);
                                } else {
                                  modalSelectedGenres.add(genre.id!);
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
                          onPressed: () async {
                            if (_newGenreController.text.isNotEmpty) {
                              try {
                                // USA LA REFERENCIA CAPTURADA
                                final newGenre = await booksCubit.createGenreUseCase.call(_newGenreController.text);
                                
                                setState(() {
                                  modalGenres.add(newGenre);
                                });
                                
                                _newGenreController.clear();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Género creado exitosamente'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString().replaceFirst('Exception: ', '')}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Añadir',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
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
                          modalSelectedGenres.isEmpty) {
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
                        // Obtener userId del storage usando la referencia capturada
                        final userData = await booksCubit.storageService.getUserData();
                        final userId = userData['userId'];
                        
                        if (userId == null || userId.isEmpty) {
                          throw Exception('Usuario no encontrado. Inicia sesión nuevamente.');
                        }
                        
                        // Crear el libro usando la referencia capturada
                        await booksCubit.createBookUseCase.call(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          authorId: int.parse(userId),
                          genreIds: modalSelectedGenres,
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
                        
                        // Recargar libros usando la referencia capturada
                        booksCubit.getUserBooks();
                        
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
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<BooksCubit>().getUserBooks();
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
                          } else if (state is BooksLoaded) {
                            if (state.userBooks.books.isEmpty) {
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
                                // Información del usuario
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A2A),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color(0xFFECEC3D),
                                        child: Text(
                                          state.userBooks.user.username[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.userBooks.user.username,
                                              style: GoogleFonts.monomaniacOne(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '${state.userBooks.books.length} historias publicadas',
                                              style: GoogleFonts.monomaniacOne(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Lista de libros
                                ...state.userBooks.books.map((book) => Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: BookInfoWriter(
                                    title: book.title,
                                    synopsis: book.description,
                                    imageUrl: 'https://placehold.co/150x200', // Placeholder por ahora
                                    tags: 'Historia Personal', // Por ahora un tag genérico
                                    onTap: () {
                                      // Acción al tocar un libro
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Abriendo: ${book.title}'),
                                          backgroundColor: const Color(0xFFECEC3D),
                                        ),
                                      );
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
                                        context.read<BooksCubit>().getUserBooks();
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
                currentRoute: '/Writening'
              ),
            ),
          ],
        ),
      ),
    );
  }
}