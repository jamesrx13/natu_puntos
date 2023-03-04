// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:natu_puntos/models/empresa_model.dart';
import 'package:natu_puntos/widgets/card_container.dart';
import 'package:natu_puntos/widgets/gradiend_bg.dart';

class EmpresasPage extends StatefulWidget {
  final EmpresaModel empresa;
  const EmpresasPage({Key? key, required this.empresa}) : super(key: key);

  @override
  State<EmpresasPage> createState() => _EmpresasPageState();
}

class _EmpresasPageState extends State<EmpresasPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    const TextStyle infoStyle = TextStyle(
      fontSize: 20.0,
    );
    Completer<GoogleMapController> _controller = Completer();
    LatLng initialPosition = LatLng(
      double.parse(widget.empresa.latitude),
      double.parse(widget.empresa.longitude),
    );
    final CameraPosition _kGooglePlex = CameraPosition(
      target: initialPosition,
      zoom: 16.0,
    );
    Map<MarkerId, Marker> _marker = {};
    final markerId = MarkerId(widget.empresa.id);
    final marcador = Marker(markerId: markerId, position: initialPosition);
    _marker[markerId] = marcador;
    return Scaffold(
      body: Stack(
        children: [
          GradientBG(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          radius: 23.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Center(
                      child: Text(
                        widget.empresa.name,
                        style: const TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: size.height * .88,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: size.height * .3,
                            width: size.width * .6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: widget.empresa.img != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'lib/assets/img/loading.png',
                                      image: widget.empresa.img,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    'lib/assets/img/loading.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        _divider(),
                        _target('Información'),
                        CardContainer(
                          child: SizedBox(
                            height: size.height * .3,
                            child: ListView(
                              children: [
                                ListTile(
                                  title: Text(
                                    widget.empresa.name,
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.work),
                                ),
                                ListTile(
                                  title: Text(
                                    widget.empresa.address,
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.location_city),
                                ),
                                ListTile(
                                  title: Text(
                                    '${widget.empresa.departament} - ${widget.empresa.city}',
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.map_rounded),
                                ),
                                ListTile(
                                  title: Text(
                                    widget.empresa.email,
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.email),
                                ),
                                ListTile(
                                  title: Text(
                                    widget.empresa.nit,
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.numbers),
                                ),
                                ListTile(
                                  title: Text(
                                    widget.empresa.phone,
                                    style: infoStyle,
                                  ),
                                  leading: const Icon(Icons.phone),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _divider(),
                        _target('Mapa'),
                        CardContainer(
                          child: SizedBox(
                            height: size.height * .4,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: _marker.values.toSet(),
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                        ),
                        _divider(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const SizedBox(
      height: 15.0,
    );
  }

  Widget _target(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
