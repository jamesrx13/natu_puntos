import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natu_puntos/pages/empresa/home_page.dart';
import 'package:natu_puntos/pages/home_page.dart';
import 'package:natu_puntos/pages/login_page.dart';
import 'package:natu_puntos/pages/register_page.dart';
import 'package:natu_puntos/pages/start_page.dart';
import 'package:natu_puntos/pages/test_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        name: 'NatuPuntos',
        options: Platform.isIOS
            ? const FirebaseOptions(
                apiKey: 'AIzaSyCjHvqD0i2w5VpiKrQsMTkHsbAW4SQMu8I',
                appId: '1:944154940336:android:957d132225a52547443c75',
                messagingSenderId: '944154940336',
                projectId: 'natupuntos-1bebf',
                databaseURL:
                    'https://natupuntos-1bebf-default-rtdb.firebaseio.com',
              )
            : const FirebaseOptions(
                apiKey: 'AIzaSyCjHvqD0i2w5VpiKrQsMTkHsbAW4SQMu8I',
                appId: '1:944154940336:android:957d132225a52547443c75',
                messagingSenderId: '944154940336',
                projectId: 'natupuntos-1bebf',
                databaseURL:
                    'https://natupuntos-1bebf-default-rtdb.firebaseio.com',
              ));
  } catch (e) {
    Firebase.app();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colocar la barra de notificaciones transparente
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    // Bloquear la rotación de la aplicación
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      title: 'NatuPuntos',
      initialRoute: 'start',
      routes: {
        'login': (_) => const LoginPage(),
        'register': (_) => const RegisterPage(),
        'start': (_) => const StartPage(),
        'home': (_) => const HomePage(),
        'empresaHome': (_) => const EmpresaHomePage(),
        'test': (_) => const TestPage(),
      },
    );
  }
}
