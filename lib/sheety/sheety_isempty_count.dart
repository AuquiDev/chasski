import 'package:chasski/sheety/model_participantes.dart';


int countEmptyFields(List<ParticipantesModel> participantes, String field) {
  switch (field) {
    case 'date':
      return participantes
          .where((e) => e.date == null || e.date!.isEmpty)
          .length;
    case 'id':
      return participantes.where((e) => e.id == null).length;
    case 'title':
      return participantes
          .where((e) => e.title == null || e.title!.isEmpty)
          .length;
    case 'nombre':
      return participantes.where((e) => e.nombre!.isEmpty).length;
    case 'apellidos':
      return participantes.where((e) => e.apellidos.isEmpty).length;
    case 'distancias':
      return participantes.where((e) => e.distancias.isEmpty).length;
    case 'pais':
      return participantes.where((e) => e.pais.isEmpty).length;
    case 'email':
      return participantes.where((e) => e.email.isEmpty).length;
    case 'telefono':
      return participantes.where((e) => e.telefono == null).length;
    case 'numeroDeWhatsapp':
      return participantes.where((e) => e.numeroDeWhatsapp == null).length;
    case 'tallaDePolo':
      return participantes.where((e) => e.tallaDePolo.isEmpty).length;
    case 'fechaDeNacimiento':
      return participantes.where((e) => e.fechaDeNacimiento.isEmpty).length;
    case 'documento':
      return participantes.where((e) => e.documento.isEmpty).length;
    case 'numeroDeDocumentos':
      return participantes.where((e) => e.numeroDeDocumentos == null).length;
    case 'team':
      return participantes.where((e) => e.team == null).length;
    case 'genero':
      return participantes.where((e) => e.genero.isEmpty).length;
    case 'rangoDeEdad':
      return participantes.where((e) => e.rangoDeEdad.isEmpty).length;
    case 'grupoSanguineo':
      return participantes.where((e) => e.grupoSanguineo.isEmpty).length;
    case 'haSidoVacunadoContraElCovid19':
      return participantes
          .where((e) => e.haSidoVacunadoContraElCovid19.isEmpty)
          .length;
    case 'alergias':
      return participantes.where((e) => e.alergias.isEmpty).length;
    case 'nombreCompleto':
      return participantes.where((e) => e.nombreCompleto == null).length;
    case 'parentesco':
      return participantes.where((e) => e.parentesco == null).length;
    case 'telefonoPariente':
      return participantes.where((e) => e.telefonoPariente == null).length;
    case 'carrerasPrevias':
      return participantes.where((e) => e.carrerasPrevias == null).length;
    case 'porQueCorresElAndesRace':
      return participantes
          .where((e) => e.porQueCorresElAndesRace.isEmpty)
          .length;
    case 'deCuscoAPartida':
      return participantes
          .where((e) => e.deCuscoAPartida == null || e.deCuscoAPartida!.isEmpty)
          .length;
    case 'deCuscoAOllantaytambo':
      return participantes
          .where((e) =>
              e.deCuscoAOllantaytambo == null ||
              e.deCuscoAOllantaytambo!.isEmpty)
          .length;
    case 'comoSupisteDeAndesRace':
      return participantes
          .where((e) =>
              e.comoSupisteDeAndesRace == null ||
              e.comoSupisteDeAndesRace!.isEmpty)
          .length;
    default:
      return 0;
  }
}

final List<String> fields = [
  'date',
  'id',
  'title',
  'nombre',
  'apellidos',
  'distancias',
  'pais',
  'email',
  'telefono',
  'numeroDeWhatsapp',
  'tallaDePolo',
  'fechaDeNacimiento',
  'documento',
  'numeroDeDocumentos',
  'team',
  'genero',
  'rangoDeEdad',
  'grupoSanguineo',
  'haSidoVacunadoContraElCovid19',
  'alergias',
  'nombreCompleto',
  'parentesco',
  'telefonoPariente',
  'carrerasPrevias',
  'porQueCorresElAndesRace',
  'deCuscoAPartida',
  'deCuscoAOllantaytambo',
  'comoSupisteDeAndesRace',
];

// Función para verificar si el campo está vacío o nulo
bool isFieldEmpty(String field, ParticipantesModel e) {
  switch (field) {
    case 'date':
      return e.date == null || e.date!.isEmpty;
    case 'id':
      return e.id == null;
    case 'title':
      return e.title == null || e.title!.isEmpty;
    case 'nombre':
      return e.nombre!.isEmpty;
    case 'apellidos':
      return e.apellidos.isEmpty;
    case 'distancias':
      return e.distancias.isEmpty;
    case 'pais':
      return e.pais.isEmpty;
    case 'email':
      return e.email.isEmpty;
    case 'telefono':
      return e.telefono == null;
    case 'numeroDeWhatsapp':
      return e.numeroDeWhatsapp == null;
    case 'tallaDePolo':
      return e.tallaDePolo.isEmpty;
    case 'fechaDeNacimiento':
      return e.fechaDeNacimiento.isEmpty;
    case 'documento':
      return e.documento.isEmpty;
    case 'numeroDeDocumentos':
      return e.numeroDeDocumentos == null;
    case 'team':
      return e.team == null;
    case 'genero':
      return e.genero.isEmpty;
    case 'rangoDeEdad':
      return e.rangoDeEdad.isEmpty;
    case 'grupoSanguineo':
      return e.grupoSanguineo.isEmpty;
    case 'haSidoVacunadoContraElCovid19':
      return e.haSidoVacunadoContraElCovid19.isEmpty;
    case 'alergias':
      return e.alergias.isEmpty;
    case 'nombreCompleto':
      return e.nombreCompleto == null;
    case 'parentesco':
      return e.parentesco == null;
    case 'telefonoPariente':
      return e.telefonoPariente == null;
    case 'carrerasPrevias':
      return e.carrerasPrevias == null;
    case 'porQueCorresElAndesRace':
      return e.porQueCorresElAndesRace.isEmpty;
    case 'deCuscoAPartida':
      return e.deCuscoAPartida == null || e.deCuscoAPartida!.isEmpty;
    case 'deCuscoAOllantaytambo':
      return e.deCuscoAOllantaytambo == null ||
          e.deCuscoAOllantaytambo!.isEmpty;
    case 'comoSupisteDeAndesRace':
      return e.comoSupisteDeAndesRace == null ||
          e.comoSupisteDeAndesRace!.isEmpty;
    default:
      return false;
  }
}
