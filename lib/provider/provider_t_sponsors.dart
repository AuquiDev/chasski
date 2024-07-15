// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

// import 'package:chasski/models/model_runners_ar.dart';
// import 'package:chasski/poketbase/t_runners_ar.dart';
import 'package:chasski/models/model_sponsors.dart';
import 'package:chasski/poketbase/t_sponsors_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TSponsorsProvider with ChangeNotifier {
  List<TSponsosModel> listaSponsors = [];

  TSponsorsProvider() {
    print('SPONSORS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<TSponsosModel> get e => listaSponsors;

  void addAsistencia(TSponsosModel e) {
    listaSponsors.add(e);
    notifyListeners();
  }

  void updateTAsistencia(TSponsosModel e) {
    listaSponsors[listaSponsors.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(TSponsosModel e) {
    listaSponsors.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TSponsors.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TSponsosModel ubicaciones = TSponsosModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider(
      {String? id,
      String? title,
      String? description,
      String? link,
      bool? estatus,
      File? image}) async {
    isSyncing = true;
    notifyListeners();
    TSponsosModel data = TSponsosModel(
      id: '',
      title: title!,
      description: description!,
      link: link!,
      estatus: estatus!,
    );

    await TSponsors.postAsistenciaPk(data: data, imagen: image)
        .timeout(Duration(seconds: 5));

    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider(
      {String? id,
      String? title,
      String? description,
      String? link,
      bool? estatus,
      File? image}) async {
    isSyncing = true;
    notifyListeners();
    TSponsosModel data = TSponsosModel(
      id: id!,
      title: title!,
      description: description!,
      link: link!,
      estatus: estatus!,
    );

    await TSponsors.putAsitneciaPk(id: id, data: data, imagen: image)
        .timeout(Duration(seconds: 5));

    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TSponsors.deleteAsistentciaPk(id);
    notifyListeners();
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp({TSponsosModel? e, File? imagen}) async {
    isSyncing = true;
    notifyListeners();
    if (e!.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        title: e.title,
        description: e.description,
        link: e.link,
        estatus: e.estatus,
        image: imagen,
      );
      print('POST RUNNERS API ${e.title} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        title: e.title,
        description: e.description,
        link: e.link,
        estatus: e.estatus,
        image: imagen,
      );
      print('PUT RUNNERS API ${e.title} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_sponsor').subscribe('*', (e) {
      print('REALTIME Runners ${e.action}');
      print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
