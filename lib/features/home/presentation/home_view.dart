import 'package:flutter/material.dart';
import '/../../features/home/domain/entities/home_book_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../../features/components/bookImage/bookImage.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../../features/components/searchUserBar/searchUserBar.dart';
import '/../../features/components/navigationBar/navigationBar.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'package:go_router/go_router.dart';
import '/../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _hasLoadedInitially = false; // Flag para evitar múltiples cargas

  @override
  void initState() {
    super.initState();
    // NO cargar aquí para evitar problemas de Provider
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleBookTap(HomeBookEntity book) {
    // Navegación al detalle del libro
    // Usando GoRouter
    context.pushNamed(
      'BookDetail',
      extra: {'bookId': book.id},
    );
  }

  Widget _buildBooksRow(List<HomeBookEntity> books) {
    if (books.isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Text(
            'No hay libros disponibles',
            style: GoogleFonts.monomaniacOne(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12.0,
              right: index == books.length - 1 ? 12.0 : 0,
            ),
            child: BookImage(
              title: book.title,
              category: book.genres.isNotEmpty ? book.genres.first : 'Sin género',
              imageUrl: book.coverImage,
              onTap: () => _handleBookTap(book),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 184,
        height: 34,
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
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.monomaniacOne(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.maxHeight;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  _buildCategoryHeader('Nuevas publicaciones'),
                  SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryHeader('Recomendados para ti'),
                  SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCategoryHeader('Tendencias'),
                  SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.maxHeight;
        return SizedBox.expand(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los libros',
                    style: GoogleFonts.monomaniacOne(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: GoogleFonts.monomaniacOne(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().loadBooks();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      'Reintentar',
                      style: GoogleFonts.monomaniacOne(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Círculos decorativos morados de fondo
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

          // Contenido principal con estados
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                // Cargar libros automáticamente solo UNA vez
                if (state is HomeInitial && !_hasLoadedInitially) {
                  _hasLoadedInitially = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) { // Verificar que el widget sigue montado
                      context.read<HomeCubit>().loadBooks();
                    }
                  });
                }
                
                if (state is HomeLoading) {
                  return _buildLoadingState();
                } else if (state is HomeError) {
                  return _buildErrorState(state.message);
                } else if (state is HomeLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeCubit>().refreshBooks();
                    },
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 120), // Espacio para TopBar

                            // Primera sección - Nuevas publicaciones
                            _buildCategoryHeader('Nuevas publicaciones'),
                            _buildBooksRow(state.newPublications),
                            
                            const SizedBox(height: 20),

                            // Segunda sección - Recomendados
                            _buildCategoryHeader('Recomendados para ti'),
                            _buildBooksRow(state.recommended),
                            
                            const SizedBox(height: 20),

                            // Tercera sección - Tendencias
                            _buildCategoryHeader('Tendencias'),
                            _buildBooksRow(state.trending),
                            
                            const SizedBox(height: 100), // Espacio para NavigationBar
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                // Estado inicial
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),

          CustomTopBar(),

          // NavigationBar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavigationBar(
              currentRoute: '/Home'
            ),
          ),
        ],
      ),
    );
  }
}