// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:chasski/models/sponsor/model_sponsors.dart';
import 'package:chasski/poketbase/sponsor/t_sponsors_ar.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TSponsorsProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'ar_sponsor';

  List<TSponsosModel> listaSponsors = [];

  TSponsorsProvider() {
    debugPrint('$collection_name Inicializado');
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
    List<RecordModel> response =
        await TSponsors.getAsitenciaPk(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TSponsosModel ubicaciones = TSponsosModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
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
    try {
      isSyncing = true;
      notifyListeners();
      TSponsosModel data = TSponsosModel(
        id: '',
        title: title!,
        description: description!,
        link: link!,
        estatus: estatus!,
      );

      await TSponsors.postAsistenciaPk(
              data: data, imagen: image, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      debugPrint("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider(
      {String? id,
      String? title,
      String? description,
      String? link,
      bool? estatus,
      File? image}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TSponsosModel data = TSponsosModel(
        id: id!,
        title: title!,
        description: description!,
        link: link!,
        estatus: estatus!,
      );

      await TSponsors.putAsitneciaPk(
              id: id,
              data: data,
              imagen: image,
              collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
    } catch (e) {
      debugPrint("Ocurrió un error en $collection_name UPDATE: $e");
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
      await TSponsors.deleteAsistentciaPk(
              id: id, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      debugPrint("Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(
      {required TSponsosModel e, File? imagen}) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      debugPrint('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      debugPrint('Error al guardar los datos: $e');
    }
    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(
        id: '',
        title: e.title,
        description: e.description,
        link: e.link,
        estatus: e.estatus,
        image: imagen,
      );
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        title: e.title,
        description: e.description,
        link: e.link,
        estatus: e.estatus,
        image: imagen,
      );
    }
  }

  Future<void> realtime() async {
    await pb.collection('$collection_name').subscribe('*', (e) {
      debugPrint('REALTIME $collection_name -> ${e.action}');
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
          addAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TSponsosModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
