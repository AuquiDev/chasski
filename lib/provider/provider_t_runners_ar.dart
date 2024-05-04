// ignore_for_file: avoid_print


import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/poketbase/t_runners_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
// import 'package:chaskis/poketbase/t_asistencia.dart';
import 'package:pocketbase/pocketbase.dart';

class TRunnersProvider with ChangeNotifier {
  List<TRunnersModel> listAsistencia = [];

  TRunnersProvider() {
    print('RUNNERS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TRunnersModel> get e => listAsistencia;

  void addAsistencia(TRunnersModel e) {
    listAsistencia.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TRunnersModel e) {
    listAsistencia[listAsistencia.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TRunnersModel e) {
    listAsistencia.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TRunners.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TRunnersModel ubicaciones =  TRunnersModel.fromJson(e.data);
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
    String? idDistancia,
    String? nombre,
    String? apellidos,
    String? dorsal,
    String? pais,
    String? telefono,
    bool? estado,
    String? genero,
    int? numeroDeDocumentos,
    String? tallaDePolo, }) async {
    isSyncing = true;
    notifyListeners();
    TRunnersModel data = TRunnersModel(
        id: '',
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      nombre: nombre!,
      apellidos: apellidos!,
      dorsal: dorsal!,
      pais: pais!,
      telefono: telefono!,
      estado: estado!,
      genero: genero!,
      numeroDeDocumentos: numeroDeDocumentos!,
      tallaDePolo: tallaDePolo!,
        );

    await TRunners.postAsistenciaPk(data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider( {
    String? id,
    String? idEvento,
    String? idDistancia,
    String? nombre,
    String? apellidos,
    String? dorsal,
    String? pais,
    String? telefono,
    bool? estado,
    String? genero,
    int? numeroDeDocumentos,
    String? tallaDePolo, }) async {
    isSyncing = true;
    notifyListeners();
    TRunnersModel data = TRunnersModel(
        id: id!,
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      nombre: nombre!,
      apellidos: apellidos!,
      dorsal: dorsal!,
      pais: pais!,
      telefono: telefono!,
      estado: estado!,
      genero: genero!,
      numeroDeDocumentos: numeroDeDocumentos!,
      tallaDePolo: tallaDePolo!,);

    await TRunners.putAsitneciaPk(id: id, data: data);

    await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TRunners.deleteAsistentciaPk(id);
    notifyListeners();
  }
  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(TRunnersModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        idEvento: e.idEvento,
        idDistancia: e.idDistancia,
        nombre: e.nombre,
        apellidos: e.apellidos,
        dorsal: e.dorsal,
        pais: e.pais,
        telefono: e.telefono,
        estado: e.estado,
        genero: e.genero,
        numeroDeDocumentos: e.numeroDeDocumentos,
        tallaDePolo: e.tallaDePolo,
      );
      print('POST RUNNERS API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idEvento: e.idEvento,
        idDistancia: e.idDistancia,
        nombre: e.nombre,
        apellidos: e.apellidos,
        dorsal: e.dorsal,
        pais: e.pais,
        telefono: e.telefono,
        estado: e.estado,
        genero: e.genero,
        numeroDeDocumentos: e.numeroDeDocumentos,
        tallaDePolo: e.tallaDePolo,
      );
      print('PUT RUNNERS API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_corredores').subscribe('*', (e) {
      print('REALTIME Runners ${e.action}');
      print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TRunnersModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
