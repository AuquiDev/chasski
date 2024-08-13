import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:chasski/models/check%20list/model_list_check_list_ar.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/provider/cache/runner/provider_cache_participantes.dart';
import 'package:chasski/provider/runners/online/provider_t_participantes.dart';
import 'package:chasski/provider/check%20list/provider_cl02.dart';
import 'package:chasski/provider/check%20list/provider__t_list_cheklist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/provider/distancia/provider_t_distancias_ar.dart';
import 'package:chasski/provider/evento/provider_t_evento_ar.dart';

class RunnerData {
  static ParticipantesModel getRunner(BuildContext context) {
    ParticipantesModel? user =
        Provider.of<CacheParticpantesProvider>(context).usuarioEncontrado!;
    final loginProvider =
        Provider.of<TParticipantesProvider>(context).listaRunner;

    return loginProvider.firstWhere(
      (e) => e.id == user.id,
      orElse: () => participantesModelDefault(),
    );
  }

  static TDistanciasModel getDistance(
      BuildContext context, ParticipantesModel runner) {
    final distanProvider =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    return distanProvider.firstWhere(
      (d) => d.id == runner.idDistancia,
      orElse: () => distanciasDefault(),
    );
  }

  static TEventoModel getEvent(
      BuildContext context, ParticipantesModel runner) {
    final eventProvider = Provider.of<TEventoArProvider>(context).listDistancia;

    return eventProvider.firstWhere(
      (e) => e.id == runner.idEvento,
      orElse: () => eventdefault(),
    );
  }

  static TChekListmodel02File getCheckDeslinde(
      BuildContext context, ParticipantesModel runner) {
    // final cache = Provider.of<RunnerProvider>(context);
    // TRunnersModel? user = cache.usuarioEncontrado;

    final listcheckL =
        Provider.of<TListCheckListProvider>(context).listAsistencia;
    //Buscamos segun el orden el que tenga Orden 1 en la lista de Checklist,
    //El orden 1 se refeire al Doc Deslinde comfigurado en el servidor.
    TListChekListModel check = listcheckL.firstWhere((e) => e.orden == 2,
        orElse: () => checkListDefault());
    //Ahora llamamos al CheckList Deslinde
    final deslindeProvider = Provider.of<TCheckList02Provider>(context);

    //SI el USURIO ESTA REGISTRADO: Encontramos el id del correcdor, si ya esta registrado devolvemos null.
    TChekListmodel02File docUser = deslindeProvider.listAsistencia
        .firstWhere((doc) => doc.idCorredor == (runner.id ?? ''), //user.id;
            orElse: () => chekListDocDefault());

    TChekListmodel02File e = TChekListmodel02File(
        id: (docUser.id == null) ? '' : docUser.id,
        idCorredor: runner.id ?? '', //user.id;
        idCheckList: check.id ?? '',
        fileUrl: '',
        fecha: DateTime.now(),
        estado: docUser
            .estado, //EL estado controla la visivilidad de Crear o Editar.
        detalles: '',
        nombre: runner.nombre.toString(),
        dorsal: runner.dorsal.toString(),
        collectionId: docUser.collectionId.toString(),
        file: docUser.file,
        deslinde: docUser.deslinde);

    return e;
  }
}
