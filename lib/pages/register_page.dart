import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/data_departaments.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/widgets/action_button.dart';
import 'package:natu_puntos/widgets/card_container.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cc = TextEditingController();
  TextEditingController pass = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String departamentoValue = '';
  String municipioValue = '';

  TextStyle selectStyle = const TextStyle(
    fontSize: 20.0,
  );

  List<String> _dataLocation(String? departament) {
    List<String> arryToReturn = [];
    if (departament != null) {
      dynamic foundDepartament =
          departaments.where((data) => data['nombre'] == departament);
      foundDepartament = foundDepartament.toList();
      foundDepartament = foundDepartament.first['municipios'];
      arryToReturn = foundDepartament;
    } else {
      for (var element in departaments) {
        arryToReturn.add(element['nombre'].toString());
      }
    }
    return arryToReturn;
  }

  _registerUser(String uuid) {
    FirebaseDatabase.instance.ref('users/$uuid/').set({
      'id': uuid,
      'name': name.text.trim(),
      'phone': phone.text.trim(),
      'departamento': departamentoValue,
      'municipio': municipioValue,
      'code': code.text.trim(),
      'pass': pass.text.trim(),
    }).whenComplete(() {
      _auth.signOut();
      Navigator.pop(context);
      Navigator.pop(context);
    });
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
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          SingleChildScrollView(
                            child: CardContainer(
                              child: Column(
                                children: [
                                  Text(
                                    'Registrate!',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  const SizedBox(height: 30.0),
                                  _campoName(),
                                  const SizedBox(height: 20.0),
                                  _campoPhone(),
                                  const SizedBox(height: 20.0),
                                  // Departamentos
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black45,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: DropdownButton(
                                      iconSize: 30.0,
                                      isExpanded: true,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: _dataLocation(null)
                                          .map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          departamentoValue = value.toString();
                                          municipioValue = '';
                                        });
                                      },
                                      hint: departamentoValue != ''
                                          ? Text(departamentoValue,
                                              style: selectStyle)
                                          : Text('Seleccione un departamento',
                                              style: selectStyle),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  departamentoValue != ''
                                      ? Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 7.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black45,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: DropdownButton(
                                            iconSize: 30.0,
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items:
                                                _dataLocation(departamentoValue)
                                                    .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                municipioValue =
                                                    value.toString();
                                              });
                                            },
                                            hint: municipioValue != ''
                                                ? Text(municipioValue,
                                                    style: selectStyle)
                                                : Text(
                                                    'Seleccione un municipio',
                                                    style: selectStyle),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(height: 20.0),
                                  _campoCode(),
                                  const SizedBox(height: 20.0),
                                  _campoPass(),
                                  const SizedBox(height: 30.0),
                                  ActionBtn(
                                    content: 'Registrar',
                                    color: GLOBAL_COLOR,
                                    onPressed: () async {
                                      bool allComplite = _validate();
                                      if (allComplite) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) => const PogressDialig(
                                            status: 'Registrando',
                                          ),
                                        );
                                        try {
                                          UserCredential userData = await _auth
                                              .createUserWithEmailAndPassword(
                                            email:
                                                '${code.text.trim()}@gmail.com',
                                            password: pass.text.trim(),
                                          );

                                          if (userData.user != null) {
                                            _registerUser(userData.user!.uid);
                                          } else {
                                            _auth.signOut();
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'weak-password') {
                                            Navigator.pop(context);
                                            AllToast.showInfoToast(
                                                context,
                                                'Oh, Oh...',
                                                'Contraseña débil');
                                          } else if (e.code ==
                                              'email-already-in-use') {
                                            Navigator.pop(context);
                                            AllToast.showInfoToast(context,
                                                'oh, Oh...', 'Código en uso');
                                          }
                                        } catch (e) {
                                          Navigator.pop(context);
                                          AllToast.showDangerousToast(context,
                                              'Oh, Oh...', e.toString());
                                        }
                                      } else {
                                        AllToast.showDangerousToast(
                                            context,
                                            'Oh, Oh...',
                                            'Todos los campos son requeridos.');
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _campoName() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Nombre completo',
      icon: const Icon(Icons.person),
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
      controller: name,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPhone() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Télefono',
      icon: const Icon(Icons.phone),
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
      controller: phone,
      keyboardType: TextInputType.phone,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
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
      labelText: 'Código',
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
      keyboardType: TextInputType.visiblePassword,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPass() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Contraseña',
      icon: const Icon(Icons.key),
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
      controller: pass,
      onChanged: (text) {},
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: decoration,
      style: style,
    );
  }

  bool _validate() {
    bool allComplite = true;

    if (name.text.isEmpty) {
      allComplite = false;
    }

    if (phone.text.isEmpty) {
      allComplite = false;
    }

    if (departamentoValue == '') {
      allComplite = false;
    }

    if (municipioValue == '') {
      allComplite = false;
    }

    if (code.text.isEmpty) {
      allComplite = false;
    }

    if (pass.text.isEmpty) {
      allComplite = false;
    }

    return allComplite;
  }
}
