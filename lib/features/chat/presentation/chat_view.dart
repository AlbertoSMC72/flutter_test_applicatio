import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../../components/searchUserBar/searchUserBar.dart';

class ChatComingSoonView extends StatelessWidget {
  const ChatComingSoonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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

            // Contenido principal del chat simulado
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  
                  // Título del chat
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
                        'Chat Literario',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // Mensajes simulados del chat
                  _buildChatMessage(
                    'Usuario1',
                    '¿Alguien ha leído el último capítulo de...?',
                    true,
                    screenWidth,
                  ),
                  
                  _buildChatMessage(
                    'Lectora_Apasionada',
                    '¡Sí! Me encantó el giro inesperado 📚',
                    false,
                    screenWidth,
                  ),
                  
                  _buildChatMessage(
                    'BookWorm92',
                    'No spoilers por favor 😅',
                    true,
                    screenWidth,
                  ),
                  
                  _buildChatMessage(
                    'Escritor_Novato',
                    '¿Alguien puede darme feedback sobre mi nueva historia?',
                    false,
                    screenWidth,
                  ),
                  
                  _buildChatMessage(
                    'FanFiction_Queen',
                    'Claro, comparte el enlace 💫',
                    true,
                    screenWidth,
                  ),

                  const SizedBox(height: 20),

                  // Overlay difuminado con "Próximamente"
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFECEC3D),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icono principal
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFECEC3D).withOpacity(0.2),
                              border: Border.all(
                                color: const Color(0xFFECEC3D),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 60,
                              color: const Color(0xFFECEC3D),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Texto principal
                          Text(
                            'PRÓXIMAMENTE',
                            style: GoogleFonts.monomaniacOne(
                              fontSize: 28,
                              color: const Color(0xFFECEC3D),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          
                          const SizedBox(height: 15),
                          
                          // Descripción
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Chatea con otros lectores y escritores\nComparte opiniones y descubre nuevas historias',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.monomaniacOne(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Indicador de carga animado
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLoadingDot(0),
                              const SizedBox(width: 8),
                              _buildLoadingDot(1),
                              const SizedBox(width: 8),
                              _buildLoadingDot(2),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Área del input simulado (difuminado)
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Escribe un mensaje...',
                              style: GoogleFonts.monomaniacOne(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 145),
                ],
              ),
            ),

            // Top bar y navigation bar
            const CustomTopBar(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomNavigationBar(currentRoute: '/chat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String username, String message, bool isOwnMessage, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isOwnMessage) ...[
            // Avatar del usuario
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3D165C),
                border: Border.all(color: Colors.white24),
              ),
              child: Center(
                child: Text(
                  username[0].toUpperCase(),
                  style: GoogleFonts.monomaniacOne(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          
          // Contenedor del mensaje
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isOwnMessage 
                  ? const Color(0xFFECEC3D).withOpacity(0.3)
                  : const Color(0xFF2A2A2A).withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isOwnMessage ? const Radius.circular(15) : const Radius.circular(3),
                  bottomRight: isOwnMessage ? const Radius.circular(3) : const Radius.circular(15),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        username,
                        style: GoogleFonts.monomaniacOne(
                          color: const Color(0xFFECEC3D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    message,
                    style: GoogleFonts.monomaniacOne(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isOwnMessage) ...[
            const SizedBox(width: 10),
            // Avatar propio
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFECEC3D).withOpacity(0.3),
                border: Border.all(color: const Color(0xFFECEC3D)),
              ),
              child: Center(
                child: Text(
                  username[0].toUpperCase(),
                  style: GoogleFonts.monomaniacOne(
                    color: const Color(0xFFECEC3D),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.3, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFECEC3D).withOpacity(value),
            ),
          ),
        );
      },
      onEnd: () {
        // Reiniciar la animación
      },
    );
  }
}