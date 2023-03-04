// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/widgets/action_button.dart';
import 'package:natu_puntos/widgets/card_container.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController resetPass = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _singIn() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Iniciando sesión',
      ),
    );
    try {
      String email = '';
      if (user.text.trim().contains('@')) {
        email = user.text.trim();
      } else {
        email = '${user.text.trim()}@gmail.com';
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.pushNamedAndRemoveUntil(context, 'start', (route) => false);
      } else {
        AllToast.showDangerousToast(context, 'Error', 'Usuario sin datos.');
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showStatusLogin(e.code);
    }
  }

  void _showStatusLogin(String code) {
    switch (code) {
      case 'user-not-found':
        Navigator.pop(context);
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Usuario no encontrado.');
        break;
      case 'wrong-password':
        Navigator.pop(context);
        AllToast.showInfoToast(context, 'Oh, Oh...', 'Contraseña incorrecta.');
        break;
      case 'too-many-requests':
        Navigator.pop(context);
        AllToast.showWarningToast(
            context, 'Oh, Oh...', 'Muchos intentos.\nIntenta en un rato :)');
        break;
      default:
        Navigator.pop(context);
        AllToast.showInfoToast(
            context, 'Oh, Oh...', 'Credenciales desconocidas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            GradientBG(),
            SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/img/logo.png',
                      width: 350.0,
                      height: 350.0,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 320,
                    ),
                    SingleChildScrollView(
                      child: CardContainer(
                        child: Column(
                          children: [
                            Text(
                              'Inicia sesión',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            _campoEmail(),
                            const SizedBox(
                              height: 15.0,
                            ),
                            _campoPassword(),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ActionBtn(
                              content: 'Iniciar',
                              color: GLOBAL_COLOR,
                              onPressed: () {
                                _singIn();
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            TextButton(
                              child:
                                  const Text('¿No tienes cuenta? Regístrate'),
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                            ),
                            TextButton(
                              child: const Text('¿Olvidó su contraseña?'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        'Restablecer contraseña\n(Solo empresas)'),
                                    content: SizedBox(
                                      height: 50.0,
                                      child: Scaffold(
                                        body: _campoResetPass(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Enviar'),
                                        onPressed: () async {
                                          if (resetPass.text.isEmpty) {
                                            AllToast.showInfoToast(
                                                context,
                                                'Oh, Oh...',
                                                'Datos requeridos');
                                            return;
                                          }
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                const PogressDialig(
                                              status: 'Enviando correo',
                                            ),
                                          );
                                          if (resetPass.text.contains('@')) {
                                            try {
                                              await _auth
                                                  .sendPasswordResetEmail(
                                                      email: resetPass.text
                                                          .trim());
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              resetPass.text = '';
                                            } catch (e) {
                                              Navigator.pop(context);
                                              debugPrint('💔💔💔  $e');
                                              AllToast.showDangerousToast(
                                                  context,
                                                  'Error',
                                                  'Correo no encontrado');
                                            }
                                          } else {
                                            AllToast.showDangerousToast(
                                                context,
                                                'Oh, Oh...',
                                                'Correo no válido');
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              top: 20.0,
              child: IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.black54,
                  size: 30.0,
                ),
                onPressed: () {
                  launchUrl(Uri.parse(
                      'https://natupuntos.000webhostapp.com/politicas/politicas_privacidad.html'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoEmail() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Código / Correo',
      icon: const Icon(Icons.keyboard),
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      controller: user,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPassword() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      icon: const Icon(Icons.lock),
      labelText: 'Contraseña',
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: pass,
      onChanged: (text) {},
      obscureText: true,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoResetPass() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      icon: const Icon(Icons.lock),
      labelText: 'Correo',
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: resetPass,
      decoration: decoration,
      style: style,
    );
  }
}
