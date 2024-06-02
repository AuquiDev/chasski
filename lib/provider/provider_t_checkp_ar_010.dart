// ignore_for_file: avoid_print


import 'package:chasski/models/model_check_points.dart';
import 'package:chasski/poketbase/t_check_p_arp010.dart';
// import 'package:chasski/poketbase/t_check_p_arp09.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckP010Provider with ChangeNotifier {
  List<TCheckPointsModel> listAsistencia = [];

  TCheckP010Provider() {
    print('CheckAR00 Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TCheckPointsModel> get e => listAsistencia;

  void addAsistencia(TCheckPointsModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TCheckPointsModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TCheckPointsModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TCheckPoitns_AR010.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TCheckPointsModel ubicaciones =  TCheckPointsModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckPoints, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal }) async {
    isSyncing = true;
    notifyListeners();
    TCheckPointsModel data = TCheckPointsModel(
        id: '',
        idCorredor: idCorredor!,
        idCheckPoints: idCheckPoints!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!
        );

    await TCheckPoitns_AR010.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckPoints, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal  }) async {
    isSyncing = true;
    notifyListeners();
    TCheckPointsModel data = TCheckPointsModel(
        id: id!,
        idCorredor: idCorredor!,
        idCheckPoints: idCheckPoints!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!);

    await TCheckPoitns_AR010.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TCheckPoitns_AR010.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TCheckPointsModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idCorredor: e.idCorredor,
        idCheckPoints: e.idCheckPoints,
        fecha: e.fecha,
        estado: e.estado,
        nombre: e.nombre,
        dorsal: e.dorsal
      );
      print('POST ASISTENCIA API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idCorredor: e.idCorredor,
        idCheckPoints: e.idCheckPoints,
        fecha: e.fecha,
        estado: e.estado,
        nombre: e.nombre,
        dorsal: e.dorsal
      );
      print('PUT ASISTENCIA API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_chpr_10_punto').subscribe('*', (e) {
      print('REALTIME CHECK0 ${e.action}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TCheckPointsModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TCheckPointsModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TCheckPointsModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
