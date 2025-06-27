// lib/features/book/presentation/book_detail_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../components/searchUserBar/searchUserBar.dart';

// Clase de datos para los comentarios
class CommentData {
  final String id;
  final String username;
  final String comment;
  final DateTime publishDate;

  CommentData({
    required this.id,
    required this.username,
    required this.comment,
    required this.publishDate,
  });
}

// Clase de datos para los capítulos
class ChapterData {
  final String id;
  final String title;
  bool isRead;
  bool isLiked;

  ChapterData({
    required this.id,
    required this.title,
    this.isRead = false,
    this.isLiked = false,
  });
}

class BookDetailScreen extends StatefulWidget {
  final String bookId;
  final String bookTitle;
  final String bookDescription;
  final String bookImageUrl;
  final String authorName;
  final List<String> genres;

  const BookDetailScreen({
    Key? key,
    this.bookId = '0',
    this.bookTitle = 'Título Desconocido',
    this.bookDescription = 'Sin descripción disponible',
    this.bookImageUrl = 'https://placehold.co/150x200',
    this.authorName = 'Autor Desconocido',
    this.genres = const [],
  }) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  
  // Datos simulados de capítulos - en el futuro vendrán del backend
  List<ChapterData> chapters = [
    ChapterData(
      id: '1',
      title: 'Capítulo 1: El comienzo',
      isRead: true,
      isLiked: false,
    ),
    ChapterData(
      id: '2',
      title: 'Capítulo 2: El viaje comienza',
      isRead: true,
      isLiked: true,
    ),
    ChapterData(
      id: '3',
      title: 'Capítulo 3: Los primeros obstáculos',
      isRead: false,
      isLiked: false,
    ),
    ChapterData(
      id: '4',
      title: 'Capítulo 4: La revelación inesperada',
      isRead: false,
      isLiked: false,
    ),
    ChapterData(
      id: '5',
      title: 'Capítulo 5: El punto de inflexión',
      isRead: false,
      isLiked: false,
    ),
  ];

  // Datos simulados de comentarios - en el futuro vendrán del backend
  List<CommentData> comments = [
    CommentData(
      id: '1',
      username: 'María García',
      comment: '¡Me encanta esta historia! Los personajes están muy bien desarrollados.',
      publishDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CommentData(
      id: '2',
      username: 'Carlos López',
      comment: 'Esperando ansiosamente el próximo capítulo. El final del último me dejó con ganas de más.',
      publishDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CommentData(
      id: '3',
      username: 'Ana Martínez',
      comment: 'La descripción del mundo es increíble, puedo visualizar cada escena perfectamente.',
      publishDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    CommentData(
      id: '4',
      username: 'Luis Rodríguez',
      comment: 'Una obra maestra del género. Recomiendo esta historia a todos.',
      publishDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _handleChapterTap(ChapterData chapter) {
    setState(() {
      chapter.isRead = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo: ${chapter.title}'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Aquí navegarías a la vista del capítulo
    // Navigator.pushNamed(context, '/chapter/${chapter.id}');
  }

  void _handleChapterLike(ChapterData chapter) {
    setState(() {
      chapter.isLiked = !chapter.isLiked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          chapter.isLiked 
            ? '❤️ Te gusta ${chapter.title}' 
            : '💔 Ya no te gusta ${chapter.title}'
        ),
        backgroundColor: chapter.isLiked ? AppColors.accent : AppColors.textSecondary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addComment() {
    if (commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, CommentData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: 'Usuario Actual', // En el futuro vendrá del usuario logueado
          comment: commentController.text.trim(),
          publishDate: DateTime.now(),
        ));
      });
      
      commentController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comentario publicado'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
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

  // Función para obtener géneros a mostrar (con valores por defecto)
  List<String> _getDisplayGenres() {
    if (widget.genres.isEmpty || (widget.genres.length == 1 && widget.genres[0].isEmpty)) {
      return ['Ficción', 'Drama']; // Géneros por defecto
    }
    return widget.genres;
  }

  Widget _buildBookHeader() {
    return Column(
      children: [
        const SizedBox(height: 120), // Espacio para la TopBar
        
        // Título del libro
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
            widget.bookTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.monomaniacOne(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Imagen del libro
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
              child: Image.network(
                widget.bookImageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 150,
                    height: 200,
                    color: AppColors.surfaceTransparent,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceTransparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book,
                          size: 50,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Imagen no\ndisponible',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.monomaniacOne(
                            color: AppColors.textPrimary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),

        // Descripción del libro
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            widget.bookDescription,
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
        
        // Géneros del libro
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
                children: _getDisplayGenres().map((genre) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    genre,
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
        
        // Información del autor
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
            'Por: ${widget.authorName}',
            textAlign: TextAlign.center,
            style: GoogleFonts.monomaniacOne(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildChaptersList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return _buildChapterItem(chapter, index + 1);
      },
    );
  }

  Widget _buildChapterItem(ChapterData chapter, int chapterNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
      child: Row(
        children: [
          // Contenedor del capítulo
          Expanded(
            child: GestureDetector(
              onTap: () => _handleChapterTap(chapter),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: chapter.isRead 
                      ? AppColors.surfaceTransparent 
                      : AppColors.withOpacity(AppColors.surfaceTransparent, 0.5),
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
                    // Indicador de leído/no leído
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: chapter.isRead ? AppColors.success : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    
                    const SizedBox(width: 18),
                    
                    // Título del capítulo
                    Expanded(
                      child: Text(
                        chapter.title,
                        style: GoogleFonts.monomaniacOne(
                          color: chapter.isRead 
                              ? AppColors.textPrimary 
                              : AppColors.withOpacity(AppColors.textPrimary, 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Botón de like al capítulo
          GestureDetector(
            onTap: () => _handleChapterLike(chapter),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: chapter.isLiked 
                    ? AppColors.accent 
                    : AppColors.surfaceTransparent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                chapter.isLiked ? Icons.favorite : Icons.favorite_border,
                color: chapter.isLiked 
                    ? AppColors.textPrimary 
                    : AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
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
              Icon(
                Icons.comment,
                color: AppColors.textPrimary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Comentarios (${comments.length})',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar comentario:',
                style: GoogleFonts.monomaniacOne(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Row(
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
                    onTap: _addComment,
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
                      child: Icon(
                        Icons.send,
                        color: AppColors.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Lista de comentarios
        ...comments.map((comment) => _buildCommentItem(comment)).toList(),
      ],
    );
  }

  Widget _buildCommentItem(CommentData comment) {
    return Container(
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
          // Header del comentario (usuario y fecha)
          Row(
            children: [
              // Avatar del usuario
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  comment.username[0].toUpperCase(),
                  style: GoogleFonts.monomaniacOne(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nombre de usuario
              Expanded(
                child: Text(
                  comment.username,
                  style: GoogleFonts.monomaniacOne(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Fecha
              Text(
                _formatDate(comment.publishDate),
                style: GoogleFonts.monomaniacOne(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Contenido del comentario
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                _buildBookHeader(),
                _buildChaptersList(),
                const SizedBox(height: 30),
                _buildCommentsSection(),
                const SizedBox(height: 100), // Espacio para NavigationBar
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
            child: CustomNavigationBar(
              currentRoute: '/BookDetail'
            ),
          ),
        ],
      ),
    );
  }
}