
import 'dart:async';
import 'dart:io';

import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/poketbase/t_check_list_02.dart';
import 'package:chasski/widgets/assets_dialog.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckList02Provider with ChangeNotifier {
  List<TChekListmodel02File> listAsistencia = [];

  String actionRealm = 'Alert: Error';

  TCheckList02Provider() {
    print('CheckList DOC. Inicializado');
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
      List<RecordModel> response = await TChecklist_02.getAsitenciaPk();
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
              data: data, file: fileFile, deslinde: deslinde)
          .timeout(const Duration(seconds: 60));
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime).inSeconds;
      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message: "Operación completada en $duration segundos.");
    } catch (e) {
      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error: $e");
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
              id: id, data: data, imagen: fileFile, deslinde: deslinde)
          .timeout(const Duration(seconds: 60));
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime).inSeconds;

      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message: "Operación completada en $duration segundos.");
    } catch (e) {
      print(e);
      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  void deleteTAsistenciaApp(BuildContext context, String id) async {
    try {
      await TChecklist_02.deleteAsistentciaPk(id);
      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message:
              "Se ha borrado este registro de la base de datos correctamente.");
    } catch (e) {
      PlatformAlertDialog.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error: $e");
    } finally {
      notifyListeners();
    }
  }

  //METODO PARA POST O UPDATE
  Future<void> saveProductosApp(BuildContext context,
      {TChekListmodel02File? e, File? fileFile, File? deslinde}) async {
    isSyncing = true;
    notifyListeners();
    if (e!.id!.isEmpty) {
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
      print('POST ASISTENCIA API ${e.nombre} ${e.id}');
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
      print('PUT ASISTENCIA API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('ar_chl_2_documentos').subscribe('*', (e) {
      print('REALTIME CHECK DOC ${e.action}');

      // Configura los datos del registro
      void configureRecordData() {
        e.record!.data['id'] = e.record!.id;
        e.record!.data['created'] = DateTime.parse(e.record!.created);
        e.record!.data['updated'] = DateTime.parse(e.record!.updated);
        e.record!.data["collectionId"] = e.record!.collectionId;
        e.record!.data["collectionName"] = e.record!.collectionName;
      }

      // Realiza la acción correspondiente
      void performAction(String actionMessage, Function action) {
        configureRecordData();
        action(TChekListmodel02File.fromJson(e.record!.data));
        actionRealm = actionMessage;
        notifyListeners();
      }

      switch (e.action) {
        case 'create':
          performAction('Registro Exitoso', addAsistencia);
          break;
        case 'update':
          performAction('Editado Correctamente', updateTAsistencia);
          break;
        case 'delete':
          performAction('Eliminado Correctamente', updateTAsistencia);
          break;
        default:
      }
    });
  }
}
