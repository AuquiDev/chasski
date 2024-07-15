
// class ParticipantesModel {
//     String? date;//no relevante  FECHA REGISTRO
//     int? id;     //no relvante pero puede servir como identificador unico para sincronizr 
//     String? title; //no relvante 
//     String nombre; 
//     String apellidos;
//     String distancias;
//     String pais;
//     String email;
//     dynamic telefono;
//     dynamic numeroDeWhatsapp;
//     String tallaDePolo;
//     String fechaDeNacimiento;
//     String documento;///tipo docuemnto
//     dynamic numeroDeDocumentos;//algunos no tienen o no soolo numeros 
//     dynamic team;//
//     String genero;
//     String rangoDeEdad;
//     String grupoSanguineo;
//     String haSidoVacunadoContraElCovid19;
//     String alergias;

//     dynamic nombreCompleto;//Familiar 
//     dynamic parentesco;//parentesco de familiar 
//     dynamic telefonoPariente;

//     dynamic carrerasPrevias;
//     String porQueCorresElAndesRace;
//     String? deCuscoAPartida;
//     String? deCuscoAOllantaytambo;
//     String? comoSupisteDeAndesRace;

//     ParticipantesModel({
//          this.date,
//          this.id,
//          this.title,
//         required this.nombre,
//         required this.apellidos,
//         required this.distancias,
//         required this.pais,
//         required this.email,
//         required this.telefono,
//         required this.numeroDeWhatsapp,
//         required this.tallaDePolo,
//         required this.fechaDeNacimiento,
//         required this.documento,
//         required this.numeroDeDocumentos,
//         required this.team,
//         required this.genero,
//         required this.rangoDeEdad,
//         required this.grupoSanguineo,
//         required this.haSidoVacunadoContraElCovid19,
//         required this.alergias,
//         required this.nombreCompleto,
//         required this.parentesco,
//         required this.telefonoPariente,
//         required this.carrerasPrevias,
//         required this.porQueCorresElAndesRace,
//         this.deCuscoAPartida,
//         this.deCuscoAOllantaytambo,
//         this.comoSupisteDeAndesRace,
//     });

//     factory ParticipantesModel.fromJson(Map<String, dynamic> json) {
//       //  String idserver =  json["id"];
//       return ParticipantesModel(
//         date: json["date"],
//         id: json["id"],//idserver
//         title: json["title"],
//         nombre: json["nombre"],
//         apellidos: json["apellidos"],
//         distancias: json["distancias"],
//         pais: json["pais"],
//         email: json["email"],
//         telefono: json["telefono"],
//         numeroDeWhatsapp: json["numeroDeWhatsapp"],
//         tallaDePolo: json["tallaDePolo"],
//         fechaDeNacimiento: json["fechaDeNacimiento"],
//         documento: json["documento"],
//         numeroDeDocumentos: json["numeroDeDocumentos"],
//         team: json["team"],
//         genero: json["genero"],
//         rangoDeEdad: json["rangoDeEdad"],
//         grupoSanguineo: json["grupoSanguineo"],
//         haSidoVacunadoContraElCovid19:json["haSidoVacunadoContraElCovid19"],
//         alergias: json["alergias"],
//         nombreCompleto: json["nombreCompleto"],
//         parentesco: json["parentesco"],
//         telefonoPariente: json["telefonoPariente"],
//         carrerasPrevias: json["carrerasPrevias"],
//         porQueCorresElAndesRace: json["porQueCorresElAndesRace"],
//         deCuscoAPartida: json["deCuscoAPartida"],
//         deCuscoAOllantaytambo: json["deCuscoAOllantaytambo"],
//         comoSupisteDeAndesRace: json["comoSupisteDeAndesRace"],
//     );
//     }

//     Map<String, dynamic> toJson() => {
//         "date": date,
//         "id": id,
//         "title": title,
//         "nombre": nombre,
//         "apellidos": apellidos,
//         "distancias": distancias,
//         "pais": pais,
//         "email": email,
//         "telefono": telefono,
//         "numeroDeWhatsapp": numeroDeWhatsapp,
//         "tallaDePolo": tallaDePolo,
//         "fechaDeNacimiento": fechaDeNacimiento,
//         "documento": documento,
//         "numeroDeDocumentos": numeroDeDocumentos,
//         "team": team,
//         "genero":genero,
//         "rangoDeEdad": rangoDeEdad,
//         "grupoSanguineo": grupoSanguineo,
//         "haSidoVacunadoContraElCovid19": haSidoVacunadoContraElCovid19,
//         "alergias": alergias,
//         "nombreCompleto": nombreCompleto,
//         "parentesco": parentesco,
//         "telefonoPariente": telefonoPariente,
//         "carrerasPrevias": carrerasPrevias,
//         "porQueCorresElAndesRace": porQueCorresElAndesRace,
//         "deCuscoAPartida": deCuscoAPartida,
//         "deCuscoAOllantaytambo": deCuscoAOllantaytambo,
//         "comoSupisteDeAndesRace": comoSupisteDeAndesRace,
//     };
    
   
// }
