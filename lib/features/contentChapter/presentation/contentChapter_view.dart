import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/features/contentChapter/presentation/cubit/chapter_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/dependency_injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../../core/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapterCommentData {
  final String id;
  final String username;
  final String comment;
  final DateTime publishDate;

  ChapterCommentData({
    required this.id,
    required this.username,
    required this.comment,
    required this.publishDate,
  });
}

class ChapterReaderScreen extends StatefulWidget {
  final String chapterId;
  final String bookTitle;

  const ChapterReaderScreen({
    super.key,
    this.chapterId = '1',
    this.bookTitle = 'Mi Libro Favorito',
  });

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  final ScrollController scrollController = ScrollController();
  bool isDarkTheme = true;
  bool showComments = false;
  bool showFloatingButtons = true;
  final StorageService _storageService = StorageServiceImpl();
  final ChapterCubit _chapterCubit = sl<ChapterCubit>();
  String? userId;
  String? username;
  bool isAuthor = false;
  final TextEditingController paragraphController = TextEditingController();
  bool canSaveParagraphs = false;
  String? paragraphValidationError;
  final TextEditingController commentController = TextEditingController();
  bool canSendComment = false;
  String? commentValidationError;

  @override
  void initState() {
    super.initState();
    _initUserAndLoadChapter();
    _setupScrollListener();
    paragraphController.addListener(_onParagraphChanged);
    commentController.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    paragraphController.dispose();
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _initUserAndLoadChapter() async {
    final userData = await _storageService.getUserData();
    userId = userData['userId'];
    username = userData['username'];
    _chapterCubit.loadChapter(widget.chapterId);
  }

  void _onParagraphChanged() {
    final text = paragraphController.text;
    final paragraphs = text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    bool allLongEnough = paragraphs.isNotEmpty && paragraphs.every((p) => p.length >= 10);
    setState(() {
      canSaveParagraphs = allLongEnough && text.contains('\n');
      paragraphValidationError = !allLongEnough && paragraphs.isNotEmpty
        ? 'Cada párrafo debe tener al menos 10 caracteres'
        : null;
    });
  }

  void _saveParagraphs(String chapterId) async {
    final text = paragraphController.text.trim();
    if (text.isEmpty) return;
    final paragraphs = text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (paragraphs.isEmpty) return;
    await _chapterCubit.addParagraph(chapterId, paragraphs);
    paragraphController.clear();
    setState(() {
      canSaveParagraphs = false;
    });
  }

  void _onCommentChanged() {
    final text = commentController.text.trim();
    setState(() {
      canSendComment = text.length >= 3;
      commentValidationError = text.isNotEmpty && text.length < 3
        ? 'El comentario debe tener al menos 3 caracteres'
        : null;
    });
  }

  Future<void> _sendComment(String chapterId) async {
    final text = commentController.text.trim();
    if (text.length < 3 || userId == null) return;
    await _chapterCubit.addComment(chapterId, userId!, text);
    commentController.clear();
    setState(() {
      canSendComment = false;
    });
  }

  Color get backgroundColor => isDarkTheme ? AppColors.background : const Color(0xFFDDDDDD);
  Color get textColor => isDarkTheme ? AppColors.textPrimary : AppColors.background;
  Color get dividerColor => isDarkTheme ? AppColors.primary : AppColors.secondary;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (showFloatingButtons) {
          setState(() {
            showFloatingButtons = false;
          });
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!showFloatingButtons) {
          setState(() {
            showFloatingButtons = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chapterCubit,
      child: BlocConsumer<ChapterCubit, ChapterState>(
        listener: (context, state) {
          if (state is ParagraphAddedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Párrafos agregados exitosamente!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is ChapterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChapterLoading || username == null) {
            return _buildLoadingView();
          }
          if (state is ChapterError) {
            return _buildErrorView(state.message);
          }
          if (state is ChapterLoaded) {
            final chapter = state.chapter;
            final isAuthor = (username != null && chapter.book?.author?.username == username);
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        // Título del capítulo
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Text(
                              chapter.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cantarell(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Línea divisoria
                        Center(
                          child: Container(
                            width: 250,
                            height: 2,
                            decoration: BoxDecoration(
                              color: dividerColor,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Información del autor del libro
                        if (chapter.book?.author != null)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Necesitamos authorId en la respuesta del backend
                                // Por ahora solo mostramos el autor sin navegación
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Funcionalidad de navegación al perfil del autor próximamente'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isDarkTheme 
                                      ? AppColors.surfaceTransparent 
                                      : AppColors.surfaceTransparent.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: textColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Por: ${chapter.book!.author!.username}',
                                      style: GoogleFonts.cantarell(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: textColor.withOpacity(0.7),
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        // Párrafos del capítulo
                        ...chapter.paragraphs.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                          child: Text(
                            p.content,
                            style: GoogleFonts.cantarell(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        )),
                        const SizedBox(height: 30),
                        // Campo y botón para agregar párrafos (solo autor)
                        if (isAuthor)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: paragraphController,
                                  maxLines: 5,
                                  style: GoogleFonts.cantarell(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Escribe aquí...\nCada salto de línea será un nuevo párrafo',
                                    hintStyle: GoogleFonts.cantarell(
                                      color: textColor.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: backgroundColor.withOpacity(0.5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                if (paragraphValidationError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      paragraphValidationError!,
                                      style: GoogleFonts.cantarell(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: canSaveParagraphs
                                      ? () => _saveParagraphs(chapter.id)
                                      : null,
                                  icon: const Icon(Icons.save),
                                  label: const Text('Guardar párrafos'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 30),
                        // Sección de comentarios
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showComments = !showComments;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(
                                color: isDarkTheme 
                                    ? AppColors.surfaceTransparent 
                                    : AppColors.surfaceTransparent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.comment,
                                    color: textColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Comentarios del capítulo (${chapter.comments.length})',
                                      style: GoogleFonts.cantarell(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Icon(
                                    showComments ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: textColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (showComments) ...[
                          const SizedBox(height: 20),
                          // Lista de comentarios
                          ...chapter.comments.map((c) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: isDarkTheme 
                                    ? AppColors.surfaceTransparent 
                                    : AppColors.surfaceTransparent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primary,
                                        child: Text(
                                          (c.user?.username ?? '?').substring(0, 1).toUpperCase(),
                                          style: GoogleFonts.cantarell(
                                            color: AppColors.textDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          c.user?.username ?? 'Anónimo',
                                          style: GoogleFonts.cantarell(
                                            color: textColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _formatDate(c.createdAt is DateTime ? c.createdAt : null),
                                        style: GoogleFonts.cantarell(
                                          color: textColor.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    c.comment,
                                    style: GoogleFonts.cantarell(
                                      color: textColor,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: commentController,
                                maxLines: 2,
                                style: GoogleFonts.cantarell(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Escribe tu comentario...',
                                  hintStyle: GoogleFonts.cantarell(
                                    color: textColor.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: backgroundColor.withOpacity(0.5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              if (commentValidationError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    commentValidationError!,
                                    style: GoogleFonts.cantarell(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: canSendComment
                                    ? () => _sendComment(chapter.id)
                                    : null,
                                icon: const Icon(Icons.send),
                                label: const Text('Enviar comentario'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  // Botones flotantes superiores (se ocultan al hacer scroll)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    top: showFloatingButtons ? 40 : -100,
                    left: 15,
                    child: SafeArea(
                      child: Row(
                        children: [
                          // Botón de regresar
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.textDark,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Botón de cambiar tema
                          GestureDetector(
                            onTap: _toggleTheme,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                                color: AppColors.textDark,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // NavigationBar siempre abajo
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomNavigationBar(
                      currentRoute: '/ChapterReader',
                    ),
                  ),
                ],
              ),
            );
          }
          // Si hay error, pero hay un capítulo cargado previamente, mostrarlo
          if (state is ChapterError && state.message.contains('Párrafos agregados')) {
            // No borres la pantalla, solo muestra el snackbar (ya hecho en listener)
            // Puedes mantener el último capítulo cargado si lo deseas
          }
          return const Scaffold(
            body: Center(child: Text('Cargando...')),
          );
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                // boxShadow eliminado para quitar líneas amarillas
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Cargando capítulo...',
              style: GoogleFonts.monomaniacOne(
                color: AppColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Por favor espera un momento',
              style: GoogleFonts.cantarell(
                color: textColor.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.12),
                shape: BoxShape.circle,
                // boxShadow eliminado para quitar líneas amarillas
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '¡Ups! Ocurrió un error',
              style: GoogleFonts.monomaniacOne(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                message,
                style: GoogleFonts.cantarell(
                  color: textColor.withOpacity(0.8),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _chapterCubit.loadChapter(widget.chapterId),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}