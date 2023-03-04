// ignore_for_file: use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/models/user_model.dart';
import 'package:natu_puntos/services/push_notification_service.dart';
import 'package:natu_puntos/utils/all_toast.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/progress_dialog.dart';
import 'package:natu_puntos/widgets/card_container.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';
import 'package:uuid/uuid.dart';

class EmpresaChangePointsPage extends StatefulWidget {
  final UserModel client;
  final int points;
  const EmpresaChangePointsPage(
      {Key? key, required this.client, required this.points})
      : super(key: key);

  @override
  State<EmpresaChangePointsPage> createState() =>
      _EmpresaChangePointsPageState();
}

class _EmpresaChangePointsPageState extends State<EmpresaChangePointsPage> {
  TextEditingController restPoints = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const TextStyle style = TextStyle(
      fontSize: 22.0,
    );
    return Scaffold(
      body: Stack(
        children: [
          GradientBG(),
          SafeArea(
            child: Center(
              child: CardContainer(
                child: SizedBox(
                  height: size.height * .47,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          widget.client.name,
                          style: const TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.client.code, style: style),
                            Text(widget.client.phone, style: style),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                widget.client.departamento.replaceAll('%', ' '),
                                style: style),
                            Text(widget.client.municipio.replaceAll('%', ' '),
                                style: style),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Puntos: ${widget.points}', style: style),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        _campoPoint(),
                        const SizedBox(height: 30.0),
                        TextButton(
                          onPressed: () async {
                            if (widget.points >=
                                int.parse(restPoints.text.trim())) {
                              showDialog(
                                context: context,
                                builder: (_) => const PogressDialig(
                                  status: 'Haciendo petición',
                                ),
                              );
                              String uuid = const Uuid().v1();
                              await FirebaseDatabase.instance
                                  .ref('transfer/$uuid')
                                  .set({
                                'clientId': widget.client.id,
                                'clientName': widget.client.name,
                                'empresaId': userEmpresa.id,
                                'points': restPoints.text.trim(),
                                'status': false,
                                'date': DateTime.now().toIso8601String(),
                                'empresaName': userEmpresa.name,
                              });
                              PushNotificationServices.sedNotifications(
                                  widget.client.phoneToken,
                                  'Confirmar acción',
                                  '${userEmpresa.name} ha solicitado un cambio de ${restPoints.text.trim()} puntos.');
                              Navigator.pop(context);
                              Navigator.pop(context);
                              AllToast.showSuccessToast(
                                  context, 'Ok', 'Esperando confirmación');
                            } else {
                              AllToast.showDangerousToast(
                                  context, 'Oh. Oh...', 'Puntos insuficientes');
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Cobrar',
                                style: style,
                              ),
                              SizedBox(width: 5.0),
                              Icon(Icons.payment, color: Colors.blue),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _campoPoint() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Cantidad de puntos',
      icon: const Icon(Icons.attach_money),
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
      controller: restPoints,
      keyboardType: TextInputType.number,
      onChanged: (text) {},
      decoration: decoration,
      style: style,
    );
  }
}
