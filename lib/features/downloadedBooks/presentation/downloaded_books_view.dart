import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cubit/downloaded_books_cubit.dart';
import '../../components/navigationBar/navigationBar.dart';
import 'package:flutter_application_1/core/dependency_injection.dart';
import 'package:go_router/go_router.dart';

class DownloadedBooksView extends StatefulWidget {
  const DownloadedBooksView({Key? key}) : super(key: key);

  @override
  State<DownloadedBooksView> createState() => _DownloadedBooksViewState();
}

class _DownloadedBooksViewState extends State<DownloadedBooksView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DownloadedBooksCubit>()..loadDownloadedBooks(),
      child: Scaffold(
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
              BlocListener<DownloadedBooksCubit, DownloadedBooksState>(
                listener: (context, state) {
                  if (state is DownloadedBooksError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<DownloadedBooksCubit>().loadDownloadedBooks();
                  },
                  color: const Color(0xFFECEC3D),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
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
                              'Libros descargados',
                              style: GoogleFonts.monomaniacOne(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<DownloadedBooksCubit, DownloadedBooksState>(
                          builder: (context, state) {
                            if (state is DownloadedBooksLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFECEC3D),
                                  ),
                                ),
                              );
                            } else if (state is DownloadedBooksLoaded) {
                              if (state.books.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(50),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.download,
                                          size: 64,
                                          color: Colors.white54,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No tienes libros descargados aún',
                                          style: GoogleFonts.monomaniacOne(
                                            color: Colors.white54,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Descarga libros para verlos aquí',
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
                                  ...state.books.map((book) => Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push(
                                          '/downloadedChapters',
                                          extra: {
                                            'bookId': book.id,
                                            'bookTitle': book.title,
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2A2A2A),
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.15),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: book.coverImageBase64.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.memory(
                                                    base64Decode(book.coverImageBase64),
                                                    width: 50,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(Icons.book, size: 40, color: Colors.white70),
                                          title: Text(
                                            book.title,
                                            style: GoogleFonts.monomaniacOne(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Por: ${book.author}',
                                                style: GoogleFonts.monomaniacOne(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              if (book.genres.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    book.genres.join(', '),
                                                    style: GoogleFonts.monomaniacOne(
                                                      color: Colors.white38,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Eliminar libro descargado',
                                            onPressed: () async {
                                              // Eliminar libro descargado
                                              await context.read<DownloadedBooksCubit>().getDownloadedBooksUseCase.repository.deleteDownloadedBook(book.id);
                                              context.read<DownloadedBooksCubit>().loadDownloadedBooks();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Libro eliminado de descargas'),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                                ],
                              );
                            } else if (state is DownloadedBooksError) {
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
                                        'Error al cargar los libros descargados',
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
                                          context.read<DownloadedBooksCubit>().loadDownloadedBooks();
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
              const CustomTopBar(),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CustomNavigationBar(currentRoute: '/downloaded'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 