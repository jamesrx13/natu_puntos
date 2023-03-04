// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/utils/sign_out.dart';
import 'package:natu_puntos/widgets/card_container.dart';

class EmpresaProfileView extends StatefulWidget {
  const EmpresaProfileView({Key? key}) : super(key: key);

  @override
  State<EmpresaProfileView> createState() => _EmpresaProfileViewState();
}

class _EmpresaProfileViewState extends State<EmpresaProfileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: size.height * .03),
                    Container(
                      height: size.height * .3,
                      width: size.width * .6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'lib/assets/img/loading.png',
                          image: userEmpresa.img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * .04),
                    SizedBox(
                      width: size.width,
                      height: size.height * .4,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CardContainer(
                            child: ListView(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                    userEmpresa.name,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                _divider(),
                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text(
                                    userEmpresa.phone,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                _divider(),
                                ListTile(
                                  leading: const Icon(Icons.numbers),
                                  title: Text(
                                    userEmpresa.nit,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                _divider(),
                                ListTile(
                                  leading: const Icon(Icons.map),
                                  title: Text(
                                    '${userEmpresa.departament} - ${userEmpresa.city}',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                _divider(),
                                ListTile(
                                  leading: const Icon(Icons.mail),
                                  title: Text(
                                    userEmpresa.email,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => _changePass(),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 25.0,
                              child: Icon(Icons.edit, size: 30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              child: GestureDetector(
                onTap: () {
                  SignOut.closeSession(context);
                },
                child: const CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                    size: 25.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _changePass() {
    TextEditingController currentPass = TextEditingController();
    TextEditingController newPass = TextEditingController();
    TextEditingController comfirPass = TextEditingController();
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          child: const Text('Cambiar'),
          onPressed: () async {
            if (currentPass.text.isEmpty ||
                newPass.text.isEmpty ||
                comfirPass.text.isEmpty) {
              AllToast.showInfoToast(
                  context, 'Oh, Oh...', 'Todos los campos son requeridos!');
              return;
            }
            if (newPass.text.trim() != comfirPass.text.trim()) {
              AllToast.showInfoToast(
                  context, 'Oh, Oh...', 'Las contraseñas no son iguales');
              return;
            }
            if (newPass.text.length <= 5) {
              AllToast.showInfoToast(
                  context, 'Oh, Oh...', 'Contraseña muy corta');
              return;
            }
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => const PogressDialig(status: 'Actualizando...'),
            );
            User? user = FirebaseAuth.instance.currentUser;
            UserCredential reloadUser;
            try {
              reloadUser = await user!.reauthenticateWithCredential(
                EmailAuthProvider.credential(
                  email: userEmpresa.email,
                  password: currentPass.text.trim(),
                ),
              );
            } catch (e) {
              Navigator.pop(context);
              AllToast.showInfoToast(
                  context, 'Oh, Oh...', 'Contraceña incorecta');
              return;
            }
            await reloadUser.user!.updatePassword(newPass.text.trim());
            Navigator.pushNamedAndRemoveUntil(
                context, 'start', (route) => false);
          },
        ),
      ],
      title: const Text('Cambiar contraseña'),
      content: SizedBox(
        height: 230,
        width: 300,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: currentPass,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: _inputDecoration(
                      'Contraseña actual', const Icon(Icons.password)),
                ),
                _divider(),
                TextField(
                  controller: newPass,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: _inputDecoration(
                      'Nueva contraseña', const Icon(Icons.password)),
                ),
                _divider(),
                TextField(
                  controller: comfirPass,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: _inputDecoration(
                      'Confirmar nueva contraseña', const Icon(Icons.password)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, Icon icon) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: label,
      icon: icon,
      labelStyle: const TextStyle(
        fontSize: 16.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 12.0,
        color: Colors.grey,
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(
      height: 15.0,
    );
  }
}
