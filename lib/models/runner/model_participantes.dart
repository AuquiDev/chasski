class ParticipantesModel {
  int? idsql; //Se añade con fines de uso en sqllite
  dynamic id; //dynamicid server
  String? collectionId;
  String? collectionName;
  DateTime? created;
  DateTime? updated;

  int? idsheety;
  String? idEvento;
  String? idDistancia;
  bool? estado;//
  String? imagen;
  dynamic dorsal;
  String? contrasena;

  String? date;
  int? key;
  dynamic title;
  dynamic nombre;
  dynamic apellidos;
  dynamic distancias;
  dynamic pais;
  dynamic email;
  dynamic telefono;
  dynamic numeroDeWhatsapp;
  dynamic tallaDePolo;
  dynamic fechaDeNacimiento;
  dynamic documento;
  dynamic numeroDeDocumentos;
  dynamic team;
  dynamic genero;

  dynamic rangoDeEdad;
  dynamic grupoSanguineo;
  dynamic haSidoVacunadoContraElCovid19;
  dynamic alergias;

  dynamic nombreCompleto;
  dynamic parentesco;
  dynamic telefonoPariente;

  dynamic carrerasPrevias;
  dynamic porQueCorresElAndesRace;
  dynamic deCuscoAPartida;
  dynamic deCuscoAOllantaytambo;
  dynamic comoSupisteDeAndesRace;

  ParticipantesModel({
    this.idsql,
    this.id,
    this.collectionId,
    this.collectionName,
    this.created,
    this.updated,
    this.idsheety,
    this.idEvento,
    this.idDistancia,
    this.estado,
    this.imagen,
    this.dorsal,
    this.contrasena,
    required this.date,
    required this.key,
    required this.title,
    required this.nombre,
    required this.apellidos,
    required this.distancias,
    required this.pais,
    required this.email,
    required this.telefono,
    required this.numeroDeWhatsapp,
    required this.tallaDePolo,
    required this.fechaDeNacimiento,
    required this.documento,
    required this.numeroDeDocumentos,
    required this.team,
    required this.genero,
    required this.rangoDeEdad,
    required this.grupoSanguineo,
    required this.haSidoVacunadoContraElCovid19,
    required this.alergias,
    required this.nombreCompleto,
    required this.parentesco,
    required this.telefonoPariente,
    required this.carrerasPrevias,
    required this.porQueCorresElAndesRace,
    required this.deCuscoAPartida,
    required this.deCuscoAOllantaytambo,
    required this.comoSupisteDeAndesRace,
  });

  factory ParticipantesModel.fromJson(Map<String, dynamic> json) {
    dynamic id;
    int? idsheety;
    if (json['id'] is int) {
      idsheety = json['id'];
    } else {
      if (json['id'] is String) {
        id = json['id'];
        idsheety = json["idsheety"];
      }
    }

    return ParticipantesModel(
      id: id, //json['id'],
      collectionId: json["collectionId"],
      collectionName: json["collectionName"],
      created: json["created"],
      updated: json["updated"],
      idsheety: idsheety, //json["idsheety"],
      idEvento: json["id_evento"],
      idDistancia: json["id_distancia"],

      estado: json["estado"] ?? false,
      imagen: json["imagen"],
      dorsal: json["dorsal"],
      contrasena: json["contrasena"],

      date: json["date"],
      key: json["key"],
      title: json["title"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      distancias: json["distancias"],
      pais: json["pais"],
      email: json["email"],
      telefono: json["telefono"],
      numeroDeWhatsapp: json["numeroDeWhatsapp"],
      tallaDePolo: json["tallaDePolo"],
      fechaDeNacimiento: json["fechaDeNacimiento"],
      documento: json["documento"],
      numeroDeDocumentos: json["numeroDeDocumentos"],
      team: json["team"],
      genero: json["genero"],
      rangoDeEdad: json["rangoDeEdad"],
      grupoSanguineo: json["grupoSanguineo"],
      haSidoVacunadoContraElCovid19: json["haSidoVacunadoContraElCovid19"],
      alergias: json["alergias"],
      nombreCompleto: json["nombreCompleto"],
      parentesco: json["parentesco"],
      telefonoPariente: json["telefonoPariente"],
      carrerasPrevias: json["carrerasPrevias"],
      porQueCorresElAndesRace: json["porQueCorresElAndesRace"],
      deCuscoAPartida: json["deCuscoAPartida"],
      deCuscoAOllantaytambo: json["deCuscoAOllantaytambo"],
      comoSupisteDeAndesRace: json["comoSupisteDeAndesRace"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created,
        // "updated": updated,
        "idsheety": idsheety,
        "id_evento": idEvento,
        "id_distancia": idDistancia,
        "estado": estado,
        // "imagen": imagen,
        "dorsal": dorsal,
        "contrasena": contrasena,

        "date": date,
        "key": key,
        "title": title,
        "nombre": nombre,
        "apellidos": apellidos,
        "distancias": distancias,
        "pais": pais,
        "email": email,
        "telefono": telefono,
        "numeroDeWhatsapp": numeroDeWhatsapp,
        "tallaDePolo": tallaDePolo,
        "fechaDeNacimiento": fechaDeNacimiento,
        "documento": documento,
        "numeroDeDocumentos": numeroDeDocumentos,
        "team": team,
        "genero": genero,
        "rangoDeEdad": rangoDeEdad,
        "grupoSanguineo": grupoSanguineo,
        "haSidoVacunadoContraElCovid19": haSidoVacunadoContraElCovid19,
        "alergias": alergias,
        "nombreCompleto": nombreCompleto,
        "parentesco": parentesco,
        "telefonoPariente": telefonoPariente,
        "carrerasPrevias": carrerasPrevias,
        "porQueCorresElAndesRace": porQueCorresElAndesRace,
        "deCuscoAPartida": deCuscoAPartida,
        "deCuscoAOllantaytambo": deCuscoAOllantaytambo,
        "comoSupisteDeAndesRace": comoSupisteDeAndesRace,
      };
} 

ParticipantesModel participantesModelDefault() {
  return ParticipantesModel(
      id: null,
      collectionId: null,
      collectionName: null,
      created: null,
      updated: null,
      idsheety: null,
      idEvento: null,
      idDistancia: null,
      estado: null,
      imagen: null,
      dorsal: 'N/A',
      contrasena: null,
      date: null,
      key: null,
      title: 'N/A',
      nombre: 'N/A',
      apellidos: 'N/A',
      distancias:'N/A',
      pais: 'N/A',
      email: 'N/A',
      telefono: 'N/A',
      numeroDeWhatsapp: 'N/A',
      tallaDePolo: 'N/A',
      fechaDeNacimiento: 'N/A',
      documento: 'N/A',
      numeroDeDocumentos:'N/A',
      team: 'N/A',
      genero: 'N/A',
      rangoDeEdad: 'N/A',
      grupoSanguineo: 'N/A',
      haSidoVacunadoContraElCovid19: null,
      alergias: null,
      nombreCompleto: null,
      parentesco: null,
      telefonoPariente: null,
      carrerasPrevias: null,
      porQueCorresElAndesRace: null,
      deCuscoAPartida: null,
      deCuscoAOllantaytambo: null,
      comoSupisteDeAndesRace: null);
}
