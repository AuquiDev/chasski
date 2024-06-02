// ignore_for_file: avoid_print


import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/poketbase/t_check_list_04.dart';
// import 'package:chasski/poketbase/t_check_list_02.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckList04Provider with ChangeNotifier {
  List<TChekListmodel02File> listAsistencia = [];

  TCheckList04Provider() {
    print('CheckAR00 Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TChekListmodel02File> get e => listAsistencia;

  void addAsistencia(TChekListmodel02File e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TChekListmodel02File e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TChekListmodel02File e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TChecklist_04.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TChekListmodel02File ubicaciones =  TChekListmodel02File.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal,String? fileUrl, String? detalles}) async {
    isSyncing = true;
    notifyListeners();
    TChekListmodel02File data = TChekListmodel02File(
        id: '',
        idCorredor: idCorredor!,
        idCheckList: idCheckList!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!, 
        fileUrl: fileUrl!, 
        detalles:detalles!
        );

    await TChecklist_04.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {String? id, String? idCorredor,String? idCheckList, DateTime? fecha,
  bool? estado, String? nombre, String? dorsal, String? fileUrl, String? detalles  }) async {
    isSyncing = true;
    notifyListeners();
    TChekListmodel02File data = TChekListmodel02File(
        id: id!,
        idCorredor: idCorredor!,
        idCheckList: idCheckList!,
        fecha: fecha!,
        estado: estado!,
        nombre: nombre!,
        dorsal: dorsal!, 
        fileUrl: fileUrl!, 
        detalles:detalles!);

    await TChecklist_04.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TChecklist_04.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TChekListmodel02File e) async {
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
        dorsal: e.dorsal,
        fileUrl: e.fileUrl,
        detalles: e.detalles
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
        dorsal: e.dorsal,
        fileUrl: e.fileUrl,
        detalles: e.detalles
      );
      print('PUT ASISTENCIA API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_chl_4_recepcion_equipaje').subscribe('*', (e) {
      print('REALTIME CHECK0 ${e.action}');

      switch (e.action) { 
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
