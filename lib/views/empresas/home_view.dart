import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/curve_home.dart';

class EmpresaHomeView extends StatefulWidget {
  const EmpresaHomeView({Key? key}) : super(key: key);

  @override
  State<EmpresaHomeView> createState() => _EmpresaHomeViewState();
}

class _EmpresaHomeViewState extends State<EmpresaHomeView> {
  String points = '0';
  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('empresas/${userEmpresa.id}')
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
                  child: Column(
                    children: [
                      SizedBox(height: size.height * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userEmpresa.name,
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
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
          ),
        ],
      ),
    );
  }
}
