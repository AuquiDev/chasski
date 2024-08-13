import 'dart:async';
import 'dart:convert';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';

import 'package:chasski/provider/runners/sheety/server_sheety.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ParticipantesProviderSheety extends ChangeNotifier {
  //TIPO DE EVENTO SELECCIONADO
  //********** ** *** ** * ** ** * **  ** * * ** * **  */
  TEventoModel _selectedEvent = TEventoModel(
      id: '',
      nombre: '',
      fechaInicio: DateTime.now(),
      fechaFin: DateTime.now(),
      estatus: false);

  TEventoModel get selectedEvent => _selectedEvent;

  void setSelectedEvent(TEventoModel event) {
    _selectedEvent = event;
    notifyListeners();
  }
  //********** ** *** ** * ** ** * **  ** * * ** * **  */

  List<ParticipantesModel> listParticipantes = [];

  ParticipantesProviderSheety() {
    print('ParticipantesDataProvider  Inicializado');
    getRecursosProvider();
  }

  bool isget = false;
  Future<void> getRecursosProvider() async {
    isget = true;
    notifyListeners();
    try {
      Response response =
          await ParticipantesSheety.getShetty(evento: _selectedEvent)
              .timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        // final decodeData = ParticipantesSheety.fromJsonList(response.body);
        final decodeData = ParticipantesSheety.fromJsonList(
            str: response.body, evento: _selectedEvent);

        listParticipantes = decodeData;
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('La solicitud HTTP ha superado el tiempo de espera.');
    } catch (e) {
      print('Error al realizar la solicitud HTTP SHEETY: $e');
    } finally {
      isget = false;
      notifyListeners();
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
      Response response =
          await ParticipantesSheety.putSheety(e: e, evento: _selectedEvent);
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
      Response response =
          await ParticipantesSheety.postSheety(e: e, evento: _selectedEvent);
      if (response.statusCode == 200) {
        final decodeData = json.decode(response.body);
        // e.id = decodeData["$hojaName"]["id"]; //new id
        e.id = decodeData["${_selectedEvent.hojaSheetname}"]["id"]; //new id
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
      Response response = await ParticipantesSheety.deleteSheety(
          id: e.id.toString(), evento: _selectedEvent);
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
