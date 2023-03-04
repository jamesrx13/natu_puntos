// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/const_utils.dart';

class GradientBG extends StatelessWidget {
  Widget? child;
  GradientBG({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                GLOBAL_COLOR,
              ],
            ),
          ),
        ),
        Image.asset(
          'lib/assets/img/sheet_bg.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
