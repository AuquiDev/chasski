import 'dart:convert';
import 'package:chasski/sheety/model_participantes.dart';
import 'package:http/http.dart' as http;

final String proyectSheetyname = 'tCorredores';
final String pathKey = 'f53816fcb0bafbe4d4c949ef5608d75a/$proyectSheetyname';//token 
final String _baseUrl = 'api.sheety.co';// no varia 
final String hojaName = 'participantesExport (73)';

class ParticipantesSheety {

  static List<ParticipantesModel> fromJsonList(String str) {
    final jsonData = json.decode(str);
    return List<ParticipantesModel>.from(jsonData[hojaName]
        .map((x) => ParticipantesModel.fromJson(x)));
  }

  static getShetty() async {
    var url = Uri.https(_baseUrl, '$pathKey/$hojaName');
    final response = await http.get(url);

    return response;
  }

  static postSheety({ParticipantesModel? e}) async {
    var url = Uri.https(_baseUrl, '$pathKey/$hojaName');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "$hojaName": {
          "date": e!.date,
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

  static putSheety({ParticipantesModel? e}) async {
    var url = Uri.https(_baseUrl, '$pathKey/$hojaName/${e!.id}');
    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "$hojaName": {
            "date": e.date,
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

  static Future deleteSheety({String? id}) async {
    final url = Uri.https(_baseUrl, '$pathKey/$hojaName/$id');
    final response = await http.delete(url);

    return response;
  }
}
