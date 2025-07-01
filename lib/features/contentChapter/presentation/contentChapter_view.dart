// lib/features/chapter/presentation/chapter_reader_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/navigationBar/navigationBar.dart';

// Clase de datos para los comentarios del capítulo
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
    Key? key,
    this.chapterId = '1',
    this.bookTitle = 'Mi Libro Favorito',
  }) : super(key: key);

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  final TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  bool isDarkTheme = true; // Control del tema
  bool showComments = false; // Control de mostrar comentarios
  bool showFloatingButtons = true; // Control de botones flotantes
  bool isLoading = true; // Estado de carga
  
  // Contenido que se carga dinámicamente
  String chapterTitle = '';
  String chapterContent = '';
  
  // Datos simulados de comentarios del capítulo
  List<ChapterCommentData> comments = [];

  @override
  void initState() {
    super.initState();
    _loadChapterContent();
    _setupScrollListener();
  }

  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      // Ocultar botones al hacer scroll hacia abajo
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

  Future<void> _loadChapterContent() async {
    setState(() {
      isLoading = true;
    });

    // Simular carga del backend
    await Future.delayed(const Duration(seconds: 2));

    // Simular contenido del capítulo basado en ID
    final content = _getChapterContentById(widget.chapterId);
    
    // Simular comentarios
    final chapterComments = _getChapterComments(widget.chapterId);

    setState(() {
      chapterTitle = content['title']!;
      chapterContent = content['content']!;
      comments = chapterComments;
      isLoading = false;
    });
  }

  Map<String, String> _getChapterContentById(String id) {
    switch (id) {
      case '1':
        return {
          'title': 'Capítulo 1: El Despertar',
          'content': '''En una tierra lejana, donde los árboles susurraban secretos antiguos y las montañas tocaban las nubes, vivía un joven llamado Arin. Cada mañana despertaba con el sonido del viento que atravesaba su pequeña aldea, llevando consigo historias de tierras distantes y aventuras por descubrir.

Arin siempre había sentido que estaba destinado a algo más grande que la vida tranquila de su pueblo. Sus sueños estaban llenos de dragones, castillos flotantes y magia que podía cambiar el mundo. Pero nunca imaginó que esos sueños pronto se convertirían en realidad.

El día que cambió su vida para siempre comenzó como cualquier otro. Se levantó temprano, ayudó a su padre en los campos y se preparó para otra jornada rutinaria. Sin embargo, el destino tenía otros planes para él.

La primera señal de que algo extraordinario estaba por suceder llegó con el viento. Era diferente esa mañana: más fuerte, más cálido, y llevaba consigo un aroma que no pudo identificar. Era dulce como la miel, pero con un toque de algo salvaje y misterioso.

Mientras trabajaba en los campos, Arin notó que los animales se comportaban de manera extraña. Los pájaros volaban en círculos, como si estuvieran desorientados, y los caballos relinchaban nerviosamente sin razón aparente.'''
        };
      case '2':
        return {
          'title': 'Capítulo 2: El Extraño',
          'content': '''El misterioso extraño llegó al pueblo justo cuando el sol se ocultaba detrás de las montañas. Vestía una capa púrpura que brillaba con una luz propia, y sus ojos tenían el color del océano en tormenta. Los aldeanos se escondieron en sus casas, pero Arin sintió una extraña atracción hacia este visitante.

"Te he estado buscando, joven Arin", dijo el extraño con una voz que parecía venir desde las profundidades de la tierra. "Tu destino te llama, y el tiempo se agota. El equilibrio del mundo pende de un hilo, y tú eres la clave para restaurarlo."

Arin no entendía las palabras del extraño, pero algo en su interior le decía que debía escuchar. Era como si una parte de él siempre hubiera sabido que este momento llegaría.

El extraño extendió su mano, y en su palma apareció una pequeña esfera de luz azul que pulsaba como un corazón. "Esta es la Lágrima de Aethon", explicó. "Ha estado esperándote durante mil años. Con ella, podrás despertar el poder que duerme en tu interior."

Arin miró la esfera hipnotizado. La luz azul parecía llamarlo, invitarlo a tocarla. Sabía que si lo hacía, su vida cambiaría para siempre.'''
        };
      default:
        return {
          'title': 'Capítulo ${widget.chapterId}: Contenido no disponible',
          'content': 'Este capítulo aún no está disponible. Por favor, inténtalo más tarde.'
        };
    }
  }

  List<ChapterCommentData> _getChapterComments(String chapterId) {
    switch (chapterId) {
      case '1':
        return [
          ChapterCommentData(
            id: '1',
            username: 'Elena Ruiz',
            comment: '¡Qué inicio tan emocionante! Me encanta como describes el ambiente.',
            publishDate: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          ChapterCommentData(
            id: '2',
            username: 'Pedro Sánchez',
            comment: 'El desarrollo del personaje principal es increíble. Quiero saber qué pasa después.',
            publishDate: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];
      case '2':
        return [
          ChapterCommentData(
            id: '3',
            username: 'Sofia Torres',
            comment: 'Me tiene en suspenso desde la primera línea. ¡Excelente capítulo!',
            publishDate: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          ChapterCommentData(
            id: '4',
            username: 'Miguel Castro',
            comment: 'La descripción del extraño es fascinante. Me recuerda a los magos de las leyendas antiguas.',
            publishDate: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
      default:
        return [];
    }
  }

  // Colores según el tema
  Color get backgroundColor => isDarkTheme ? AppColors.background : const Color(0xFFDDDDDD);
  Color get textColor => isDarkTheme ? AppColors.textPrimary : AppColors.background;
  Color get dividerColor => isDarkTheme ? AppColors.primary : AppColors.secondary;

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void _addComment() {
    if (commentController.text.trim().isNotEmpty) {
      setState(() {
        comments.insert(0, ChapterCommentData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          username: 'Usuario Actual',
          comment: commentController.text.trim(),
          publishDate: DateTime.now(),
        ));
      });
      
      commentController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Comentario agregado'),
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

  Widget _buildLoadingView() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando capítulo...',
              style: GoogleFonts.cantarell(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterContent() {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Espacio para botones flotantes
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Título del capítulo
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text(
                      chapterTitle,
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
                
                const SizedBox(height: 40),
                
                // Contenido del capítulo
                Text(
                  chapterContent,
                  style: GoogleFonts.cantarell(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.justify,
                ),
                
                const SizedBox(height: 60),
                
                // Botones de navegación
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavButton(
                      icon: Icons.arrow_back,
                      label: 'Anterior',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Capítulo anterior')),
                        );
                      },
                    ),
                    _buildNavButton(
                      icon: Icons.arrow_forward,
                      label: 'Siguiente',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Siguiente capítulo')),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Sección de comentarios (título siempre visible)
                _buildCommentsSection(),
              ],
            ),
          ),
          
          const SizedBox(height: 100), // Espacio para NavigationBar
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textDark, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.cantarell(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de comentarios con función de toggle
        GestureDetector(
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
                    'Comentarios del capítulo (${comments.length})',
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
        
        // Contenido de comentarios (solo visible cuando showComments es true)
        if (showComments) ...[
          const SizedBox(height: 20),
          
          // Campo para agregar comentario
          Container(
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
                Text(
                  'Comparte tu opinión sobre este capítulo:',
                  style: GoogleFonts.cantarell(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addComment,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: AppColors.textDark,
                          size: 20,
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
      ],
    );
  }

  Widget _buildCommentItem(ChapterCommentData comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
                  comment.username[0].toUpperCase(),
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
                  comment.username,
                  style: GoogleFonts.cantarell(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _formatDate(comment.publishDate),
                style: GoogleFonts.cantarell(
                  color: textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.comment,
            style: GoogleFonts.cantarell(
              color: textColor,
              fontSize: 14,
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
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Contenido principal
          isLoading 
            ? _buildLoadingView()
            : SingleChildScrollView(
                controller: scrollController,
                child: _buildChapterContent(),
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
              currentRoute: '/ChapterReader'
            ),
          ),
        ],
      ),
    );
  }
}