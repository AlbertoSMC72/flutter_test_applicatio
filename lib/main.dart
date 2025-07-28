import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watpato/features/chat/presentation/chat_view.dart';
import '/../../core/services/firebase_service.dart';
import '/../../features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'core/consts/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
import '/../../features/home/presentation/cubit/home_cubit.dart';
import 'features/favBooks/presentation/favBooks_view.dart';
import 'features/favBooks/presentation/cubit/fav_books_cubit.dart';
import 'features/downloadedBooks/presentation/downloaded_books_view.dart';
import 'features/downloadedBooks/presentation/cubit/downloaded_books_cubit.dart';
import 'features/downloadedBooks/domain/usecases/get_downloaded_books_usecase.dart';
import 'features/downloadedBooks/data/repositories/downloaded_books_repository_impl.dart';
import 'core/services/download_service.dart';
import 'features/downloadedBooks/presentation/downloaded_chapters_view.dart';
import 'features/downloadedBooks/presentation/downloaded_chapter_reader_view.dart';
import 'features/downloadedBooks/presentation/cubit/downloaded_chapters_cubit.dart';
import 'features/search/presentation/book_search_view.dart';
import 'features/search/presentation/cubit/book_search_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await di.init();
    debugPrint('✅ Dependencias inicializadas correctamente');
  } catch (e) {
    debugPrint('❌ Error inicializando dependencias: $e');
  }

  // Registrar el background handler ANTES de inicializar Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase inicializado correctamente'); 

    // Inicializar notificaciones
    final firebaseService = di.sl<FirebaseServiceImpl>();
    await firebaseService.requestPermission();
    await firebaseService.initializeNotifications();
    await firebaseService.setupTokenRefreshListener();

    // Obtener y mostrar el token (debug)
    final token = await firebaseService.getFirebaseToken();
    debugPrint('Firebase Messaging Token: $token');
  } catch (e) {
    debugPrint('❌ Error inicializando Firebase: $e');
    // Continuar con la aplicación incluso si Firebase falla
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          name: 'Login',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<LoginCubit>(),
                child: const LoginScreen(),
              ),
        ),
        GoRoute(
          path: '/register',
          name: 'Register',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<RegisterCubit>(),
                child: const RegisterScreen(),
              ),
        ),
        GoRoute(
          path: '/home',
          name: 'Home',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<HomeCubit>(),
                child: const HomeScreen(),
              ),
        ),
        GoRoute(
          path: '/writening',
          name: 'Writening',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<BooksCubit>(),
                child: const UserStoriesScreen(),
              ),
        ),
        GoRoute(
          path: '/favorites',
          name: 'Favorites',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<FavBooksCubit>(),
                child: const FavBooksScreen(),
              ),
        ),
        GoRoute(
          path: '/downloaded',
          name: 'DownloadedBooks',
          builder: (context, state) => BlocProvider(
            create: (context) => DownloadedBooksCubit(
              GetDownloadedBooksUseCase(
                DownloadedBooksRepositoryImpl(DownloadService()),
              ),
            ),
            child: const DownloadedBooksView(),
          ),
        ),
        GoRoute(
          path: '/downloadedChapters',
          name: 'DownloadedChapters',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            return BlocProvider(
              create: (context) => di.sl<DownloadedChaptersCubit>()..loadDownloadedChapters(args['bookId'] ?? ''),
              child: DownloadedChaptersView(
                bookId: args['bookId'] ?? '',
                bookTitle: args['bookTitle'] ?? '',
              ),
            );
          },
        ),
        GoRoute(
          path: '/downloadedChapterReader',
          name: 'DownloadedChapterReader',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            return DownloadedChapterReaderView(
              chapterId: args['chapterId'] ?? '',
              bookTitle: args['bookTitle'] ?? '',
            );
          },
        ),
        GoRoute(
          path: '/bookDetail',
          name: 'BookDetail',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            return BookDetailScreen(
              bookId: args['bookId']?.toString() ?? '0',
            );
          },
        ),
        GoRoute(
          path: '/chapterReader',
          name: 'ChapterReader',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            return ChapterReaderScreen(
              chapterId: args['chapterId']?.toString() ?? '1',
              bookTitle: args['bookTitle']?.toString() ?? 'Libro desconocido',
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'Profile',
          builder:
              (context, state) => BlocProvider(
                create: (context) => di.sl<ProfileCubit>(),
                child: Builder(
                  builder: (context) {
                    final args = state.extra as Map<String, dynamic>? ?? {};
                    return ProfileScreen(userId: args['userId']?.toString() ?? '');
                  },
                ),
              ),
        ),
        GoRoute(
          path: '/search',
          name: 'BookSearch',
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<BookSearchCubit>(),
            child: const BookSearchView(),
          ),
        ),
        GoRoute(
          path: '/chat',
          name: 'Chat',
          builder: (context, state) => const ChatComingSoonView()
        ),
      ],
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(child: Text('Ruta no encontrada: ${state.uri.path}')),
          ),
    );

    return MaterialApp.router(
      title: 'Watpato',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
