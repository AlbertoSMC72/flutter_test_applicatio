import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../../features/components/bookInfo/bookInfoWriter.dart';
import '/../../features/components/navigationBar/navigationBar.dart';
import '/../../features/components/searchUserBar/searchUserBar.dart';
import '/../../core/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/fav_books_cubit.dart';
import 'cubit/fav_books_state.dart';

class FavBooksScreen extends StatefulWidget {
  const FavBooksScreen({super.key});

  @override
  _FavBooksScreenState createState() => _FavBooksScreenState();
}

class _FavBooksScreenState extends State<FavBooksScreen> {
  String? currentUserId;
  final StorageService _storageService = StorageServiceImpl();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _storageService.getUserData();
    setState(() {
      currentUserId = userData['userId'];
    });
    
    if (currentUserId != null) {
      context.read<FavBooksCubit>().getUserFavBooks(currentUserId!);
    }
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
            BlocListener<FavBooksCubit, FavBooksState>(
              listener: (context, state) {
                if (state is FavBooksError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else if (state is LikeToggled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  if (currentUserId != null) {
                    context.read<FavBooksCubit>().getUserFavBooks(currentUserId!);
                  }
                },
                color: const Color(0xFFECEC3D),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final minHeight = constraints.maxHeight;
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: minHeight),
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
                                  'Mis Favoritos',
                                  style: GoogleFonts.monomaniacOne(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            // Lista de libros favoritos con estado
                            BlocBuilder<FavBooksCubit, FavBooksState>(
                              builder: (context, state) {
                                if (state is FavBooksLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(50),
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFECEC3D),
                                      ),
                                    ),
                                  );
                                } else if (state is FavBooksLoaded) {
                                  if (state.books.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(50),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              size: 64,
                                              color: Colors.white54,
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No tienes libros favoritos aún',
                                              style: GoogleFonts.monomaniacOne(
                                                color: Colors.white54,
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Explora libros y dales like para verlos aquí',
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
                                      // Lista de libros favoritos
                                      ...state.books.map((favBook) => Padding(
                                        padding: const EdgeInsets.only(bottom: 30),
                                        child: BookInfoWriter(
                                          title: favBook.book.title,
                                          synopsis: favBook.book.description ?? 'Por: ${favBook.book.author.username}',
                                          imageUrl: favBook.book.coverImage ?? '',
                                          tags: favBook.book.genres != null && favBook.book.genres!.isNotEmpty
                                              ? favBook.book.genres!.join(', ')
                                              : 'Favorito',
                                          isLiked: favBook.book.isLiked ?? true, // Usar el estado real
                                          likesCount: favBook.book.likesCount ?? 0, // Usar el contador real
                                          onTap: () {
                                            context.push("/bookDetail", extra: {
                                              'bookId': favBook.book.id,
                                            });
                                          },
                                          onLikeToggle: () {
                                            if (currentUserId != null) {
                                              context.read<FavBooksCubit>().toggleBookLike(
                                                currentUserId!,
                                                favBook.book.id,
                                              );
                                            }
                                          },
                                          published: false,
                                          onEdit: () {},
                                          onTogglePublish: () {},
                                          onDelete: () {},
                                        ),
                                      )),
                                    ],
                                  );
                                } else if (state is FavBooksError) {
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
                                            'Error al cargar los favoritos',
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
                                              if (currentUserId != null) {
                                                context.read<FavBooksCubit>().getUserFavBooks(currentUserId!);
                                              }
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
                    );
                  },
                ),
              ),
            ),

            const CustomTopBar(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomNavigationBar(
                currentRoute: '/favorites'
              ),
            ),
          ],
        ),
      ),
    );
  }
}