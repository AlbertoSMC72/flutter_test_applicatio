import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/components/bookImage/bookImage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/features/components/searchUserBar/searchUserBar.dart';
import 'package:flutter_application_1/features/components/navigationBar/navigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentNavIndex = 2; // Home seleccionado
  int notificationCount = 0;
  final TextEditingController searchController = TextEditingController();

  // Datos simulados de libros
  final List<Map<String, String>> booksSection1 = [
    {'title': 'El Gran Gatsby', 'category': 'Fanficción'},
    {'title': '1984', 'category': 'Ciencia Ficción'},
    {'title': 'Cien Años de Soledad', 'category': 'Realismo'},
    {'title': 'Harry Potter y la Piedra Filosofal', 'category': 'Fantasía'},
    {'title': 'Dune', 'category': 'Ciencia Ficción'},
    {'title': 'El Hobbit', 'category': 'Fantasía'},
  ];

  final List<Map<String, String>> booksSection2 = [
    {'title': 'Don Quijote de la Mancha', 'category': 'Clásico'},
    {'title': 'El Señor de los Anillos', 'category': 'Fantasía'},
    {'title': 'Orgullo y Prejuicio', 'category': 'Romance'},
    {'title': 'Crimen y Castigo', 'category': 'Clásico'},
    {'title': 'Los Miserables', 'category': 'Drama'},
  ];

  final List<Map<String, String>> booksSection3 = [
    {'title': 'Título Muy Muy Largo Para Probar', 'category': 'Prueba'},
    {'title': 'Corto', 'category': 'Mini'},
    {'title': 'Título Mediano', 'category': 'Normal'},
    {'title': 'Otro Libro Interesante', 'category': 'Drama'},
    {'title': 'La Última Oportunidad', 'category': 'Suspenso'},
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _handleBookTap(String title, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo: $title ($category)'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBooksRow(List<Map<String, String>> books) {
    return SizedBox(
      height: 240, // Altura fija para el contenedor del scroll horizontal
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 12.0,
              right: index == books.length - 1 ? 12.0 : 0,
            ),
            child: BookImage(
              title: book['title'] ?? 'Título',
              category: book['category'] ?? 'Comedia',
              imageUrl: 'https://placehold.co/150x200',
              onTap: () => _handleBookTap(
                book['title'] ?? 'Título',
                book['category'] ?? 'Comedia',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 184,
        height: 34,
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
        child: Center(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Círculos decorativos morados de fondo
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120), // Espacio para TopBar

                  // Primera sección
                  _buildCategoryHeader('Nuevas publicaciones'),
                  _buildBooksRow(booksSection1),
                  
                  const SizedBox(height: 20),

                  // Segunda sección
                  _buildCategoryHeader('Recomendados para ti'),
                  _buildBooksRow(booksSection2),
                  
                  const SizedBox(height: 20),

                  // Tercera sección
                  _buildCategoryHeader('Tendencias'),
                  _buildBooksRow(booksSection3),
                  
                  const SizedBox(height: 100), // Espacio para NavigationBar
                ],
              ),
            ),
          ),

          // TopBar
          const CustomTopBar(),

          // NavigationBar
          const CustomNavigationBar(),
        ],
      ),
    );
  }
}