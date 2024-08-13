import 'dart:async';
import 'dart:io';

import 'package:chasski/models/distancia/model_distancias_ar.dart';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/audit%20fielt/field_compare_participante.dart';
import 'package:chasski/provider/distancia/provider_t_distancias_ar.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/poketbase/runner/t_participantes.dart';
import 'package:chasski/provider/cache/shared/shared_global.dart';
import 'package:chasski/utils/conversion/assets_format_fecha.dart';
import 'package:chasski/utils/dialogs/assets_dialog.dart';
import 'package:chasski/utils/files/assets_play_sound.dart';
import 'package:chasski/utils/validation/assets_verifi_field.dart';
import 'package:flutter/material.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class TParticipantesProvider with ChangeNotifier {
  //ACTION REALM
  String actionRealm = 'Action';

  //Collection name
  final String collection_name = 'ar_corredores_data';

  List<ParticipantesModel> listaRunner = [];

  TParticipantesProvider() {
    print('$collection_name Inicializado');
    getTAsistenciaApp();
    realtime();
  }

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
    List<RecordModel> response =
        await TParticipantesPk.getAsitenciaPk(collectionName: collection_name);
    final date = response.map((e) {
      e.data['id'] = e.id;
      e.data['created'] = DateTime.parse(e.created);
      e.data['updated'] = DateTime.parse(e.updated);
      e.data["collectionId"] = e.collectionId;
      e.data["collectionName"] = e.collectionName;
      ParticipantesModel ubicaciones = ParticipantesModel.fromJson(e.data);
      addAsistencia(ubicaciones);
    }).toList();
    notifyListeners();
    return date;
  }

//TODOS CLASIFICACION DE DATOS
  Map<String, List<ParticipantesModel>> groupByDistance(
      {required List<ParticipantesModel> listParticipantes,
      required String filename}) {
    Map<String, List<ParticipantesModel>> groupedData = {};
    String value;
    for (var e in listParticipantes) {
      switch (filename) {
        case 'distancias':
          value = getField(e.distancias);
          break;
        case 'tallaDePolo':
          value = getField(e.tallaDePolo);
          break;
        case 'genero':
          value = getField(e.genero);
          break;
        case 'rangoDeEdad':
          value = getField(e.rangoDeEdad);
          break;
        case 'grupoSanguineo':
          value = getField(e.grupoSanguineo);
          break;
        case 'created':
          value = formatDateTimeForGrouping(e.created!);
          break;
        case 'pais':
          value = getField(e.pais);
          break;
        default:
          value = 'Todos';
      }
      if (!groupedData.containsKey(value)) {
        groupedData[value] = [];
      }
      groupedData[value]?.add(e);
    }
    // Ordenar las claves y sus listas
    final sortedGroupedData = Map.fromEntries(groupedData.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)) // Ordenar por claves
        );
    return sortedGroupedData;
  }

  //SEARCH FILE
  List<ParticipantesModel> _filteredData = [];
  String _searchText = '';

  List<ParticipantesModel> get filteredData => _filteredData;
  String get searchText => _searchText;

  void setSearchText(String searchText, List<ParticipantesModel> listData) {
   
    _searchText = searchText;
    _filteredData = listData
        .where((e) =>
            e.title
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.apellidos
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.telefono
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.dorsal
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.team
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            e.pais.toString().toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    notifyListeners();
     print(searchText);
  }

  void clearSearch(List<ParticipantesModel> listData) {
    _searchText = '';
    _filteredData = listData;
    notifyListeners();
  }


  //POST
  bool isSyncing = false;
  postTAsistenciaProvider(
      {dynamic id,
      int? idsheety,
      String? idEvento,
      String? idDistancia,
      bool? estado,
      dynamic dorsal,
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
    try {
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
              data: data, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en CREATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  updateTAsistenciaProvider(
      {dynamic id,
      int? idsheety,
      String? idEvento,
      String? idDistancia,
      bool? estado,
      dynamic dorsal,
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
    try {
      isSyncing = true;
      notifyListeners();
      ParticipantesModel data = ParticipantesModel(
        id: id,
        idsheety: idsheety,
        idEvento: idEvento!,
        idDistancia: idDistancia!,
        estado: estado!,
        dorsal: dorsal,
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
              collectionName: collection_name,
              id: id,
              data: data,
              imagen: imagenFile)
          .timeout(Duration(seconds: 60));
    } catch (e) {
      print("Ocurrió un error en UPDATE: $e");
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }

  bool isDeleted = false;
  deleteTAsistenciaApp(BuildContext context, String id) async {
    isDeleted = true;
    notifyListeners();
    try {
      await TParticipantesPk.deleteAsistentciaPk(
              id: id, collectionName: collection_name)
          .timeout(Duration(seconds: 60));
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message:
              "Se ha borrado este registro de la base de datos correctamente.");
    } catch (e) {
      AssetAlertDialogPlatform.show(
          context: context,
          title: actionRealm,
          message: "Ocurrió un error: $e");
    } finally {
      isDeleted = false;
      notifyListeners();
    }
  }

  Future<void> realtime() async {
    await pb.collection('$collection_name').subscribe('*', (e) {
      print('REALTIME $collection_name -> ${e.action}');

      // Configura los datos del registro
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
          addAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        case 'update':
          configureRecordData();
          updateTAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        case 'delete':
          configureRecordData();
          deleteTAsistencia(ParticipantesModel.fromJson(e.record!.data));
          break;
        default:
      }
    });
  }

//METODO PARA POST O UPDATE
  Future<void> saveProductosApp(ParticipantesModel e) async {
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
    }
  }

  bool islogin = false;
  //Metodo de Autentificacion
  Future<bool> login(
      {required BuildContext context,
      String? cedulaDNI,
      String? contrasena}) async {
    islogin = true;
    notifyListeners();

    int userindex = -1;
    try {
      //Esta bsuqueda devulece un umeor, si el numero estabne en leindex es decir de 0 a mas , si es menor de 0 el usuairo n oexiste.
      print('(${cedulaDNI})  - (${contrasena})');
      userindex = listaRunner.indexWhere((e) {
        bool isExist = (e.numeroDeDocumentos.toString().toLowerCase() ==
                cedulaDNI.toString().toLowerCase() &&
            e.contrasena.toString().toLowerCase() ==
                contrasena.toString().toLowerCase());
        if (isExist) {
          print(
              '(${e.contrasena}) ************** Server (${e.numeroDeDocumentos})');

          // Si se encuentra el usuario, Guardarlo en UsuarioProvider
        
           SharedPrefencesGlobal().savePartipante(e);
        }
        return isExist;
      });

      //Hacer un sonido si el usuario ha sido en contrado
      if (userindex != -1) {
        SoundUtils.vibrate(); // Realiza una vibración
      }
    } catch (e) {
      userindex = -1;
    }

    // Simular una carga con un temporizador
    await Future.delayed(const Duration(seconds: 2));

    // Lógica de navegación o mensaje de error
    if (userindex != -1) {
      // print('ESTATE IF: $islogin');
      islogin = true;
      notifyListeners();
      // Configurar un temporizador para cambiar islogin a false después de 2 segundos
      Timer(const Duration(seconds: 4), () {
        islogin = false;
        notifyListeners();
      });
      return islogin;
    } else {
      // print('ESTATE ELSE: $islogin - $userindex');
      islogin = false;
      notifyListeners();
      return islogin;
    }
  }

  bool isSyn = false;
// Lista para elementos que deben ser eliminados de listRunner
  List<ParticipantesModel> toBeOmited = [];
  List<ParticipantesModel> toBeUpdate = [];
  List<ParticipantesModel> toBeCreated = [];

  Future<void> sincServer(BuildContext context,
      {List<ParticipantesModel>? listSheet, TEventoModel? evento}) async {
    isSyn = true;
    notifyListeners();
    toBeOmited.clear();
    toBeUpdate.clear();
    toBeCreated.clear();
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
      //Llamamos al tipo de Distancia
      List<TDistanciasModel> listDitancia =
          Provider.of<TDistanciasArProvider>(context, listen: false)
              .listAsistencia;

      // Buscar el ID de la distancia basado en la descripción de la hoja
      String idDistancia = '';
      try {
        idDistancia = listDitancia
            .firstWhere(
                (e) => e.descripcion.toString() == sheet.distancias.toString())
            .id!;
      } catch (e) {
        print(
            'No se encontró un ID válido para la distancia ${sheet.distancias}');
        // Aquí puedes manejar el caso donde no se encuentra un ID válido
      }

      if (!existInRunner) {
        //si NO Existe!: Si no existe en listaRunner, agregarlo (CREATE)

        print(
            'IDSHEET NUEVO ELEMENTRO: ${sheet.idsheety} el ID es : ${sheet.id}');
        toBeCreated.add(sheet);

        await postTAsistenciaProvider(
          id: '',
          idsheety: sheet.idsheety, //sheet.id,
          idEvento: evento!.id!, //'',
          idDistancia: idDistancia, //'',
          estado: sheet.estado ??
              true, //POr defecto los ususarios deben estar activos
          dorsal: sheet.dorsal,
          contrasena: sheet.numeroDeDocumentos
              .toString(), //sheet.contrasena ?? '',SOLO EN POST

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
      } else {
        //SI existe : vemos si lo modificamos o no
        // Si existe en listaRunner, verificar si necesita ser actualizado (UPDATE)

        if (index != -1) {
          // if (listaRunner[index] != sheet) {//este tambein sirve para comprar pero es muy general
          final e = listaRunner[index];
          // Comparar campos Especificos
          //identical: Se usa para comparar referencias de objetos. En este caso, se usa para comparar campos específicos.
          //CReamos un metodo que permita ocmparar que nop
          if (isComratedField(X: e, Y: sheet)) {
            toBeUpdate.add(sheet);

            await updateTAsistenciaProvider(
              id: e.id, //listaRunner[index]
              idsheety: sheet.idsheety, //sheet.id,
              idEvento: evento!.id!, //'',
              idDistancia: idDistancia,
              estado: e.estado ??
                  true, //TODOS los usuarios no pueden editar el estado al sincronizar
              contrasena: e.contrasena ??
                  '', //NO SENVIA, LA CONTRASENA NO DEBE BORRASSTE

              //TODOS ESTOS SE MODIFICAN DESDE GOOGLE SHEETS
              //ESDECIR qeu si modificas estos campos en el servidor al sincronizar la hoja de gogole shets, borrara cada registro.
              dorsal: sheet
                  .dorsal, //TODOs AQUI CONVERSAR SI se requiere editar el dorsal, desde el servidor o desde la Sheets
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
          } else {
            //Aqui como no son iguales no se esta considerando y se esta haciendo update consimuendo recursos de los datos
            //que ni se ah anmoficiado por eso es importante espcificar que datos son comunes en ambos
            print('No se detectaron cambios para ${sheet.nombre}');
            toBeOmited.add(sheet);
          }
        }
      }
    }

    isSyn = false;
    notifyListeners();
  }
}
