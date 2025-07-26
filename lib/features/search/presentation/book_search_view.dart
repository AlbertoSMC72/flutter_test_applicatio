import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/bookInfo/bookInfoWriter.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../presentation/cubit/book_search_cubit.dart';
import '../presentation/cubit/book_search_state.dart';
import 'package:go_router/go_router.dart';

class BookSearchView extends StatefulWidget {
  const BookSearchView({Key? key}) : super(key: key);

  @override
  State<BookSearchView> createState() => _BookSearchViewState();
}

class _BookSearchViewState extends State<BookSearchView> {
  String? query;
  String? userId;
  bool _hasSearched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (!_hasSearched && args != null) {
      query = args['query']?.toString();
      userId = args['userId']?.toString();
      if (query != null && userId != null && query!.length >= 2) {
        context.read<BookSearchCubit>().searchBooks(query!, userId!);
        _hasSearched = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo decorativo
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
            LayoutBuilder(
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
                        const SizedBox(height: 100), // Espacio para la barra y el título
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
                            child: Column(
                              children: [
                                Text(
                                  'Resultados de búsqueda',
                                  style: GoogleFonts.monomaniacOne(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (query != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '"$query"',
                                      style: GoogleFonts.monomaniacOne(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<BookSearchCubit, BookSearchState>(
                          builder: (context, state) {
                            if (state is BookSearchLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50),
                                  child: CircularProgressIndicator(color: Color(0xFFECEC3D)),
                                ),
                              );
                            } else if (state is BookSearchLoaded) {
                              if (state.books.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off, size: 64, color: Colors.white54),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No se encontraron resultados',
                                        style: GoogleFonts.monomaniacOne(
                                          color: Colors.white54,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                children: [
                                  ...state.books.map((book) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: BookInfoWriter(
                                      title: book.title,
                                      synopsis: book.description,
                                      imageUrl: book.coverImage,
                                      tags: book.genres.isNotEmpty
                                          ? book.genres.map((g) => g.name).join(', ')
                                          : 'Sin género',
                                      likesCount: 0,
                                      onTap: () {},
                                      published: false,
                                      onEdit: () {},
                                      onTogglePublish: () {},
                                      onDelete: () {},
                                    ),
                                  )),
                                  const SizedBox(height: 145),
                                ],
                              );
                            } else if (state is BookSearchError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: GoogleFonts.monomaniacOne(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return Center(
                              child: Text(
                                'Busca un libro usando la barra superior',
                                style: GoogleFonts.monomaniacOne(
                                  color: Colors.white38,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const CustomTopBar(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomNavigationBar(currentRoute: '/search'),
            ),
          ],
        ),
      ),
    );
  }
} 