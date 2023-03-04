import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/curve_home.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String points = '0';

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('users/${currentUser.id}')
        .child('points')
        .onValue
        .listen((event) {
      setState(() {
        points = event.snapshot.exists ? event.snapshot.value.toString() : '0';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Colors.white70,
                height: size.height * .5,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Colors.white70,
              height: size.height * .48,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Opacity(
                        opacity: 0.5,
                        child: CircleAvatar(
                          backgroundColor: GLOBAL_COLOR,
                          radius: 35.0,
                          child: Icon(
                            Icons.person,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          DataSnapshot adminPhoneSnapshot =
                              await FirebaseDatabase.instance
                                  .ref('config/adminPhone')
                                  .get();
                          String adminPhone =
                              adminPhoneSnapshot.value.toString();
                          showDialog(
                            context: context,
                            builder: (_) => _showInfoApp(adminPhone),
                          );
                        },
                        icon: const Icon(
                          Icons.info,
                          size: 30.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hola, ${currentUser.name}',
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Puntos: $points',
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showInfoApp(String adminPhone) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Aceptar'),
        ),
      ],
      content: SizedBox(
        height: 220,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Para mayor información o cambio en los registros de sus datos, por favor comunicarse con el administrador.',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: const [
                  Text(
                    'Admin: ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Andrés Gonzaléz',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Télefono: ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    adminPhone,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
