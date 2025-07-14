// lib/features/book/presentation/book_detail_view.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/image_utils.dart';
import '../../book/data/datasources/book_detail_api_service.dart';
import '../../book/data/repositories/book_detail_repository_impl.dart';
import '../../book/domain/usecases/book_detail_usecases.dart';
import 'cubit/book_detail_cubit.dart';
import 'cubit/book_detail_state.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../components/searchUserBar/searchUserBar.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController chapterTitleController = TextEditingController();

  late final BookDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BookDetailCubit(
      getBookDetailUseCase: GetBookDetailUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      addChapterUseCase: AddChapterUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      toggleChapterPublishUseCase: ToggleChapterPublishUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      deleteChapterUseCase: DeleteChapterUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      deleteBookUseCase: DeleteBookUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      addCommentUseCase: AddCommentUseCase(
        repository: BookDetailRepositoryImpl(
          apiService: BookDetailApiServiceImpl(),
        ),
      ),
      storageService: StorageServiceImpl(),
    );
    _cubit.loadBookDetail(widget.bookId);
  }

  @override
  void dispose() {
    commentController.dispose();
    chapterTitleController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<BookDetailCubit, BookDetailState>(
        listener: (context, state) {
          if (state is BookDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is ChapterAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Capítulo agregado'), backgroundColor: Colors.green),
            );
          }
          if (state is CommentAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Comentario publicado'), backgroundColor: Colors.green),
            );
            commentController.clear();
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 150,
                              height: 200,
                              child: (book.coverImage != null && book.coverImage!.isNotEmpty)
                                  ? Image.memory(base64Decode(book.coverImage!))
                                  : const Icon(Icons.book, size: 50),
                            ),
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
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                                children: (book.genres ?? []).map((genre) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    genre.name,
                                    style: GoogleFonts.monomaniacOne(
                                      color: AppColors.textDark,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Autor
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                            'Por: ${book.author?.username ?? 'Autor Desconocido'}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.monomaniacOne(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Capítulos
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: ElevatedButton.icon(
                                  onPressed: _showAddChapterDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar'),
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
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: ListTile(
                                title: Text(chapter.title),
                                subtitle: isAuthor && chapter.published != null
                                    ? Text(chapter.published! ? 'Publicado' : 'No publicado')
                                    : null,
                                trailing: isAuthor
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              chapter.published == true ? Icons.visibility : Icons.visibility_off,
                                              color: chapter.published == true ? Colors.green : Colors.grey,
                                            ),
                                            tooltip: chapter.published == true ? 'Despublicar' : 'Publicar',
                                            onPressed: () => _cubit.toggleChapterPublish(chapter.id, !(chapter.published ?? false)),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            tooltip: 'Eliminar capítulo',
                                            onPressed: () => _cubit.deleteChapter(chapter.id),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                        if (isAuthor)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: ElevatedButton.icon(
                              onPressed: () => _cubit.deleteBook(),
                              icon: const Icon(Icons.delete),
                              label: const Text('Eliminar libro'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
                              const Icon(Icons.comment, color: AppColors.textPrimary, size: 20),
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
                                    fillColor: AppColors.withOpacity(AppColors.surfaceTransparent, 0.5),
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
                        ...(book.comments ?? []).map((comment) => Container(
                          margin: const EdgeInsets.only(bottom: 18, left: 15, right: 15),
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
                                      (comment.user?.username ?? 'U')[0].toUpperCase(),
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
                        )),
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