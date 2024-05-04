// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chasski/models/model_t_empleado.dart';
import 'package:chasski/shared%20preferences/shared_global.dart';

class UsuarioProvider extends ChangeNotifier {
  TEmpleadoModel? _usuarioEncontrado;
  // Crear una instancia de SharedPrefencesGlobal
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();

//USUARIO LOGIN

  Future<void> cargarUsuario() async {
    final id = await sharedPrefs.getID();
    final nombre = await sharedPrefs.getNombre();
    final rol = await sharedPrefs.getRol();
    final image = await sharedPrefs.getImage();
    final collectionId = await sharedPrefs.getCollectionID();

    _usuarioEncontrado = TEmpleadoModel(
        id: id,
        estado: true,
        nombre: nombre.toString(),
        apellidoPaterno: '',
        apellidoMaterno: '',
        sexo: '',
        cedula: 0,
        telefono: '',
        contrasena: '',
        imagen: image,
        collectionId: collectionId,
        rol: rol.toString());

    notifyListeners();
  }

  // Obtener el usuario encontrado
  TEmpleadoModel? get usuarioEncontrado => _usuarioEncontrado;

  void setusuarioLogin(TEmpleadoModel usuario) async {
    _usuarioEncontrado = usuario;
    cargarUsuario();
    notifyListeners();
  }

  // Método para limpiar el usuario encontrado
  void limpiarusuarioEncontrado() {
    _usuarioEncontrado = null;
    notifyListeners();
  }

  //TOTAL SUMA ACUMULADO TOTAL DE UNA LISTA PDF: reporte la suma total de una lista pdf.
  double _total = 0;

  double get total => _total;

  void updateTotal(double value) {
    _total = value;
    notifyListeners();
    // Configura un temporizador para restablecer _total a 0 después de 3 segundos
    Timer(const Duration(seconds: 5), () {
      _total = 0;
      notifyListeners();
    });
  }

  //OFFLINE
  //Activar el Modo Offline de Aplicativo: En esta seccion utilziaremos nuestro provider del servidor y provider de sqllite.
  //haremos un condiconal en base al modo offline, si es false, usa del servidor y si es true usa el locla SQLlite
  bool _isOffline = false;

  bool get isOffline {
    // Obtener el futuro de SharedPreferences
    final isOfflineFuture = sharedPrefs.getIsOffline();

    // Esperar a que el futuro se complete y obtener el valor booleano
    isOfflineFuture.then((value) {
      // Asignar el valor del futuro a _isOffline si es diferente de null,
      // de lo contrario, mantener el valor existente de _isOffline
      if (value != null) {
        _isOffline = value;
      }
    });

    // Devolver el valor actual de _isOffline
    return _isOffline;
  }


  Future<void> saveIsOffline(bool value) async {
    _isOffline = value; // Asignar el valor recibido como parámetro
    await sharedPrefs.saveIsOffline(
        value); // Guardar el valor en las preferencias compartidas
    print(_isOffline);
    notifyListeners();
  }

  //MENSAJE DE CONEXION A INTERNET
  String _message = '';

  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    // print(message);
    notifyListeners();
  }

  //DATA PARA SINCRONZIAR : SI existes datos para sincronizar
  bool _sincData = false;

  bool get sincData => _sincData;

  void setSincData(bool value) {
    _sincData = value;
    print(_sincData);
    notifyListeners();
  }

  //Activar Boton o desactivar boton segun haya internet.
  bool _isConnected =
      false; // false indica sin conexión, true indica con conexión

  bool get isConnected => _isConnected;

  void updateConnectionStatus(bool isConnected) {
    _isConnected = isConnected;
    print('ISConetced $_isConnected');
    notifyListeners();
  }
}
