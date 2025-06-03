import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/bookInfo/bookInfoWriter.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';

import 'package:google_fonts/google_fonts.dart';



class UserStoriesScreen extends StatefulWidget {
  const UserStoriesScreen({Key? key}) : super(key: key);

  @override
  _UserStoriesScreenState createState() => _UserStoriesScreenState();
}

class _UserStoriesScreenState extends State<UserStoriesScreen> {
  // Lista de libros del usuario
  final List<Map<String, String>> userStories = [
    {
      'title': 'Mi Primera Aventura',
      'synopsis': 'Lorem ipsum dolor sit amet consectetur. Mauris at lectus enim vestibulum. Lacus lacus turpis sem purus vel et ultricies et ligula.',
      'imageUrl': 'https://placehold.co/150x200',
      'tags': 'Aventura, Fantasía'
    },
    {
      'title': 'El Misterio del Bosque',
      'synopsis': 'Fusce metus purus habitant sed fames leo in. Lorem ipsum dolor sit amet consectetur adipiscing elit.',
      'imageUrl': 'https://placehold.co/150x200',
      'tags': 'Misterio, Suspenso'
    },
  ];

  // Controladores de texto para el modal de creación de libro
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _showCreateBookModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crear Nueva Historia',
                style: GoogleFonts.monomaniacOne(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Título del libro'),
              const SizedBox(height: 15),
              _buildTextField(_synopsisController, 'Sinopsis', maxLines: 3),
              const SizedBox(height: 15),
              _buildTextField(_imageUrlController, 'URL de la imagen'),
              const SizedBox(height: 15),
              _buildTextField(_tagsController, 'Tags (separados por comas)'),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECEC3D),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    setState(() {
                      userStories.insert(0, {
                        'title': _titleController.text,
                        'synopsis': _synopsisController.text,
                        'imageUrl': _imageUrlController.text.isEmpty 
                            ? 'https://placehold.co/150x200' 
                            : _imageUrlController.text,
                        'tags': _tagsController.text,
                      });
                    });
                    Navigator.pop(context);
                    _titleController.clear();
                    _synopsisController.clear();
                    _imageUrlController.clear();
                    _tagsController.clear();
                  }
                },
                child: Text(
                  'Crear Historia',
                  style: GoogleFonts.monomaniacOne(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.monomaniacOne(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0x35606060),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100), // Espacio para el título
                  
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
                        'Tus Historias',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Lista de historias
                  if (userStories.isEmpty)
                    Center(
                      child: Text(
                        'No tienes historias creadas aún',
                        style: GoogleFonts.monomaniacOne(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    )
                  else
                    ...userStories.map((story) => Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: BookInfoWriter(
                        title: story['title']!,
                        synopsis: story['synopsis']!,
                        imageUrl: story['imageUrl']!,
                        tags: story['tags']!,
                        onTap: () {
                          // Acción al tocar un libro
                        },
                      ),
                    )),
                  
                  const SizedBox(height: 145),
                ],
              ),
            ),
            
            // Botón flotante para crear nueva historia
            Positioned(
              right: 20,
              bottom: 100,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFECEC3D),
                onPressed: _showCreateBookModal,
                child: const Icon(Icons.add, color: Colors.black, size: 30),
              ),
            ),

          const CustomTopBar(),
          const CustomNavigationBar(
            currentRoute: '/Writening'
          ),
          

          ],
        ),
      ),
    );
  }
}

