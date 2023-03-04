import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/views/empresas/change_points_view.dart';
import 'package:natu_puntos/views/empresas/home_view.dart';
import 'package:natu_puntos/views/empresas/profile_view.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';

class EmpresaHomePage extends StatefulWidget {
  const EmpresaHomePage({Key? key}) : super(key: key);

  @override
  State<EmpresaHomePage> createState() => _EmpresaHomePageState();
}

class _EmpresaHomePageState extends State<EmpresaHomePage> {
  int index = 0;
  final items = [
    const Icon(Icons.home),
    const Icon(Icons.point_of_sale),
    const Icon(Icons.person),
  ];
  final views = [
    const EmpresaHomeView(),
    const EmpresaChangePoint(),
    const EmpresaProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          GradientBG(),
          views[index],
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
}
