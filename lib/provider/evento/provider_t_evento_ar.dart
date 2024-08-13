// ignore_for_file: avoid_print

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/poketbase/evento/t_ar_evento.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TEventoArProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'ar_evento';

  List<TEventoModel> listDistancia = [];

  TEventoArProvider() {
    print('$collection_name Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TEventoModel> get e => listDistancia;

  void addAsistencia(TEventoModel e) {
    listDistancia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TEventoModel e) {
    listDistancia[listDistancia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TEventoModel e) {
    listDistancia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response =
        await TEventoAr.getAsitenciaPk(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TEventoModel ubicaciones = TEventoModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? estado,
  }) async {
    try {
      isSyncing = true;
      notifyListeners();
      TEventoModel data = TEventoModel(
        id: '',
        nombre: nombre!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        estatus: estado!,
      );

      await TEventoAr.postAsistenciaPk(
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? estado,
  }) async {
    try {
      isSyncing = true;
      notifyListeners();
      TEventoModel data = TEventoModel(
        id: id!,
        nombre: nombre!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        estatus: estado!,
      );

      await TEventoAr.putAsitneciaPk(
              id: id, data: data, collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name UPDATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  bool isDeleted = false;
  deleteTAsistenciaApp(String id) async {
    isDeleted = true;
    notifyListeners();
    try {
      await TEventoAr.deleteAsistentciaPk(
              id: id, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TEventoModel e) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      print('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      print('Error al guardar los datos: $e');
    }
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        nombre: e.nombre,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estatus,
      );
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        nombre: e.nombre,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estatus,
      );
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
          addAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
