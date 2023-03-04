// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/models/user_model.dart';
import 'package:natu_puntos/pages/empresa/change_points.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/widgets/card_container.dart';

class EmpresaChangePoint extends StatefulWidget {
  const EmpresaChangePoint({Key? key}) : super(key: key);

  @override
  State<EmpresaChangePoint> createState() => _EmpresaChangePointState();
}

class _EmpresaChangePointState extends State<EmpresaChangePoint> {
  TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          height: size.height * .4,
          child: CardContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Código', style: TextStyle(fontSize: 25.0)),
                const SizedBox(height: 20.0),
                _campoCode(),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (code.text.isNotEmpty) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) =>
                                const PogressDialig(status: 'Buscando...'),
                          );
                          DataSnapshot client = await FirebaseDatabase.instance
                              .ref('users/')
                              .orderByChild('code')
                              .equalTo(code.text.trim())
                              .get();
                          if (client.exists) {
                            UserModel cliendFound = UserModel(
                              id: client.children.first.key.toString(),
                              name: client.children.first
                                  .child('name')
                                  .value
                                  .toString(),
                              code: client.children.first
                                  .child('code')
                                  .value
                                  .toString(),
                              departamento: client.children.first
                                  .child('departamento')
                                  .value
                                  .toString(),
                              municipio: client.children.first
                                  .child('municipio')
                                  .value
                                  .toString(),
                              phone: client.children.first
                                  .child('phone')
                                  .value
                                  .toString(),
                              phoneToken: client.children.first
                                  .child('phoneToken')
                                  .value
                                  .toString(),
                            );
                            code.text = '';
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EmpresaChangePointsPage(
                                  client: cliendFound,
                                  points: client.children.first
                                          .child('points')
                                          .exists
                                      ? int.parse(client.children.first
                                          .child('points')
                                          .value
                                          .toString())
                                      : 0,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            AllToast.showDangerousToast(
                                context, 'Oh, Oh...', 'Cliente no encontrado');
                          }
                        } else {
                          AllToast.showWarningToast(
                              context, 'Oh, Oh...', 'Código requerido!');
                        }
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Buscar',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(width: 5.0),
                          Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoCode() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Código del cliente',
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
      controller: code,
      keyboardType: TextInputType.number,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
    );
  }
}
