// ignore_for_file: avoid_print

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/poketbase/t_distancias.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TDistanciasArProvider with ChangeNotifier {
  List<TDistanciasModel> listAsistencia = [];

  TDistanciasArProvider() {
    print('CheckAR00 Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TDistanciasModel> get e => listAsistencia;

  void addAsistencia(TDistanciasModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TDistanciasModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TDistanciasModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TDistanciasAr.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TDistanciasModel ubicaciones =  TDistanciasModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? distancias,String? descripcion,bool? estatus, 
  bool? estado,  String? color  }) async {
    isSyncing = true;
    notifyListeners();
    TDistanciasModel data = TDistanciasModel(
        id: '',
        distancias: distancias!,
        descripcion: descripcion!, 
        estatus: estatus!,
        color: color!
        );

    await TDistanciasAr.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? distancias,String? descripcion,bool? estatus, 
  bool? estado,  String? color  }) async {
    isSyncing = true;
    notifyListeners();
    TDistanciasModel data = TDistanciasModel(
        id: id!,
        distancias: distancias!,
        descripcion: descripcion!, 
        estatus: estatus!,
        color: color!
        );

    await TDistanciasAr.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TDistanciasAr.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TDistanciasModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        distancias: e.distancias,
        descripcion: e.descripcion, 
        estatus: e.estatus,
        color: e.color
      );
      print('POST ASISTENCIA API ${e.distancias} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        distancias: e.distancias,
        descripcion: e.descripcion, 
        estatus: e.estatus,
        color: e.color
      );
      print('PUT ASISTENCIA API ${e.distancias} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_distancias').subscribe('*', (e) {
      print('REALTIME CHECK0 ${e.action}');

      switch (e.action) { 
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
