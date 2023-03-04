// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:natu_puntos/models/empresa_model.dart';
import 'package:natu_puntos/models/user_model.dart';

const GLOBAL_COLOR = Color.fromRGBO(95, 220, 18, .94);

UserModel currentUser = UserModel(
  id: '',
  code: '',
  departamento: '',
  municipio: '',
  name: '',
  phone: '',
  phoneToken: '',
);

EmpresaModel userEmpresa = EmpresaModel(
  id: '',
  address: '',
  name: '',
  city: '',
  departament: '',
  email: '',
  nit: '',
  phone: '',
  latitude: '',
  longitude: '',
  img: '',
  phoneToken: '',
);
