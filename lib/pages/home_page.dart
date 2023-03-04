// ignore_for_file: use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/views/empresas_view.dart';
import 'package:natu_puntos/views/home_view.dart';
import 'package:natu_puntos/views/profile_view.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = [
    const Icon(Icons.work),
    const Icon(Icons.home),
    const Icon(Icons.person),
  ];
  int index = 1;
  final view = [
    const EmpresasView(),
    const HomeView(),
    const ProfileView(),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _transferAlert());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          GradientBG(),
          view[index],
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        backgroundColor: Colors.transparent,
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }

  _transferAlert() {
    Size size = MediaQuery.of(context).size;
    FirebaseDatabase.instance
        .ref('transfer')
        .orderByChild('clientId')
        .equalTo(currentUser.id)
        .onValue
        .listen(
      (event) {
        for (var element in event.snapshot.children) {
          if (!(element.child('status').value as bool)) {
            String empresaName = element.child('empresaName').value.toString();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                content: SizedBox(
                  height: size.height * .3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              empresaName,
                              style: const TextStyle(fontSize: 30.0),
                            ),
                            const SizedBox(height: 15.0),
                            const Text(
                              'Puntos a cambiar:',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              element.child('points').value.toString(),
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (_) => const PogressDialig(
                                      status: 'Cargando...'),
                                );
                                DatabaseReference userRef = FirebaseDatabase
                                    .instance
                                    .ref('users/${currentUser.id}');
                                //
                                DatabaseReference empresaRef =
                                    FirebaseDatabase.instance.ref(
                                        'empresas/${element.child('empresaId').value}');
                                //
                                DataSnapshot currentPoints =
                                    await userRef.child('points').get();
                                int changePoints = int.parse(
                                    element.child('points').value.toString());
                                if (int.parse(currentPoints.value.toString()) >=
                                    changePoints) {
                                  await userRef.update({
                                    'points': (int.parse(
                                            currentPoints.value.toString()) -
                                        changePoints)
                                  });
                                  DataSnapshot empresaData =
                                      await empresaRef.get();
                                  int empresaCurrentPoints =
                                      empresaData.child('points').exists
                                          ? int.parse(empresaData
                                              .child('points')
                                              .value
                                              .toString())
                                          : 0;
                                  int empresaTotalPoints =
                                      empresaData.child('totalpoints').exists
                                          ? int.parse(empresaData
                                              .child('totalpoints')
                                              .value
                                              .toString())
                                          : 0;
                                  await empresaRef.update({
                                    'points':
                                        empresaCurrentPoints + changePoints,
                                    'totalpoints':
                                        empresaTotalPoints + changePoints,
                                  });
                                  await FirebaseDatabase.instance
                                      .ref('transfer/${element.key}')
                                      .update({'status': true});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  AllToast.showDangerousToast(context,
                                      'Oh, Oh...', 'Inconcluencia de puntos');
                                }
                              },
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await FirebaseDatabase.instance
                                    .ref('transfer/${element.key}')
                                    .remove();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Rechazar',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.redAccent,
                                ),
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
        }
      },
    );
  }
}
