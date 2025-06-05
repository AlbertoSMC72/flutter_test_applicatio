import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_protector/screen_protector.dart';

// Core imports
import 'core/dependency_injection.dart' as di;

// Feature imports
import 'features/home/presentation/home_view.dart';
import 'features/login/presentation/login_view.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'features/register/presentation/register_view.dart';
import 'features/register/presentation/cubit/register_cubit.dart';
import 'features/test/home.dart';
import 'features/writenBook/presentation/writenBook_view.dart';
import 'features/writenBook/presentation/cubit/books_cubit.dart';
import 'features/jsonPlaceHolder/presentation/pages/post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar dependency injection
  await di.init();
  
  // Proteger la pantalla de capturas y grabaciones
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
      initialRoute: '/Login', // Cambiado para empezar en login
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/Page2':
            return MaterialPageRoute(builder: (_) => PostsPage());
          
          case '/Home':
            return MaterialPageRoute(builder: (_) => HomeScreen());
          
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
          
          case '/Test':
            return MaterialPageRoute(builder: (_) => DemoScreen());
          
          case '/Writening':
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => di.sl<BooksCubit>(),
                child: const UserStoriesScreen(),
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