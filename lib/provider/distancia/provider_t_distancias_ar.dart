import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/poketbase/distancia/t_distancias.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TDistanciasArProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'ar_distancias';

  List<TDistanciasModel> listAsistencia = [];

  TDistanciasArProvider() {
    print('$collection_name Inicializado');
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
    List<RecordModel> response =
        await TDistanciasAr.getAsitenciaPk(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      TDistanciasModel ubicaciones = TDistanciasModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider(
      {String? id,
      String? distancias,
      String? descripcion,
      bool? estatus,
      bool? estado,
      String? color,
      String? url}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TDistanciasModel data = TDistanciasModel(
          id: '',
          distancias: distancias!,
          descripcion: descripcion!,
          estatus: estatus!,
          color: color!,
          url: url!);

      await TDistanciasAr.postAsistenciaPk(
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider(
      {String? id,
      String? distancias,
      String? descripcion,
      bool? estatus,
      bool? estado,
      String? color,
      String? url}) async {
    try {
      isSyncing = true;
      notifyListeners();
      TDistanciasModel data = TDistanciasModel(
          id: id!,
          distancias: distancias!,
          descripcion: descripcion!,
          estatus: estatus!,
          color: color!,
          url: url!);

      await TDistanciasAr.putAsitneciaPk(
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
      await TDistanciasAr.deleteAsistentciaPk(
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
  Future<void> saveProductosApp(TDistanciasModel e) async {
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
          distancias: e.distancias,
          descripcion: e.descripcion,
          estatus: e.estatus,
          color: e.color);
    } else {
      await updateTAsistenciaProvider(
          id: e.id,
          distancias: e.distancias,
          descripcion: e.descripcion,
          estatus: e.estatus,
          color: e.color);
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
          addAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TDistanciasModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }
}
