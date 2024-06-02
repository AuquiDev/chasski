// ignore_for_file: avoid_print


import 'package:chasski/models/model_check_list_1.dart';
import 'package:chasski/poketbase/t_check_list_01.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckList01Provider with ChangeNotifier {
  List<TChekListmodel01> listAsistencia = [];

  TCheckList01Provider() {
    print('CheckAR00 Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TChekListmodel01> get e => listAsistencia;

  void addAsistencia(TChekListmodel01 e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TChekListmodel01 e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TChekListmodel01 e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TChecklist_01.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TChekListmodel01 ubicaciones =  TChekListmodel01.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal }) async {
    isSyncing = true;
    notifyListeners();
    TChekListmodel01 data = TChekListmodel01(
        id: '',
        idCorredor: idCorredor!,
        idCheckList: idCheckList!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!
        );

    await TChecklist_01.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal  }) async {
    isSyncing = true;
    notifyListeners();
    TChekListmodel01 data = TChekListmodel01(
        id: id!,
        idCorredor: idCorredor!,
        idCheckList: idCheckList!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!);

    await TChecklist_01.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TChecklist_01.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TChekListmodel01 e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idCorredor: e.idCorredor,
        idCheckList: e.idCheckList,
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
        idCheckList: e.idCheckList,
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
    await pb.collection('ar_chl_1_charla_informativa').subscribe('*', (e) {
      print('REALTIME CHECK0 ${e.action}');

      switch (e.action) { 
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TChekListmodel01.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
