import 'package:flutter/material.dart';
import 'package:natu_puntos/utils/const_utils.dart';
import 'package:natu_puntos/utils/sign_out.dart';
import 'package:natu_puntos/widgets/card_container.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
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
            Center(
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
                    child: Image.asset('lib/assets/img/loading.png'),
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
                                  currentUser.name,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              _divider(),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: Text(
                                  currentUser.phone,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              _divider(),
                              ListTile(
                                leading: const Icon(Icons.keyboard),
                                title: Text(
                                  currentUser.code,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              _divider(),
                              ListTile(
                                leading: const Icon(Icons.map),
                                title: Text(
                                  '${currentUser.municipio.replaceAll('%', ' ')} - ${currentUser.departamento.replaceAll('%', ' ')}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(
      height: 15.0,
    );
  }
}
