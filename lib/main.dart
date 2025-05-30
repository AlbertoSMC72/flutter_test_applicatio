import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/login/presentation/pages/login.dart';
import 'features/jsonPlaceHolder/presentation/pages/post_page.dart';
import 'package:screen_protector/screen_protector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Proteger la pantalla de capturas y grabaciones
  await ScreenProtector.protectDataLeakageOn();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Segura',
      debugShowCheckedModeBanner: false, // Opcional: quitar banner de debug
      initialRoute: '/Login',
      routes: {
        '/Page2': (context) => PostsPage(),
        '/Login': (context) => LoginPage(),
      },
    );
  }
}