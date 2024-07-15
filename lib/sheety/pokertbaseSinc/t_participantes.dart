import 'dart:io';

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/sheety/model_participantes.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

//Collection name
final String collectionParticipantes = 'ar_corredores_data';

class TParticipantesPk {
  
  static getAsitenciaPk() async { 
    final records = await pb.collection('$collectionParticipantes').getFullList(
          sort: '-created',
        );
    // print('POKETBASE RECORD :$records');
    return records;
  }

  static postAsistenciaPk(
    ParticipantesModel data,
  ) async {
    final record = await pb.collection('$collectionParticipantes').create(
          body: data.toJson(),
        );

    return record;
  }

  static putAsitneciaPk({String? id, ParticipantesModel? data, File? imagen}) async {
    final record = await pb
        .collection('$collectionParticipantes')
        .update(id!, body: data!.toJson(),
        files: [
      if (imagen != null)
        http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
            filename: 'imagen${data.id}${data.nombre}.jpg')
    ]);
    return record;
  }

  static Future deleteAsistentciaPk(String id) async {
    final record = await pb.collection('$collectionParticipantes').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
