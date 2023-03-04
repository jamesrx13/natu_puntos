import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:natu_puntos/models/empresa_model.dart';
import 'package:natu_puntos/pages/empresas_page.dart';

class EmpresasView extends StatefulWidget {
  const EmpresasView({Key? key}) : super(key: key);

  @override
  State<EmpresasView> createState() => _EmpresasViewState();
}

class _EmpresasViewState extends State<EmpresasView> {
  List<EmpresaModel> empresasList = [];
  Widget toShow = const CircularProgressIndicator();
  _getEmpresasData() async {
    DataSnapshot empresasSnapshot =
        await FirebaseDatabase.instance.ref('empresas/').get();
    if (empresasSnapshot.exists) {
      empresasList.clear();
      for (var empresa in empresasSnapshot.children) {
        EmpresaModel modelTemp = EmpresaModel(
          id: empresa.key.toString(),
          name: empresa.child('companyname').value.toString(),
          address: empresa.child('address').value.toString(),
          city: empresa.child('city').value.toString(),
          departament: empresa.child('department').value.toString(),
          email: empresa.child('email').value.toString(),
          latitude: empresa.child('latitude').value.toString(),
          longitude: empresa.child('length').value.toString(),
          nit: empresa.child('nit').value.toString(),
          phone: empresa.child('phone').value.toString(),
          img: empresa.child('imgpath').exists
              ? empresa.child('imgpath').value.toString()
              : '',
          phoneToken: empresa.child('phoneToken').value.toString(),
        );
        empresasList.add(modelTemp);
      }
    } else {
      toShow = const Text(
        'Sin registros',
        style: TextStyle(
          fontSize: 20.0,
        ),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    _getEmpresasData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: size.height * .03),
              const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    'EMPRESAS ALIADAS',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * .03),
              SizedBox(
                height: size.height * .68,
                child: empresasList.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                        ),
                        itemCount: empresasList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EmpresasPage(
                                    empresa: empresasList[index],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    height: size.height * .16,
                                    child: empresasList[index].img != ''
                                        ? FadeInImage.assetNetwork(
                                            placeholder:
                                                'lib/assets/img/loading.png',
                                            image: empresasList[index].img,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'lib/assets/img/loading.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                Text(
                                  empresasList[index].name,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: toShow,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
