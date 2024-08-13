import 'dart:async';
import 'dart:io';

import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/poketbase/check%20list/t_check_list_02.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckList02Provider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //IMPORTANTE
  String collection_name = 'ar_chl_2_documentos';

  List<TChekListmodel02File> listAsistencia = [];

  TCheckList02Provider() {
    print('$collection_name Inicializado');
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
    try {
      List<RecordModel> response =
          await TChecklist_02.getAsitenciaPk(collectionName: collection_name);
      final date = response.map((e) {
        e.data['id'] = e.id;
        e.data['created'] = DateTime.parse(e.created);
        e.data['updated'] = DateTime.parse(e.updated);
        e.data["collectionId"] = e.collectionId;
        e.data["collectionName"] = e.collectionName;
        TChekListmodel02File ubicaciones =
            TChekListmodel02File.fromJson(e.data);
        addAsistencia(ubicaciones);
      }).toList();
      notifyListeners();
      return date;
    } catch (e) {
      //QUEDA PENDIENTE HACER UN TRY CATH para cuando haya
      //un problema con internet o respuesta de la app muestra la lista offline
      print(
          '$collection_name QUEDA PENDIENTE HACER UN TRY CATH para cuando haya un problema con internet o respuesta de la app muestra la lista offline');
    }
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider(BuildContext context,
      {String? id,
      String? idCorredor,
      String? idCheckList,
      DateTime? fecha,
      bool? estado,
      String? nombre,
      String? dorsal,
      String? fileUrl,
      String? detalles,
      File? fileFile,
      File? deslinde}) async {
    try {
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
          detalles: detalles!);
      var startTime = DateTime.now();
      await TChecklist_02.postAsistenciaPk(
              data: data,
              file: fileFile,
              deslinde: deslinde,
              collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime).inSeconds;
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Operación completada en $duration segundos.");
    } catch (e) {
      print("Ocurrió un error en $collection_name CREATE: $e");
      print('***************SAVE DESLINDE ${idCorredor}***********');
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error en $collection_name CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider(BuildContext context,
      {String? id,
      String? idCorredor,
      String? idCheckList,
      DateTime? fecha,
      bool? estado,
      String? nombre,
      String? dorsal,
      String? fileUrl,
      String? detalles,
      File? fileFile,
      File? deslinde}) async {
    try {
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
          detalles: detalles!);
      //Calculamos el tiempo que demora en ejecutarse
      var startTime = DateTime.now();
      await TChecklist_02.putAsitneciaPk(
              id: id,
              data: data,
              imagen: fileFile,
              deslinde: deslinde,
              collectionName: collection_name)
          .timeout(const Duration(seconds: 60));
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime).inSeconds;

      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Operación completada en $duration segundos.");
    } catch (e) {
      print("Ocurrió un error en $collection_name UPDATE: $e");
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error en $collection_name UPDATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  bool isDeleted = false;
  void deleteTAsistenciaApp(BuildContext context, String id) async {
    try {
      await TChecklist_02.deleteAsistentciaPk(
              id: id, collectionName: collection_name)
          .timeout(Duration(milliseconds: 60));

      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message:
              "Se ha borrado este registro de la base de datos correctamente.");
    } catch (e) {
      print("Ocurrió un error en $collection_name DELETE: $e");
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error en $collection_name DELETE: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(BuildContext context,
      {required TChekListmodel02File e, File? fileFile, File? deslinde}) async {
    try {
      // Prueba a imprimir el JSON para ver si se convierte correctamente
      print('JSON Data: ${e.toJson()}');
    } catch (e) {
      // Manejo de errores
      print('Error al guardar los datos: $e');
    }

    if (e.id!.isEmpty) {
      await postTAsistenciaProvider(context,
          id: '',
          idCorredor: e.idCorredor,
          idCheckList: e.idCheckList,
          fecha: e.fecha,
          estado: e.estado,
          nombre: e.nombre,
          dorsal: e.dorsal,
          fileUrl: e.fileUrl,
          detalles: e.detalles,
          //EXTRA
          fileFile: fileFile,
          deslinde: deslinde);
    } else {
      await updateTAsistenciaProvider(context,
          id: e.id,
          idCorredor: e.idCorredor,
          idCheckList: e.idCheckList,
          fecha: e.fecha,
          estado: e.estado,
          nombre: e.nombre,
          dorsal: e.dorsal,
          fileUrl: e.fileUrl,
          detalles: e.detalles,
          //EXTRA
          fileFile: fileFile,
          deslinde: deslinde);
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
          addAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(TChekListmodel02File.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

   //TODOS CLASIFICACION DE DATOS
  Map<String, List<TChekListmodel02File>> groupByDistance(
      {required List<TChekListmodel02File> listParticipantes,
      required String filename}) {
    Map<String, List<TChekListmodel02File>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'estado':
          value = getField(e.estado);
          break;
        case 'idCheckList':
          value = getField(e.idCheckList);
          break;
        case 'Hora marcación':
          value = formatDateTimeForGrouping(e.fecha);
          break;
        case 'updated':
          value = formatDateTimeForGrouping(e.updated!);
          break;
        case 'created':
          value = formatDateTimeForGrouping(e.created!);
          break;
        default:
          value = 'Todos';
      }
      if (!groupedData.containsKey(value)) {
        groupedData[value] = [];
      }
      groupedData[value]?.add(e);
    } // Ordenar las claves y sus listas
    final sortedGroupedData = Map.fromEntries(groupedData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)) // Ordenar por claves
        );
    return sortedGroupedData;
  }

  //SEARCH FILE
  List<TChekListmodel02File> _filteredData = [];
  String _searchText = '';

  List<TChekListmodel02File> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<TChekListmodel02File> listData) {
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.nombre
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.dorsal
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void clearSearch(List<TChekListmodel02File> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }
}


