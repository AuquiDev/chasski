// ignore_for_file: avoid_print

import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:chasski/poketbase/t_list_check_list_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckListProvider with ChangeNotifier {
  List<TListChekListModel> listAsistencia = [];

  TListCheckListProvider() {
    print('RUNNERS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TListChekListModel> get e => listAsistencia;

  void addAsistencia(TListChekListModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TListChekListModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TListChekListModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TListCheckList_AR.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TListChekListModel ubicaciones =  TListChekListModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? ubicacion,
    String? nombre,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura,
    DateTime? horaCierre,
    bool? estatus,
   String? itemsList }) async {
    isSyncing = true;
    notifyListeners();
    TListChekListModel data = TListChekListModel(
        id: '',
      idEvento: idEvento!,
      ubicacion: ubicacion!,
      nombre: nombre!,
      descripcion: descripcion!,
      // elevacion: elevacion!,
      orden: orden!,
      horaApertura: horaApertura!,
      horaCierre: horaCierre!,
      estatus: estatus!,
      // itemsList: itemsList!
      // personal: 
      
        );

    await TListCheckList_AR.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? ubicacion,
    String? nombre,
    String? descripcion,
    String? elevacion,
    int? orden,
    DateTime? horaApertura,
    DateTime? horaCierre,
    bool? estatus,
   String? itemsList }) async {
    isSyncing = true;
    notifyListeners();
    TListChekListModel data = TListChekListModel(
        id: id!,
      idEvento: idEvento!,
      ubicacion: ubicacion!,
      nombre: nombre!,
      descripcion: descripcion!,
      // elevacion: elevacion!,
      orden: orden!,
      horaApertura: horaApertura!,
      horaCierre: horaCierre!,
      estatus: estatus!,
      // itemsList: itemsList!
      );

    await TListCheckList_AR.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TListCheckList_AR.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TListChekListModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEvento: e.idEvento,
      ubicacion: e.ubicacion,
      nombre: e.nombre,
      descripcion: e.descripcion,
      // elevacion: e.elevacion,
      orden: e.orden,
      horaApertura: e.horaApertura,
      horaCierre: e.horaCierre,
      estatus: e.estatus,
      // itemsList: e.itemsList
      );
      print('POST RUNNERS API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
         idEvento: e.idEvento,
      ubicacion: e.ubicacion,
      nombre: e.nombre,
      descripcion: e.descripcion,
      // elevacion: e.elevacion,
      orden: e.orden,
      horaApertura: e.horaApertura,
      horaCierre: e.horaCierre,
      estatus: e.estatus,
      // itemsList: e.itemsList
      );
      print('PUT RUNNERS API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_check_list').subscribe('*', (e) {
      print('REALTIME Runners ${e.action}');
      print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TListChekListModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TListChekListModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TListChekListModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
