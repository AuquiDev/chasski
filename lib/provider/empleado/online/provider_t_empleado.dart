// ignore_for_file: avoid_print

import 'dart:async';

import 'package:chasski/provider/cache/offlineState/provider_offline_state.dart';
import 'package:chasski/utils/files/assets_play_sound.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/empleado/model_t_empleado.dart';
import 'package:chasski/provider/empleado/offline/provider_sql__empelado.dart';
import 'package:chasski/poketbase/empleado/t_empleado.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class TEmpleadoProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action'; 
 
  //IMPORTANTE
  String collection_name = 'empleados_personal';

  List<TEmpleadoModel> listaEmpleados = [];

  TEmpleadoProvider() {
    print('$collection_name Inicializado');
    getTEmpladoProvider();
    realtime();
  }
  //SET y GETTER
  List<TEmpleadoModel> get e => listaEmpleados;

  void addEmpleado(TEmpleadoModel e) {
    listaEmpleados.add(e);
    notifyListeners();
  }

  void updateTEmpleado(TEmpleadoModel e) {
    listaEmpleados[listaEmpleados.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTEmpleado(TEmpleadoModel e) {
    listaEmpleados.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTEmpladoProvider() async {
    List<RecordModel> response =
        await TEmpleado.getTEmpleado(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TEmpleadoModel productos = TEmpleadoModel.fromJson(e.data);
      addEmpleado(productos);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postEmpleadoProvider(
      {String? id,
      bool? estado,
      String? nombre,
      String? apellidos,
      String? cargo,
      String? sexo,
      int? cedula,
      // String? imagen,
      String? telefono,
      String? contrasena,
      String? rol}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TEmpleadoModel data = TEmpleadoModel(
          id: '',
          estado: estado!,
          nombre: nombre!,
          apellidos: apellidos!,
          cargo: cargo!,
          sexo: sexo!,
          cedula: cedula!,
          telefono: telefono!,
          contrasena: contrasena!,
          rol: rol!);

      await TEmpleado.postEmpleadosApp(
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateEmpleadoProvider(
      {String? id,
      bool? estado,
      String? nombre,
      String? apellidos,
      String? cargo,
      String? sexo,
      int? cedula,
      // String? imagen,
      String? telefono,
      String? contrasena,
      String? rol}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TEmpleadoModel data = TEmpleadoModel(
          id: '',
          estado: estado!,
          nombre: nombre!,
          apellidos: apellidos!,
          cargo: cargo!,
          sexo: sexo!,
          cedula: cedula!,
          telefono: telefono!,
          contrasena: contrasena!,
          rol: rol!);
      await TEmpleado.putEmpleadosApp(
              id: id!, data: data, collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name UPDATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

//METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TEmpleadoModel e) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      print('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      print('Error al guardar los datos: $e');
    }
    if (e.id!.isEmpty) {
      await postEmpleadoProvider(
        id: '',
        estado: e.estado,
        nombre: e.nombre,
        apellidos: e.apellidos,
        cargo: e.cargo,
        sexo: e.sexo,
        cedula: e.cedula,
        telefono: e.telefono,
        contrasena: e.contrasena,
        rol: e.rol,
      );
    } else {
      await updateEmpleadoProvider(
        id: e.id,
        estado: e.estado,
        nombre: e.nombre,
        apellidos: e.apellidos,
        cargo: e.cargo,
        sexo: e.sexo,
        cedula: e.cedula,
        telefono: e.telefono,
        contrasena: e.contrasena,
        rol: e.rol,
      );
    }
  }

  bool isDeleted = false;
  deleteTEmpeladoProvider(String id) async {
    isDeleted = true;
    notifyListeners();
    try {
      await TEmpleado.deleteEmpleadosApp(
              collectionName: collection_name, id: id)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  Future<void> realtime() async {
    await pb.collection('$collection_name').subscribe('*', (e) {
      print('REALTIME $collection_name -> ${e.action}');
      void configureRecordData() {
        e.record!.data['id'] = e.record!.id;
        e.record!.data['created'] = DateTime.parse(e.record!.created);
        e.record!.data['updated'] = DateTime.parse(e.record!.updated);
        e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
        actionRealm = e.action;
        notifyListeners();
      }

      switch (e.action) {
        case 'create':
          configureRecordData();
          addEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTEmpleado(TEmpleadoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

  bool islogin = false;

  //Metodo de Autentificacion
  Future<bool> login(
      {BuildContext? context, int? cedulaDNI, String? password}) async {
    islogin = true;
    notifyListeners();
    // ignore: unused_local_variable
    int userindex = -1;
    try {
      //CONDICIONALOFFLINE aumentamos este codigo para asignar el valor de la listausuarios en modo offline.
      bool isOffline =
          Provider.of<OfflineStateProvider>(context!, listen: false).isOffline;
      final listaEmpeladoSQL =
          Provider.of<DBEmpleadoProvider>(context, listen: false).listsql;
      listaEmpleados = isOffline ? listaEmpeladoSQL : listaEmpleados;
      //Esta bsuqueda devulece un umeor, si el numero estabne en leindex es decir de 0 a mas , si es menor de 0 el usuairo n oexiste.
      userindex = listaEmpleados.indexWhere((e) {
        bool ismath = (e.cedula.toString().toLowerCase() ==
                cedulaDNI.toString().toString() &&
            e.contrasena == password);

        if (ismath) {
          SharedPrefencesGlobal().saveEmpleado(e);
        }
        return ismath;
      });
      //Hacer un sonido si el usuario ha sido en contrado
      if (userindex != -1) {
        SoundUtils.vibrate(); // Realiza una vibración
      }
    } catch (e) {
      userindex = -1;
    }

    // Simular una carga con un temporizador
    await Future.delayed(const Duration(seconds: 2));

    // Lógica de navegación o mensaje de error
    if (userindex != -1) {
      islogin = true;
      notifyListeners();
      // Configurar un temporizador para cambiar islogin a false después de 2 segundos
      Timer(const Duration(seconds: 4), () {
        islogin = false;
        notifyListeners();
      });
      return islogin;
    } else {
      islogin = false;
      notifyListeners();
      return islogin;
    }
  }

  //TODOS CLASIFICACION DE DATOS
  Map<String, List<TEmpleadoModel>> groupByDistance(
      {required List<TEmpleadoModel> listParticipantes,
      required String filename}) {
    Map<String, List<TEmpleadoModel>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estado);
          break;
        case 'sexo':
          value = getField(e.sexo);
          break;
        case 'rol':
          value = getField(e.rol);
          break;
        default:
          value = 'Todos';
      }
      if (!groupedData.containsKey(value)) {
        groupedData[value] = [];
      }
      groupedData[value]?.add(e);
    } // Ordenar las claves y sus listas
    final sortedGroupedData = Map.fromEntries(groupedData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)) // Ordenar por claves
        );
    return sortedGroupedData;
  }

  //SEARCH FILE
  List<TEmpleadoModel> _filteredData = [];
  String _searchText = '';

  List<TEmpleadoModel> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TEmpleadoModel> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombre
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.apellidos
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TEmpleadoModel> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }
}
