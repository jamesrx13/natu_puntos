import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/models/empresa_model.dart';
import 'package:natu_puntos/models/user_model.dart';
import 'package:natu_puntos/services/push_notification_service.dart';
import 'package:natu_puntos/utils/conectivity_validate.dart';
import 'package:natu_puntos/utils/const_utils.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  _validateSession() async {
    bool hasConecction = await connectivityValidate();
    FirebaseAuth session = FirebaseAuth.instance;
    String phoneToken = await PushNotificationServices.getCellphoneToken();
    if (hasConecction) {
      if (session.currentUser != null) {
        String uuid = session.currentUser!.uid;
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref('users/$uuid');
        DataSnapshot userData = await userRef.get();
        if (userData.exists) {
          userRef.update({'phoneToken': phoneToken}).whenComplete(() {
            currentUser = UserModel(
              id: userData.key.toString(),
              name: userData.child('name').value.toString(),
              phone: userData.child('phone').value.toString(),
              code: userData.child('code').value.toString(),
              departamento: userData.child('departamento').value.toString(),
              municipio: userData.child('municipio').value.toString(),
              phoneToken: userData.child('phoneToken').value.toString(),
            );
            Timer(const Duration(seconds: 2), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'home', (route) => false);
            });
            return;
          });
        }
        DatabaseReference empresaRef =
            FirebaseDatabase.instance.ref('empresas/$uuid');
        DataSnapshot empresaData = await empresaRef.get();
        if (empresaData.exists) {
          empresaRef.update({'phoneToken': phoneToken}).whenComplete(() {
            userEmpresa = EmpresaModel(
              id: empresaData.key.toString(),
              address: empresaData.child('address').value.toString(),
              name: empresaData.child('companyname').value.toString(),
              city: empresaData.child('city').value.toString(),
              departament: empresaData.child('department').value.toString(),
              email: empresaData.child('email').value.toString(),
              nit: empresaData.child('nit').value.toString(),
              phone: empresaData.child('phone').value.toString(),
              latitude: empresaData.child('latitude').value.toString(),
              longitude: empresaData.child('length').value.toString(),
              img: empresaData.child('imgpath').value.toString(),
              phoneToken: empresaData.child('phoneToken').value.toString(),
            );
            Timer(const Duration(seconds: 2), () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'empresaHome', (route) => false);
            });
            return;
          });
        }
      } else {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        });
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Sin conexión a internet!'),
          content: SizedBox(
            height: 150,
            width: 200,
            child: Center(
              child: Icon(
                Icons.signal_cellular_connected_no_internet_0_bar_sharp,
                size: 70,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateSession());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/img/logo.png',
              height: 350,
              width: 350,
            ),
            // const SizedBox(height: 10.0),
            const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: GLOBAL_COLOR,
              ),
            )
          ],
        ),
      ),
    );
  }
}
