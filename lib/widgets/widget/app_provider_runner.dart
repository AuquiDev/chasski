import 'package:chasski/models/model_check_list_2file.dart';
import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:chasski/provider/provider_t_checklist_02.dart';
import 'package:chasski/provider/provider_t_list_check_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chasski/models/model_distancias_ar.dart';
import 'package:chasski/models/model_evento.dart';
import 'package:chasski/models/model_runners_ar.dart';
import 'package:chasski/provider/provider_t_distancias_ar.dart';
import 'package:chasski/provider/provider_t_evento_ar.dart';
import 'package:chasski/provider/provider_t_runners_ar.dart';
import 'package:chasski/provider_cache/provider_runner.dart';

class RunnerData {
  static TRunnersModel getRunner(BuildContext context) {
    TRunnersModel? user =
        Provider.of<RunnerProvider>(context).usuarioEncontrado!;
    final loginProvider = Provider.of<TRunnersProvider>(context).listaRunner;

    return loginProvider.firstWhere(
      (e) => e.id == user.id,
      orElse: () => defaultRunner(),
    );
  }

  static TDistanciasModel getDistance(
      BuildContext context, TRunnersModel runner) {
    final distanProvider =
        Provider.of<TDistanciasArProvider>(context).listAsistencia;

    return distanProvider.firstWhere(
      (d) => d.id == runner.idDistancia,
      orElse: () => distanciasDefault(),
    );
  }

  static TEventoModel getEvent(BuildContext context, TRunnersModel runner) {
    final eventProvider = Provider.of<TEventoArProvider>(context).listDistancia;

    return eventProvider.firstWhere(
      (e) => e.id == runner.idEvento,
      orElse: () => eventdefault(),
    );
  }

  static TChekListmodel02File getCheckDeslinde(
      BuildContext context, TRunnersModel runner) {
    // final cache = Provider.of<RunnerProvider>(context);
    // TRunnersModel? user = cache.usuarioEncontrado;

    final listcheckL =
        Provider.of<TListCheckListProvider>(context).listAsistencia;
    //Buscamos segun el orden el que tenga Orden 1 en la lista de Checklist,
    //El orden 1 se refeire al Doc Deslinde comfigurado en el servidor.
    TListChekListModel check = listcheckL.firstWhere((e) => e.orden == 1,
        orElse: () => checkListDefault());
    //Ahora llamamos al CheckList Deslinde
    final deslindeProvider = Provider.of<TCheckList02Provider>(context);

    //SI el USURIO ESTA REGISTRADO: Encontramos el id del correcdor, si ya esta registrado devolvemos null.
    TChekListmodel02File docUser = deslindeProvider.listAsistencia
        .firstWhere((doc) => doc.idCorredor == runner.id!, //user.id;
            orElse: () => chekListDocDefault());

    TChekListmodel02File e = TChekListmodel02File(
        id: (docUser.id == null) ? '' : docUser.id,
        idCorredor: runner.id!, //user.id;
        idCheckList: check.id!,
        fileUrl: '',
        fecha: DateTime.now(),
        estado: docUser.estado,//EL estado controla la visivilidad de Crear o Editar.
        detalles: 'detallesController',
        nombre: runner.nombre,
        dorsal: runner.dorsal, 
        collectionId: docUser.collectionId,
        file: docUser.file, 
        deslinde: docUser.deslinde);

    return e;
  }
}
