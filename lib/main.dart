import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_protector/screen_protector.dart';

// Core imports
import 'core/dependency_injection.dart' as di;

// Feature imports
import 'features/book/presentation/book_detail_view.dart';
import 'features/contentChapter/presentation/contentChapter_view.dart';
import 'features/home/presentation/home_view.dart';
import 'features/login/presentation/login_view.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'features/profile/presentation/profile_view.dart';
import 'features/register/presentation/register_view.dart';
import 'features/register/presentation/cubit/register_cubit.dart';
import 'features/writenBook/presentation/writenBook_view.dart';
import 'features/writenBook/presentation/cubit/books_cubit.dart';
import 'package:flutter_application_1/features/home/presentation/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();
  
  await ScreenProtector.protectDataLeakageOn();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watpato',
      debugShowCheckedModeBanner: false,
      initialRoute: '/BookDetail',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          
          case '/Home':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<HomeCubit>(),
                child: const HomeScreen(),
              ),
            );
          
          case '/Login':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<LoginCubit>(),
                child: const LoginScreen(),
              ),
            );
          
          case '/Register':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<RegisterCubit>(),
                child: const RegisterScreen(),
              ),
            );
          
          case '/Writening':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<BooksCubit>(),
                child: const UserStoriesScreen(),
              ),
            );

          case '/BookDetail':
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          
          return MaterialPageRoute(
            builder: (_) => BookDetailScreen(
              bookId: args['bookId']?.toString() ?? '0',
              bookTitle: args['bookTitle']?.toString() ?? 'Título Desconocido',
              bookDescription: args['bookDescription']?.toString() ?? 'Sin descripción disponible',
              bookImageUrl: args['bookImageUrl']?.toString() ?? 'https://placehold.co/150x200',
              authorName: args['authorName']?.toString() ?? 'Autor Desconocido',
              genres: args['genres'] is List ? 
                      List<String>.from(args['genres']) : 
                      <String>[],
            ),
          );

          case '/ChapterReader':
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          return MaterialPageRoute(
            builder: (_) => ChapterReaderScreen(
              chapterId: args['chapterId']?.toString() ?? '1',
              bookTitle: args['bookTitle']?.toString() ?? 'Libro desconocido',
            ),
          );

          case '/Profile':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(
                userId: args['userId']?.toString(),
              ),
            );
          
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('Ruta no encontrada: ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}