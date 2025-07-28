import 'package:flutter/material.dart';
import '/../../core/utils/image_utils.dart';
import 'package:google_fonts/google_fonts.dart';


class BookInfoWriter extends StatelessWidget {
  final String title;
  final String synopsis;
  final String imageUrl;
  final String tags;
  final VoidCallback onTap;
  final bool? isLiked;
  final int? likesCount;
  final VoidCallback? onLikeToggle;

  const BookInfoWriter({
    Key? key,
    required this.title,
    required this.synopsis,
    required this.imageUrl,
    required this.tags,
    required this.onTap,
    this.isLiked,
    this.likesCount,
    this.onLikeToggle,
    required bool published,
    required Null Function() onEdit,
    required Null Function() onTogglePublish,
    required Null Function() onDelete,
  }) : super(key: key);

  // Método para obtener un ImageProvider no nullable
  ImageProvider? _getImageProvider(String imageString) {
    // Si la imagen está vacía, retornar null
    if (imageString.isEmpty) {
      return null;
    }
    
    // Intentar convertir como base64 primero
    final memoryImage = ImageUtils.base64ToMemoryImage(imageString);
    if (memoryImage != null) {
      return memoryImage;
    }

    // Si es una URL, usar NetworkImage
    if (imageString.startsWith('http')) {
      return NetworkImage(imageString);
    }

    // Si no es ninguno de los anteriores, retornar null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 400;

            return isSmallScreen
                ? _buildVerticalLayout(context)
                : _buildHorizontalLayout(context);
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portada del libro
        Container(
          width: 150,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _getImageProvider(imageUrl) == null 
                ? const Color(0x35606060) // Fondo semi-transparente gris cuando no hay imagen
                : null,
            image: _getImageProvider(imageUrl) != null 
                ? DecorationImage(
                    image: _getImageProvider(imageUrl)!,
                    fit: BoxFit.cover,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _getImageProvider(imageUrl) == null
              ? const Center(
                  child: Icon(
                    Icons.book,
                    color: Colors.white70,
                    size: 50,
                  ),
                )
              : null,
        ),

        const SizedBox(width: 15),

        // Información del libro
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
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

              const SizedBox(height: 10),

              // Sinopsis
              Text(
                synopsis,
                style: GoogleFonts.monomaniacOne(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 15),

              // Tags y acciones
              Row(
                children: [
                  // Tags
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
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
                      child: Text(
                        tags,
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  
                  // Corazón de like
                  if (onLikeToggle != null) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onLikeToggle,
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked == true ? Icons.favorite : Icons.favorite_border,
                              color: isLiked == true ? Colors.red : Colors.white,
                              size: 20,
                            ),
                            if (likesCount != null) ...[
                              const SizedBox(width: 5),
                              Text(
                                likesCount.toString(),
                                style: GoogleFonts.monomaniacOne(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Portada del libro
        Center(
          child: Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: _getImageProvider(imageUrl) == null 
                  ? const Color(0x35606060) // Fondo semi-transparente gris cuando no hay imagen
                  : null,
              image: _getImageProvider(imageUrl) != null 
                  ? DecorationImage(
                      image: _getImageProvider(imageUrl)!,
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _getImageProvider(imageUrl) == null
                ? const Center(
                    child: Icon(
                      Icons.book,
                      color: Colors.white70,
                      size: 50,
                    ),
                  )
                : null,
          ),
        ),

        const SizedBox(height: 15),

        // Título
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
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

        const SizedBox(height: 10),

        // Sinopsis
        Text(
          synopsis,
          style: GoogleFonts.monomaniacOne(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 15),

        // Tags y acciones
        Row(
          children: [
            // Tags
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
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
                child: Text(
                  tags,
                  style: GoogleFonts.monomaniacOne(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            
            // Corazón de like
            if (onLikeToggle != null) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onLikeToggle,
                child: Container(
                  padding: const EdgeInsets.all(8),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLiked == true ? Icons.favorite : Icons.favorite_border,
                        color: isLiked == true ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      if (likesCount != null) ...[
                        const SizedBox(width: 5),
                        Text(
                          likesCount.toString(),
                          style: GoogleFonts.monomaniacOne(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
