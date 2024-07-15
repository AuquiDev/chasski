// ignore_for_file: avoid_print

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/poketbase/t_ar_evento.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TEventoArProvider with ChangeNotifier {
  List<TEventoModel> listAsistencia = [];

  TEventoArProvider() {
    print('CheckAR00 Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TEventoModel> get e => listAsistencia;

  void addAsistencia(TEventoModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TEventoModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TEventoModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TEventoAr.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TEventoModel ubicaciones =  TEventoModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? nombre,DateTime? fechaInicio,DateTime? fechaFin, 
  bool? estado,  }) async {
    isSyncing = true;
    notifyListeners();
    TEventoModel data = TEventoModel(
        id: '',
        nombre: nombre!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        estatus: estado!,
        );

    await TEventoAr.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? nombre,DateTime? fechaInicio,DateTime? fechaFin, 
  bool? estado,  }) async {
    isSyncing = true;
    notifyListeners();
    TEventoModel data = TEventoModel(
        id: id!,
        nombre: nombre!,
        fechaInicio: fechaInicio!,
        fechaFin: fechaFin!,
        estatus: estado!,
        );

    await TEventoAr.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TEventoAr.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TEventoModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
         nombre: e.nombre,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estatus,
      );
      print('POST ASISTENCIA API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        nombre: e.nombre,
        fechaInicio: e.fechaInicio,
        fechaFin: e.fechaFin,
        estado: e.estatus,
      );
      print('PUT ASISTENCIA API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_evento').subscribe('*', (e) {
      print('REALTIME CHECK0 ${e.action}');

      switch (e.action) { 
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TEventoModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
