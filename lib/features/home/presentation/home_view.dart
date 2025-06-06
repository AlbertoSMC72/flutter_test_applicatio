import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/domain/entities/home_book_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/components/bookImage/bookImage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo: ${book.title}'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        duration: const Duration(seconds: 2),
      ),
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
              imageUrl: 'https://placehold.co/150x200',
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
          color: const Color(0x35606060),
          borderRadius: BorderRadius.circular(15),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            
            // Loading para cada sección
            _buildCategoryHeader('Nuevas publicaciones'),
            SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFFECEC3D),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildCategoryHeader('Recomendados para ti'),
            SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFFECEC3D),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            _buildCategoryHeader('Tendencias'),
            SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFFECEC3D),
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            
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
                backgroundColor: const Color(0xFFECEC3D),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Reintentar',
                style: GoogleFonts.monomaniacOne(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
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
                    color: const Color(0xFFECEC3D),
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
                    color: const Color(0xFFECEC3D),
                  ),
                );
              },
            ),
          ),

          // TopBar
          const CustomTopBar(),

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