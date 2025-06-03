import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/home_view.dart';
import 'package:flutter_application_1/features/login/presentation/login_view.dart';
import 'package:flutter_application_1/features/register/presentation/register_view.dart';
import 'package:flutter_application_1/features/test/home.dart';
import 'package:flutter_application_1/features/writenBook/presentation/writenBook_view.dart';
import 'features/jsonPlaceHolder/presentation/pages/post_page.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:flutter/services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenProtector.protectDataLeakageOn();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watpato',
      debugShowCheckedModeBanner: false,
      initialRoute: '/Writening',
      routes: {
        '/Page2': (context) => PostsPage(),
        "/Home": (context) => HomeScreen(),
        '/Login': (context) => LoginScreen(),
        "/Register": (context) => RegisterScreen(),
        "/Test": (context) => DemoScreen(),
        "/Writening": (context) => const UserStoriesScreen(),
      },
    );
  }
}