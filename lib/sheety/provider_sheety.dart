import 'dart:convert';
import 'package:chasski/sheety/model_participantes.dart';

import 'package:chasski/sheety/server_sheety.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ParticipantesDataProvider extends ChangeNotifier {
  List<ParticipantesModel> listParticipantes = [];

  ParticipantesDataProvider() {
    print('ParticipantesDataProvider  Inicializado');
    getRecursosProvider();
  }

  Future<void> getRecursosProvider() async {
    try {
      Response response = await ParticipantesSheety.getShetty();

      if (response.statusCode == 200) {
        final decodeData = ParticipantesSheety.fromJsonList(response.body);
        listParticipantes = decodeData;
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud HTTP: $e');
    }
  }

  bool isaving = false;

  Future saveOrCreateProduct(ParticipantesModel e) async {
    isaving = true;
    notifyListeners();
    if (e.id == null) {
      await createUSer(e);
    } else {
      await updateUSer(e);
    }
    isaving = false;
    notifyListeners();
  }

  Future<void> updateUSer(ParticipantesModel e) async {
    try {
      Response response = await ParticipantesSheety.putSheety(e: e);
      if (response.statusCode == 200) {
        final index =
            listParticipantes.indexWhere((element) => element.id == e.id);
        listParticipantes[index] = e;
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (error) {
      print('Error al Editar registro: $error');
    }
  }

  Future<void> createUSer(ParticipantesModel e) async {
    try {
      Response response = await ParticipantesSheety.postSheety(e: e);
      if (response.statusCode == 200) {
        final decodeData = json.decode(response.body);
        e.id = decodeData["$hojaName"]["id"]; //new id
        listParticipantes.add(e);
      } else {
        print("Error en la solicitud: ${response.statusCode}");
      }
    } catch (error) {
      print('Error al crear registro: $error');
    }
  }

  Future<void> deleteUser(ParticipantesModel e) async {
    try {
      Response response = 
          await ParticipantesSheety.deleteSheety(id: e.id.toString());
      if (response.statusCode == 200) {
        listParticipantes.removeWhere((user) => user.id == e.id);
        print('Registro eliminado con éxito: ${e.id} ${response.statusCode}');
      } else if (response.statusCode == 202 || response.statusCode == 204) {
        //202 (Accepted): La solicitud fue aceptada pero aún está en proceso.
        //204 (No Content): La solicitud se completó con éxito pero no hay contenido para devolver.
        listParticipantes.removeWhere((user) => user.id == e.id);
        print(
            'El servidor devolvió un código de estado 202 o 204: ${response.statusCode}');
      } else {
        print('Error al eliminar: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al eliminar: $error');
    }
    notifyListeners();
  }
}
