
//todos Si existe comparamos si ha sido modificado
//METODO DE COMPRACION DE CAMPOS ESPECIFICOS 
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:chasski/page/empleado/offline/runner/cp___participantes.dart';
import 'package:chasski/utils/text/assets_textapp.dart';
import 'package:flutter/material.dart';

bool isComratedField({
  required ParticipantesModel X,
  required ParticipantesModel Y,
}) {
  bool isModifiServer = (X.key != Y.key ||
      X.dorsal.toString() != Y.dorsal.toString() ||
      X.title.toString() != Y.title.toString() ||
      X.nombre.toString() != Y.nombre.toString() ||
      X.apellidos.toString() != Y.apellidos.toString() ||
      X.distancias.toString() != Y.distancias.toString() ||
      X.pais.toString() != Y.pais.toString() ||
      X.email.toString() != Y.email.toString() ||
      X.telefono.toString() != Y.telefono.toString() ||
      X.numeroDeWhatsapp.toString() != Y.numeroDeWhatsapp.toString() ||
      X.tallaDePolo.toString() != Y.tallaDePolo.toString() ||
      X.fechaDeNacimiento.toString() != Y.fechaDeNacimiento.toString() ||
      X.documento.toString() != Y.documento.toString() ||
      X.numeroDeDocumentos.toString() != Y.numeroDeDocumentos.toString() ||
      X.team.toString() != Y.team.toString() ||
      X.genero.toString() != Y.genero.toString() ||
      X.rangoDeEdad.toString() != Y.rangoDeEdad.toString() ||
      X.grupoSanguineo.toString() != Y.grupoSanguineo.toString() ||
      X.haSidoVacunadoContraElCovid19.toString() !=
          Y.haSidoVacunadoContraElCovid19.toString() ||
      X.alergias.toString() != Y.alergias.toString() ||
      X.nombreCompleto.toString() != Y.nombreCompleto.toString() ||
      X.parentesco.toString() != Y.parentesco.toString() ||
      X.telefonoPariente.toString() != Y.telefonoPariente.toString() ||
      X.carrerasPrevias.toString() != Y.carrerasPrevias.toString() ||
      X.porQueCorresElAndesRace.toString() !=
          Y.porQueCorresElAndesRace.toString() ||
      // e.deCuscoAPartida.toString() !=
      //     sheet.deCuscoAPartida.toString() ||
      // e.deCuscoAOllantaytambo.toString() !=
      //     sheet.deCuscoAOllantaytambo.toString() ||
      // e.comoSupisteDeAndesRace.toString() !=
      //     sheet.comoSupisteDeAndesRace.toString()
      (X.deCuscoAPartida?.toString() != Y.deCuscoAPartida?.toString() &&
          !(X.deCuscoAPartida == '' && Y.deCuscoAPartida == null)) ||
      (X.deCuscoAOllantaytambo?.toString() !=
              Y.deCuscoAOllantaytambo?.toString() &&
          !(X.deCuscoAOllantaytambo == '' &&
              Y.deCuscoAOllantaytambo == null)) ||
      (X.comoSupisteDeAndesRace?.toString() !=
              Y.comoSupisteDeAndesRace?.toString() &&
          !(X.comoSupisteDeAndesRace == '' &&
              Y.comoSupisteDeAndesRace == null)));

  // void printComparison(String fieldName, dynamic value1, dynamic value2) {
  //   print("$fieldName: $value1 != $value2");
  // }
  void printComparison(String fieldName, dynamic value1, dynamic value2) {
    if (value1 != value2) {
      print("$fieldName: $value1 != $value2");
    }
  }

  printComparison("IDSheety", X.idsheety, Y.idsheety);
  printComparison("Dorsal", X.dorsal, Y.dorsal);
  printComparison("Nombre", X.nombre, Y.nombre);
  printComparison("Apellidos", X.apellidos, Y.apellidos);
  printComparison("Distancias", X.distancias, Y.distancias);
  printComparison("Pais", X.pais, Y.pais);
  printComparison("Email", X.email, Y.email);
  printComparison("Telefono", X.telefono, Y.telefono);
  printComparison(
      "NumeroDeWhatsapp", X.numeroDeWhatsapp, Y.numeroDeWhatsapp);
  printComparison("TallaDePolo", X.tallaDePolo, Y.tallaDePolo);
  printComparison(
      "FechaDeNacimiento", X.fechaDeNacimiento, Y.fechaDeNacimiento);
  printComparison("Documento", X.documento, Y.documento);
  printComparison(
      "NumeroDeDocumentos", X.numeroDeDocumentos, Y.numeroDeDocumentos);
  printComparison("Team", X.team, Y.team);
  printComparison("Genero", X.genero, Y.genero);
  printComparison("RangoDeEdad", X.rangoDeEdad, Y.rangoDeEdad);
  printComparison("GrupoSanguineo", X.grupoSanguineo, Y.grupoSanguineo);
  printComparison("HaSidoVacunadoContraElCovid19",
      X.haSidoVacunadoContraElCovid19, Y.haSidoVacunadoContraElCovid19);
  printComparison("Alergias", X.alergias, Y.alergias);
  printComparison("NombreCompleto", X.nombreCompleto, Y.nombreCompleto);
  printComparison("Parentesco", X.parentesco, Y.parentesco);
  printComparison(
      "TelefonoPariente", X.telefonoPariente, Y.telefonoPariente);
  printComparison("CarrerasPrevias", X.carrerasPrevias, Y.carrerasPrevias);
  printComparison("PorQueCorresElAndesRace", X.porQueCorresElAndesRace,
      Y.porQueCorresElAndesRace);
  printComparison("DeCuscoAPartida", X.deCuscoAPartida, Y.deCuscoAPartida);
  printComparison("DeCuscoAOllantaytambo", X.deCuscoAOllantaytambo,
      Y.deCuscoAOllantaytambo);
  printComparison("ComoSupisteDeAndesRace", X.comoSupisteDeAndesRace,
      Y.comoSupisteDeAndesRace);

  return isModifiServer;
}



Column contentDialog(
    {required BuildContext context,
    required ParticipantesModel runnerSQL,
    required ParticipantesModel runneServer,
    required int index,
    required String textBottonIsTrue,
    required String textBottonIsFalse}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            P3Text(text:  'Dato Local: ' + runnerSQL.idsql.toString()),
            CardParticipantes(e: runnerSQL, index: 1),
            if (index != -1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  P3Text(text: runneServer.idsql == null ? 'Dato Server' : runneServer.idsql.toString()),
                  CardParticipantes(e: runneServer, index: 1),
                ],
              ),
          ],
        ),
      ),
      ButtonBar(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Eliminar
            child: P3Text(text: textBottonIsTrue),
          ),
          OutlinedButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Mantener locales
            child: P3Text(text: textBottonIsFalse),
          ),
        ],
      )
    ],
  );
}
