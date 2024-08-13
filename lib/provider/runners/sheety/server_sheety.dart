
import 'dart:convert';
import 'package:chasski/models/evento/model_evento.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:http/http.dart' as http;

// final String proyectSheetyname = 'tCorredores';
// final String pathKey = 'f53816fcb0bafbe4d4c949ef5608d75a/$proyectSheetyname';//token 
// final String _baseUrl = 'api.sheety.co';// no varia 
// final String hojaName = 'participantesExport (73)';

class ParticipantesSheety {


  static List<ParticipantesModel> fromJsonList({required String? str,required TEventoModel? evento}) {
    final jsonData = json.decode(str!);
    return List<ParticipantesModel>.from(jsonData[evento!.hojaSheetname]
        .map((x) => ParticipantesModel.fromJson(x)));
  }

  static getShetty({required TEventoModel? evento}) async {
    var url = Uri.https(evento!.baseUrl!, '${evento.tokenSheety}/${evento.proyectname}/${evento.hojaSheetname}');
    final response = await http.get(url);

    return response;
  }

  static postSheety({required ParticipantesModel? e,required TEventoModel? evento}) async {
    var url = Uri.https(evento!.baseUrl!, '${evento.tokenSheety}/${evento.proyectname}/${evento.hojaSheetname}');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "${evento.hojaSheetname}": {
          "date": e!.date,
          "dorsal": e.dorsal,
          "key": e.key,
          "title": e.title,
          "nombre": e.nombre,
          "apellidos": e.apellidos,
          "distancias": e.distancias,
          "pais": e.pais,
          "email": e.email,
          "telefono": e.telefono,
          "numeroDeWhatsapp": e.numeroDeWhatsapp,
          "tallaDePolo": e.tallaDePolo,
          "fechaDeNacimiento": e.fechaDeNacimiento,
          "documento": e.documento,
          "numeroDeDocumentos": e.numeroDeDocumentos,
          "team": e.team,
          "genero": e.genero,
          "rangoDeEdad": e.rangoDeEdad,
          "grupoSanguineo": e.grupoSanguineo,
          "haSidoVacunadoContraElCovid19": e.haSidoVacunadoContraElCovid19,
          "alergias": e.alergias,
          "nombreCompleto": e.nombreCompleto,
          "parentesco": e.parentesco,
          "telefonoPariente": e.telefonoPariente,
          "carrerasPrevias": e.carrerasPrevias,
          "porQueCorresElAndesRace": e.porQueCorresElAndesRace,
          "deCuscoAPartida": e.deCuscoAPartida,
          "deCuscoAOllantaytambo": e.deCuscoAOllantaytambo,
          "comoSupisteDeAndesRace": e.comoSupisteDeAndesRace,
        }
      }),
    );
     print('Guardado ${e.id}');
    return response;
  }

  static putSheety({required ParticipantesModel? e,required TEventoModel? evento}) async {
    var url = Uri.https(evento!.baseUrl!, '${evento.tokenSheety}/${evento.proyectname}/${evento.hojaSheetname}/${e!.id}');
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "${evento.hojaSheetname}": {
            "date": e.date,
             "dorsal": e.dorsal,
             "key": e.key,
            "title": e.title,
            "nombre": e.nombre,
            "apellidos": e.apellidos,
            "distancias": e.distancias,
            "pais": e.pais,
            "email": e.email,
            "telefono": e.telefono,
            "numeroDeWhatsapp": e.numeroDeWhatsapp,
            "tallaDePolo": e.tallaDePolo,
            "fechaDeNacimiento": e.fechaDeNacimiento,
            "documento": e.documento,
            "numeroDeDocumentos": e.numeroDeDocumentos,
            "team": e.team,
            "genero": e.genero,
            "rangoDeEdad": e.rangoDeEdad,
            "grupoSanguineo": e.grupoSanguineo,
            "haSidoVacunadoContraElCovid19": e.haSidoVacunadoContraElCovid19,
            "alergias": e.alergias,
            "nombreCompleto": e.nombreCompleto,
            "parentesco": e.parentesco,
            "telefonoPariente": e.telefonoPariente,
            "carrerasPrevias": e.carrerasPrevias,
            "porQueCorresElAndesRace": e.porQueCorresElAndesRace,
            "deCuscoAPartida": e.deCuscoAPartida,
            "deCuscoAOllantaytambo": e.deCuscoAOllantaytambo,
            "comoSupisteDeAndesRace": e.comoSupisteDeAndesRace,
          }
          
        }
        ));
    print('Editado ${e.id}');
    return response;
  }

  static Future deleteSheety({required String? id,required  TEventoModel? evento}) async {
    final url = Uri.https(evento!.baseUrl!, '${evento.tokenSheety}/${evento.proyectname}/${evento.hojaSheetname}/$id');
    final response = await http.delete(url);

    return response;
  }
}
