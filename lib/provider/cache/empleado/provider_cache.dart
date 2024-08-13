// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';

class CacheUsuarioProvider extends ChangeNotifier {
  TEmpleadoModel? _usuarioEncontrado;
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  //Se guarda el usuario al Inicar sesion.
  Future<void> cargarUsuario() async {
    TEmpleadoModel empleado = await sharedPrefs.getEmpleado();
    _usuarioEncontrado = empleado;
    notifyListeners();
  }

  // Obtener el usuario encontrado
  TEmpleadoModel? get usuarioEncontrado => _usuarioEncontrado;

}
