import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/firebase_service.dart' show firebaseMessagingBackgroundHandler;

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

  // Registrar el background handler ANTES de inicializar Firebase
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb && Platform.isAndroid) {
    await ScreenProtector.protectDataLeakageOn();
  }

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
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>? ?? {};
            return ProfileScreen(userId: args['userId']?.toString());
          },
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
