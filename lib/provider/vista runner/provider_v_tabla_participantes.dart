// ignore_for_file: avoid_print

import 'package:chasski/models/vista%20runner/model_v_tabla_participantes.dart';
import 'package:chasski/poketbase/vista%20runner/services_v_tabla_participantes.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class VTablaParticipantesProvider with ChangeNotifier {
  List<VTablaPartipantesModel> listaParticipantes = [];

  VTablaParticipantesProvider() {
    print('V Tabla Participantes Provider Inicializado');
    getVtableParticipantes();
  }

  //FUnciones dentro de una clase : get y setter.
  List<VTablaPartipantesModel> get e => listaParticipantes;

  void addVParticipante(VTablaPartipantesModel e) {
    listaParticipantes.add(e);
    notifyListeners();
  }

  Future<void> getVtableParticipantes() async {
    try {
      List<RecordModel> response =
          await VTablaParticipantesServices.get_v_TablaParticipantes()
              .timeout(Duration(seconds: 60));

      for (var e in response) {
        var dataView = VTablaPartipantesModel.fromJson(e.data);
        dataView.setId = e.id;
        dataView.setCollectionId = e.collectionId;
        dataView.setCollectionName = e.collectionName;
        addVParticipante(dataView);
        // print(dataView.nombre);
      }
    } catch (e) {
      print('Error al obtener los datos de la vista particpantes: $e');
    }
    // print('Lista vista particiapntes : ${listaParticipantes.length}');
    notifyListeners();
  }

  bool isSyncing = false;

  // Función para cargar solo los datos que coinciden con el idEvento
  Future<void> getIdEvento(
      {required String idEvento, required BuildContext context}) async {
    listaParticipantes.clear();
    isSyncing = true;
    notifyListeners();
    try {
      List<RecordModel> response =
          await VTablaParticipantesServices.get_v_TablaParticipantes()
              .timeout(Duration(seconds: 60));
      await Future.delayed(Duration(seconds: 1));
      for (var e in response) {
        var dataView = VTablaPartipantesModel.fromJson(e.data);
        dataView.setId = e.id;
        dataView.setCollectionId = e.collectionId;
        dataView.setCollectionName = e.collectionName;
        if (dataView.idEvento == idEvento) {
          addVParticipante(dataView);
          // print(dataView.dorsal);
        }
      }
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'La actualización se ha ejecutado correctamente.',
          title: 'Proceso Concluido');
    } catch (e) {
      AssetAlertDialogPlatform.show(
          context: context,
          message: 'Error al obtener los datos de la vista particpantes: $e',
          title: 'Error');
    } finally {
      isSyncing = false;
      notifyListeners();
    }

    print('Lista vista particiapntes : ${listaParticipantes.length}');
  }
}
