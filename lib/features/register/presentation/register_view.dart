import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -screenHeight * 0.12,
              left: screenWidth * 0.35,
              child: Container(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: const Color(0xFFEDED3D), width: 4),
                ),
              ),
            ),
            Positioned(
              top: -screenHeight * 0.08,
              right: -screenWidth * 0.25,
              child: Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3D175C),
                ),
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.12,
              left: -screenWidth * 0.25,
              child: Container(
                width: screenWidth * 0.7,
                height: screenWidth * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3D175C),
                ),
              ),
            ),
            Positioned(
              bottom: -screenHeight * 0.12,
              right: screenWidth * 0.3,
              child: Container(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: const Color(0xFFEDED3D), width: 4),
                ),
              ),
            ),

            // Contenido principal
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.1),

                    // Título "Registro"
                    Center(
                      child: Text(
                        'Registro',
                        style: GoogleFonts.monomaniacOne(
                          fontSize: screenWidth * 0.23,
                        color: const Color(0xFFF2F2F2),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    // Label Correo
                    Text(
                        'Correo',
                        style: GoogleFonts.monomaniacOne(
                        fontSize: screenWidth * 0.04,
                        color: const Color(0xFFF2F2F2),
                        letterSpacing: 1.0,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Campo de Correo
                    Container(
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFE0E0E0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.04),
                            child: Icon(
                              Icons.email_outlined,
                              color: Colors.black54,
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Label Contraseña
                    Text(
                      'Contraseña',
                      style: GoogleFonts.monomaniacOne(
                      fontSize: screenWidth * 0.04,
                      color: const Color(0xFFF2F2F2),
                      letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // Campo de Contraseña
                    Container(
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFE0E0E0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.04),
                            child: Icon(
                              Icons.key,
                              color: Colors.black54,
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Label Confirmar Contraseña
                    Text(
                      'Confirmar contraseña',
                      style: GoogleFonts.monomaniacOne(
                      fontSize: screenWidth * 0.04,
                      color: const Color(0xFFF2F2F2),
                      letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // Campo de Confirmar Contraseña
                    Container(
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFE0E0E0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.04),
                            child: Icon(
                              Icons.key,
                              color: Colors.black54,
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Botón de Registro
                    Center(
                      child: Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFFFEB3B), // Amarillo
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.black87,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Registro',
                              style: GoogleFonts.monomaniacOne(
                                fontSize: screenWidth * 0.04,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    // Texto para ir a login
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.monomaniacOne(
                            fontSize: screenWidth * 0.04,
                            color: const Color(0xFFF2F2F2),
                            letterSpacing: 1.0,
                          ),
                          children: [
                            const TextSpan(text: 'Ya tienes cuenta ? '),
                            TextSpan(
                              text: 'Inicia sesión',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: const Color(0xFFEDED3D),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFFEDED3D),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
