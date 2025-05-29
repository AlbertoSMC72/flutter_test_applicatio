import 'package:flutter/material.dart';
import 'features/jsonPlaceHolder/presentation/pages/post_page.dart';


//implementar el bloqueo de capturas de pantalla
import 'package:flutter/services.dart';
void main() {
  // Bloquear capturas de pantalla
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIOverlays([]);
  
  // Iniciar la aplicación
  runApp(const MyApp());
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Posts Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const PostsPage(),
    );
  }
}