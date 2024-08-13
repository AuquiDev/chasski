// ignore_for_file: avoid_print

import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:flutter/material.dart';

class OfflineStateProvider extends ChangeNotifier {
  
  SharedPrefencesGlobal sharedPrefs = SharedPrefencesGlobal();
  bool _isOffline = false;

  bool get isOffline {
    // Obtener de SharedPreferences
    final isOfflineFuture = sharedPrefs.getIsOffline();
    isOfflineFuture.then((value) {
      // Asignar el valor si es diferente de null,de lo contrario, mantener el valor existente
      if (value != null) {
        _isOffline = value;
      }
    });
    return _isOffline;
  }

  Future<void> saveIsOffline(bool value) async {
    _isOffline = value; 
    // Guardar el valor en las preferencias compartidas
    await sharedPrefs.saveIsOffline(value); 
    print('MODO: $_isOffline');
    notifyListeners();
  }


}