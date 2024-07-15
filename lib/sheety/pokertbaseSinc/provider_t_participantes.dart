import 'dart:async';
import 'dart:io';

import 'package:chasski/sheety/model_participantes.dart';
import 'package:chasski/sheety/pokertbaseSinc/t_participantes.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TParticipantesProvider with ChangeNotifier {
  List<ParticipantesModel> listaRunner = [];

  TParticipantesProvider() {
    print('RUNNERS SERVICES Inicializado');
    getTAsistenciaApp();
    realtime();
  }

  //SET Y GET
  List<ParticipantesModel> get e => listaRunner;

  void addAsistencia(ParticipantesModel e) {
    listaRunner.add(e);
    notifyListeners();
  }

  void updateTAsistencia(ParticipantesModel e) {
    listaRunner[listaRunner.indexWhere((x) => x.id == e.id)] = e;
    notifyListeners();
  }

  void deleteTAsistencia(ParticipantesModel e) {
    listaRunner.removeWhere((x) => x.id == e.id);
    notifyListeners();
  }

  getTAsistenciaApp() async {
    List<RecordModel> response = await TParticipantesPk.getAsitenciaPk();
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      ParticipantesModel ubicaciones = ParticipantesModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    // print(response);
    notifyListeners();
    return date;
  }

  //METODOS POST
  bool isSyncing = false;
  postTAsistenciaProvider(
      {dynamic id,
      int? idsheety,
      String? idEvento,
      String? idDistancia,
      bool? estado,
      String? dorsal,
      String? contrasena,
      String? date,
      int? key,
      dynamic title,
      dynamic nombre,
      dynamic apellidos,
      dynamic distancias,
      dynamic pais,
      dynamic email,
      dynamic telefono,
      dynamic numeroDeWhatsapp,
      dynamic tallaDePolo,
      dynamic fechaDeNacimiento,
      dynamic documento,
      dynamic numeroDeDocumentos,
      dynamic team,
      dynamic genero,
      dynamic rangoDeEdad,
      dynamic grupoSanguineo,
      dynamic haSidoVacunadoContraElCovid19,
      dynamic alergias,
      dynamic nombreCompleto,
      dynamic parentesco,
      dynamic telefonoPariente,
      dynamic carrerasPrevias,
      dynamic porQueCorresElAndesRace,
      dynamic deCuscoAPartida,
      dynamic deCuscoAOllantaytambo,
      dynamic comoSupisteDeAndesRace,
      File? imagenFile}) async {
    isSyncing = true;
    notifyListeners();
    ParticipantesModel data = ParticipantesModel(
      id: '', //post va vacio
      idsheety: idsheety,
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      estado: estado!,
      dorsal: dorsal!,
      contrasena: contrasena,

      date: date,
      key: key,
      title: title,
      nombre: nombre,
      apellidos: apellidos,
      distancias: distancias,
      pais: pais,
      email: email,
      telefono: telefono,
      numeroDeWhatsapp: numeroDeWhatsapp,
      tallaDePolo: tallaDePolo,
      fechaDeNacimiento: fechaDeNacimiento,
      documento: documento,
      numeroDeDocumentos: numeroDeDocumentos,
      team: team,
      genero: genero,
      rangoDeEdad: rangoDeEdad,
      grupoSanguineo: grupoSanguineo!,
      haSidoVacunadoContraElCovid19: haSidoVacunadoContraElCovid19,
      alergias: alergias,
      nombreCompleto: nombreCompleto,
      parentesco: parentesco,
      telefonoPariente: telefonoPariente,
      carrerasPrevias: carrerasPrevias,
      porQueCorresElAndesRace: porQueCorresElAndesRace,
      deCuscoAPartida: deCuscoAPartida,
      deCuscoAOllantaytambo: deCuscoAOllantaytambo,
      comoSupisteDeAndesRace: comoSupisteDeAndesRace,
    );

    await TParticipantesPk.postAsistenciaPk(
      data,
    ).timeout(Duration(seconds: 60));

    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  updateTAsistenciaProvider(
      {dynamic id,
      int? idsheety,
      String? idEvento,
      String? idDistancia,
      bool? estado,
      String? dorsal,
      String? contrasena,
      String? date,
      int? key,
      dynamic title,
      dynamic nombre,
      dynamic apellidos,
      dynamic distancias,
      dynamic pais,
      dynamic email,
      dynamic telefono,
      dynamic numeroDeWhatsapp,
      dynamic tallaDePolo,
      dynamic fechaDeNacimiento,
      dynamic documento,
      dynamic numeroDeDocumentos,
      dynamic team,
      dynamic genero,
      dynamic rangoDeEdad,
      dynamic grupoSanguineo,
      dynamic haSidoVacunadoContraElCovid19,
      dynamic alergias,
      dynamic nombreCompleto,
      dynamic parentesco,
      dynamic telefonoPariente,
      dynamic carrerasPrevias,
      dynamic porQueCorresElAndesRace,
      dynamic deCuscoAPartida,
      dynamic deCuscoAOllantaytambo,
      dynamic comoSupisteDeAndesRace,
      File? imagenFile}) async {
    isSyncing = true;
    notifyListeners();
    ParticipantesModel data = ParticipantesModel(
      id: id,
      idsheety: idsheety,
      idEvento: idEvento!,
      idDistancia: idDistancia!,
      estado: estado!,
      dorsal: dorsal!,
      contrasena: contrasena,
      date: date,
      key: key,
      title: title,
      nombre: nombre,
      apellidos: apellidos,
      distancias: distancias,
      pais: pais,
      email: email,
      telefono: telefono,
      numeroDeWhatsapp: numeroDeWhatsapp,
      tallaDePolo: tallaDePolo,
      fechaDeNacimiento: fechaDeNacimiento,
      documento: documento,
      numeroDeDocumentos: numeroDeDocumentos,
      team: team,
      genero: genero,
      rangoDeEdad: rangoDeEdad,
      grupoSanguineo: grupoSanguineo!,
      haSidoVacunadoContraElCovid19: haSidoVacunadoContraElCovid19,
      alergias: alergias,
      nombreCompleto: nombreCompleto,
      parentesco: parentesco,
      telefonoPariente: telefonoPariente,
      carrerasPrevias: carrerasPrevias,
      porQueCorresElAndesRace: porQueCorresElAndesRace,
      deCuscoAPartida: deCuscoAPartida,
      deCuscoAOllantaytambo: deCuscoAOllantaytambo,
      comoSupisteDeAndesRace: comoSupisteDeAndesRace,
    );

    await TParticipantesPk.putAsitneciaPk(
            id: id, data: data, imagen: imagenFile)
        .timeout(Duration(seconds: 60));

    // await Future.delayed(const Duration(seconds: 2));
    isSyncing = false;
    notifyListeners();
  }

  deleteTAsistenciaApp(String id) async {
    await TParticipantesPk.deleteAsistentciaPk(id)
        .timeout(Duration(seconds: 60));
    notifyListeners();
  }

  Future<void> realtime() async {
    await pb.collection('$collectionParticipantes').subscribe('*', (e) {
      print('REALMTIME ${e.action}');
      // print('REALTIME VALUE ${e.record}');

      switch (e.action) {
        case 'create':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          addAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        case 'update':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          updateTAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        case 'delete':
          e.record!.data['id'] = e.record!.id;
          e.record!.data['created'] = DateTime.parse(e.record!.created);
          e.record!.data['updated'] = DateTime.parse(e.record!.updated);
          e.record!.data["collectionId"] = e.record!.collectionId;
          e.record!.data["collectionName"] = e.record!.collectionName;
          deleteTAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

//METODO PARA POST O UPDATE
  Future<void> saveProductosApp(ParticipantesModel e) async {
    isSyncing = true;
    notifyListeners();
    if (e.id!.isEmpty) {
      // // if (e.key! == null) {
      //  dynamic id;
      //   int? idsheety;
      //   if (e.id is int) {
      //       idsheety = e.id;
      //   } else {
      //     if (e.id is String) {
      //        id = e.id;
      //        idsheety = e.idsheety;
      //     }
      //   }

      // // Verificar si el id es nulo o vacío
      // if ((e.id is String && (e.id as String).isEmpty)) {
      //   //!Vamos a trabjar con Key para este caso especial
      await postTAsistenciaProvider(
        id: '',
        idsheety: e.idsheety,
        idEvento: e.idEvento ?? '',
        idDistancia: e.idDistancia ?? '',
        estado: e.estado ?? false,
        dorsal: e.dorsal ?? '',
        contrasena: e.contrasena ?? '',
        date: e.date,
        key: e.key,
        title: e.title,
        nombre: e.nombre,
        apellidos: e.apellidos,
        distancias: e.distancias,
        pais: e.pais,
        email: e.email,
        telefono: e.telefono,
        numeroDeWhatsapp: e.numeroDeWhatsapp,
        tallaDePolo: e.tallaDePolo,
        fechaDeNacimiento: e.fechaDeNacimiento,
        documento: e.documento,
        numeroDeDocumentos: e.numeroDeDocumentos,
        team: e.team,
        genero: e.genero,
        rangoDeEdad: e.rangoDeEdad,
        grupoSanguineo: e.grupoSanguineo,
        haSidoVacunadoContraElCovid19: e.haSidoVacunadoContraElCovid19,
        alergias: e.alergias,
        nombreCompleto: e.nombreCompleto,
        parentesco: e.parentesco,
        telefonoPariente: e.telefonoPariente,
        carrerasPrevias: e.carrerasPrevias,
        porQueCorresElAndesRace: e.porQueCorresElAndesRace,
        deCuscoAPartida: e.deCuscoAPartida,
        deCuscoAOllantaytambo: e.deCuscoAOllantaytambo,
        comoSupisteDeAndesRace: e.comoSupisteDeAndesRace,
      );

      print('POST RUNNERS API ${e.nombre} ${e.id}');
    } else {
      await updateTAsistenciaProvider(
        id: e.id,
        idsheety: e.idsheety,
        idEvento: e.idEvento ?? '',
        idDistancia: e.idDistancia ?? '',
        estado: e.estado ?? false,
        dorsal: e.dorsal ?? '',
        contrasena: e.contrasena ?? '',
        date: e.date,
        key: e.key,
        title: e.title,
        nombre: e.nombre,
        apellidos: e.apellidos,
        distancias: e.distancias,
        pais: e.pais,
        email: e.email,
        telefono: e.telefono,
        numeroDeWhatsapp: e.numeroDeWhatsapp,
        tallaDePolo: e.tallaDePolo,
        fechaDeNacimiento: e.fechaDeNacimiento,
        documento: e.documento,
        numeroDeDocumentos: e.numeroDeDocumentos,
        team: e.team,
        genero: e.genero,
        rangoDeEdad: e.rangoDeEdad,
        grupoSanguineo: e.grupoSanguineo,
        haSidoVacunadoContraElCovid19: e.haSidoVacunadoContraElCovid19,
        alergias: e.alergias,
        nombreCompleto: e.nombreCompleto,
        parentesco: e.parentesco,
        telefonoPariente: e.telefonoPariente,
        carrerasPrevias: e.carrerasPrevias,
        porQueCorresElAndesRace: e.porQueCorresElAndesRace,
        deCuscoAPartida: e.deCuscoAPartida,
        deCuscoAOllantaytambo: e.deCuscoAOllantaytambo,
        comoSupisteDeAndesRace: e.comoSupisteDeAndesRace,
      );
      print('PUT RUNNERS API ${e.nombre} ${e.id}');
    }
    isSyncing = false;
    notifyListeners();
  }

  List<String> incidenciasSinc = [];

  bool isSyn = false;
// Lista para elementos que deben ser eliminados de listRunner
  List<ParticipantesModel> toBeDeleted = [];
  List<ParticipantesModel> toBeUpdate = [];
  List<ParticipantesModel> toBeCreated = [];

  Future<void> sincServer({List<ParticipantesModel>? listSheet}) async {
    isSyn = true;
    notifyListeners();
    // Verificamos que la lista no sea nula
    if (listSheet == null) return;
    //1:itear sobre esta lista porque sera la que siempre tendra TODOS los elementos
    for (var sheet in listSheet) {
      //EXPLIACION: sverificar si un elemento de listSheet existe en listaRunner.
      bool existInRunner = listaRunner.any((runner) => runner.key == sheet.key);
      // var runnerPoketbase = listaRunner.firstWhere((r) => r.key == sheet.key);
      //listaRunner y te da la posición (índice) de ese elemento si existe, o -1 si no existe
      final index = listaRunner.indexWhere((p) => p.key == sheet.key);
      // determinar si sheet ya existe en

      if (!existInRunner) {
        //si NO Existe!: Si no existe en listaRunner, agregarlo (CREATE)

        print(
            'IDSHEET NUEVO ELEMENTRO: ${sheet.idsheety} el ID es : ${sheet.id}');
        toBeCreated.add(sheet);
        await postTAsistenciaProvider(
          id: '',
          idsheety: sheet.idsheety, //sheet.id,
          idEvento: '',
          idDistancia: '',
          estado: sheet.estado ?? false,
          dorsal: sheet.dorsal ?? '',
          contrasena: sheet.contrasena ?? '',

          date: sheet.date,
          key: sheet.key,
          title: sheet.title,
          nombre: sheet.nombre,
          apellidos: sheet.apellidos,
          distancias: sheet.distancias,
          pais: sheet.pais,
          email: sheet.email,
          telefono: sheet.telefono,
          numeroDeWhatsapp: sheet.numeroDeWhatsapp,
          tallaDePolo: sheet.tallaDePolo,
          fechaDeNacimiento: sheet.fechaDeNacimiento,
          documento: sheet.documento,
          numeroDeDocumentos: sheet.numeroDeDocumentos,
          team: sheet.team,
          genero: sheet.genero,
          rangoDeEdad: sheet.rangoDeEdad,
          grupoSanguineo: sheet.grupoSanguineo,
          haSidoVacunadoContraElCovid19: sheet.haSidoVacunadoContraElCovid19,
          alergias: sheet.alergias,
          nombreCompleto: sheet.nombreCompleto,
          parentesco: sheet.parentesco,
          telefonoPariente: sheet.telefonoPariente,
          carrerasPrevias: sheet.carrerasPrevias,
          porQueCorresElAndesRace: sheet.porQueCorresElAndesRace,
          deCuscoAPartida: sheet.deCuscoAPartida,
          deCuscoAOllantaytambo: sheet.deCuscoAOllantaytambo,
          comoSupisteDeAndesRace: sheet.comoSupisteDeAndesRace,
        );

        print('CREATE en el servidor ${sheet.nombre}');

        // PlatformAlertDialog(message: 'Cambios en el servidor', title: '${listSheet[index].nombre}');
      } else {
        //SI existe : vemos si lo modificamos o no
        // Si existe en listaRunner, verificar si necesita ser actualizado (UPDATE)

        if (index != -1) {
          // if (listaRunner[index] != sheet) {//este tambein sirve para comprar pero es muy general
          final e = listaRunner[index];
          // Comparar campos Especificos
          //identical: Se usa para comparar referencias de objetos. En este caso, se usa para comparar campos específicos.
          //CReamos un metodo que permita ocmparar que nop
          if (e.key != sheet.key ||
                  e.dorsal.toString() != sheet.dorsal.toString() ||
                  e.title.toString() != sheet.title.toString() ||
                  e.nombre.toString() != sheet.nombre.toString() ||
                  e.apellidos.toString() != sheet.apellidos.toString() ||
                  e.distancias.toString() != sheet.distancias.toString() ||
                  e.pais.toString() != sheet.pais.toString() ||
                  e.email.toString() != sheet.email.toString() ||
                  e.telefono.toString() != sheet.telefono.toString() ||
                  e.numeroDeWhatsapp.toString() !=
                      sheet.numeroDeWhatsapp.toString() ||
                  e.tallaDePolo.toString() != sheet.tallaDePolo.toString() ||
                  e.fechaDeNacimiento.toString() !=
                      sheet.fechaDeNacimiento.toString() ||
                  e.documento.toString() != sheet.documento.toString() ||
                  e.numeroDeDocumentos.toString() !=
                      sheet.numeroDeDocumentos.toString() ||
                  e.team.toString() != sheet.team.toString() ||
                  e.genero.toString() != sheet.genero.toString() ||
                  e.rangoDeEdad.toString() != sheet.rangoDeEdad.toString() ||
                  e.grupoSanguineo.toString() !=
                      sheet.grupoSanguineo.toString() ||
                  e.haSidoVacunadoContraElCovid19.toString() !=
                      sheet.haSidoVacunadoContraElCovid19.toString() ||
                  e.alergias.toString() != sheet.alergias.toString() ||
                  e.nombreCompleto.toString() !=
                      sheet.nombreCompleto.toString() ||
                  e.parentesco.toString() != sheet.parentesco.toString() ||
                  e.telefonoPariente.toString() !=
                      sheet.telefonoPariente.toString() ||
                  e.carrerasPrevias.toString() !=
                      sheet.carrerasPrevias.toString() ||
                  e.porQueCorresElAndesRace.toString() !=
                      sheet.porQueCorresElAndesRace.toString() ||
                  e.deCuscoAPartida.toString() !=
                      sheet.deCuscoAPartida.toString() ||
                  e.deCuscoAOllantaytambo.toString() !=
                      sheet.deCuscoAOllantaytambo.toString() ||
                  e.comoSupisteDeAndesRace.toString() !=
                      sheet.comoSupisteDeAndesRace.toString()
              // (e.deCuscoAPartida?.toString() != sheet.deCuscoAPartida?.toString() &&
              //     !(e.deCuscoAPartida == '' && sheet.deCuscoAPartida == null)) ||
              // (e.deCuscoAOllantaytambo?.toString() != sheet.deCuscoAOllantaytambo?.toString() &&
              //     !(e.deCuscoAOllantaytambo == '' && sheet.deCuscoAOllantaytambo == null)) ||
              // (e.comoSupisteDeAndesRace?.toString() != sheet.comoSupisteDeAndesRace?.toString() &&
              //     !(e.comoSupisteDeAndesRace == '' && sheet.comoSupisteDeAndesRace == null))
              ) {
            print(
                "IDSheety*******************${e.idsheety}*******${sheet.idsheety}***************");
            print(
                "nombre*******************${e.nombre}*******${sheet.nombre}***************");
            print(
                "apellidos*******************${e.apellidos}*******${sheet.apellidos}***************");
            print(
                "distancias*******************${e.distancias}*******${sheet.distancias}***************");
            print(
                "pais*******************${e.pais}*******${sheet.pais}***************");
            print(
                "email*******************${e.email}*******${sheet.email}***************");
            print(
                "telefono*******************${e.telefono}*******${sheet.telefono}***************");
            print(
                "numeroDeWhatsapp*******************${e.numeroDeWhatsapp}*******${sheet.numeroDeWhatsapp}***************");
            print(
                "tallaDePolo*******************${e.tallaDePolo}*******${sheet.tallaDePolo}***************");
            print(
                "fechaDeNacimiento*******************${e.fechaDeNacimiento}*******${sheet.fechaDeNacimiento}***************");
            print(
                "documento*******************${e.documento}*******${sheet.documento}***************");
            print(
                "numeroDeDocumentos*******************${e.numeroDeDocumentos}*******${sheet.numeroDeDocumentos}***************");
            print(
                "team*******************${e.team}*******${sheet.team}***************");
            print(
                "genero*******************${e.genero}*******${sheet.genero}***************");
            print(
                "rangoDeEdad*******************${e.rangoDeEdad}*******${sheet.rangoDeEdad}***************");
            print(
                "grupoSanguineo*******************${e.grupoSanguineo}*******${sheet.grupoSanguineo}***************");
            print(
                "haSidoVacunadoContraElCovid19*******************${e.haSidoVacunadoContraElCovid19}*******${sheet.haSidoVacunadoContraElCovid19}***************");
            print(
                "alergias*******************${e.alergias}*******${sheet.alergias}***************");
            print(
                "nombreCompleto*******************${e.nombreCompleto}*******${sheet.nombreCompleto}***************");
            print(
                "parentesco*******************${e.parentesco}*******${sheet.parentesco}***************");
            print(
                "telefonoPariente*******************${e.telefonoPariente}*******${sheet.telefonoPariente}***************");
            print(
                "carrerasPrevias*******************${e.carrerasPrevias}*******${sheet.carrerasPrevias}***************");
            print(
                "porQueCorresElAndesRace*******************${e.porQueCorresElAndesRace}*******${sheet.porQueCorresElAndesRace}***************");
            print(
                "deCuscoAPartida*******************${e.deCuscoAPartida}*******${sheet.deCuscoAPartida}***************");
            print(
                "deCuscoAOllantaytambo*******************${e.deCuscoAOllantaytambo}*******${sheet.deCuscoAOllantaytambo}***************");
            print(
                "comoSupisteDeAndesRace*******************${e.comoSupisteDeAndesRace}*******${sheet.comoSupisteDeAndesRace}***************");
            toBeUpdate.add(sheet);
            await updateTAsistenciaProvider(
              id: listaRunner[index].id,
              idsheety: sheet.idsheety, //sheet.id,
              idEvento: '',
              idDistancia: '',
              estado: sheet.estado ?? false,
              dorsal: sheet.dorsal ?? '',
              contrasena: sheet.contrasena ?? '',

              date: sheet.date,
              key: sheet.key,
              title: sheet.title,
              nombre: sheet.nombre,
              apellidos: sheet.apellidos,
              distancias: sheet.distancias,
              pais: sheet.pais,
              email: sheet.email,
              telefono: sheet.telefono,
              numeroDeWhatsapp: sheet.numeroDeWhatsapp,
              tallaDePolo: sheet.tallaDePolo,
              fechaDeNacimiento: sheet.fechaDeNacimiento,
              documento: sheet.documento,
              numeroDeDocumentos: sheet.numeroDeDocumentos,
              team: sheet.team,
              genero: sheet.genero,
              rangoDeEdad: sheet.rangoDeEdad,
              grupoSanguineo: sheet.grupoSanguineo,
              haSidoVacunadoContraElCovid19:
                  sheet.haSidoVacunadoContraElCovid19,
              alergias: sheet.alergias,
              nombreCompleto: sheet.nombreCompleto,
              parentesco: sheet.parentesco,
              telefonoPariente: sheet.telefonoPariente,
              carrerasPrevias: sheet.carrerasPrevias,
              porQueCorresElAndesRace: sheet.porQueCorresElAndesRace,
              deCuscoAPartida: sheet.deCuscoAPartida,
              deCuscoAOllantaytambo: sheet.deCuscoAOllantaytambo,
              comoSupisteDeAndesRace: sheet.comoSupisteDeAndesRace,
            );
            print('UPDATE en el servidor ${sheet.nombre}');
          } else {
            //Aqui como no son iguales no se esta considerando y se esta haciendo update consimuendo recursos de los datos
            //que ni se ah anmoficiado por eso es importante espcificar que datos son comunes en ambos
            print('No se detectaron cambios para ${sheet.nombre}');
            toBeDeleted.add(sheet);
          }
        }
        // PlatformAlertDialog(message: 'Cambios en el servidor', title: '${listSheet[index].nombre}');
      }
    }

    isSyn = false;
    notifyListeners();
  }
}
