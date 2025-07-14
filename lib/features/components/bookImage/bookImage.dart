import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final VoidCallback? onTap;

  const BookImage({
    Key? key,
    this.imageUrl = "https://placehold.co/150x200",
    this.title = "Título",
    this.category = "Categoría",
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 200,
        child: Stack(
          children: [
            // Imagen principal del libro
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 150,
                height: 200,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: Image.memory(base64Decode(imageUrl)).image, // Cambiado a MemoryImage para evitar problemas de red
                    // image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 153,
              child: Container(
                width: 150,
                height: 47,
                decoration: ShapeDecoration(
                  color: const Color(0x7AF2F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            // Contenedor de la categoría
            Positioned(
              left: 5,
              top: 131,
              child: Container(
                width: 61,
                height: 19,
                decoration: ShapeDecoration(
                  color: const Color(0x7AF2F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            // Texto del título centrado y adaptativo
            Positioned(
              left: 5,
              top: 153,
              child: Container(
                width: 140, // Ancho del contenedor menos padding
                height: 47,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2, // Máximo 2 líneas
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.monomaniacOne(
                      color: const Color(0xFF1E1E1E),
                      fontSize: _calculateFontSize(title),
                      fontWeight: FontWeight.w400,
                      height: 1.1, // Espaciado entre líneas más compacto
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 5,
              top: 131,
              child: Container(
                width: 61,
                height: 19,
                child: Center(
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.monomaniacOne(
                      color: const Color(0xFF1E1E1E),
                      fontSize: 12, // Reducido para que siempre quepa
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para calcular el tamaño de fuente según la longitud del título
  double _calculateFontSize(String text) {
    if (text.length <= 8) {
      return 18.0; // Título corto - fuente grande
    } else if (text.length <= 15) {
      return 16.0; // Título mediano - fuente mediana
    } else if (text.length <= 25) {
      return 14.0; // Título largo - fuente pequeña
    } else {
      return 12.0; // Título muy largo - fuente muy pequeña
    }
  }
}