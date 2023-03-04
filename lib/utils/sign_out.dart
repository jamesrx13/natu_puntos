import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';

class SignOut {
  static void closeSession(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => const PogressDialig(
                  status: 'Cerrando sesión',
                ),
              );
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'start', (route) => false);
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
        title: const Text('¿Está seguro de cerrar sesión?'),
      ),
    );
  }
}
