import 'dart:io';
import 'dart:async';

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/runner/model_participantes.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;



class TParticipantesPk {
  static Future<List<RecordModel>> getAsitenciaPk({required String collectionName}) async {
    try {
      final records = await pb
          .collection('$collectionName')
          .getFullList(sort: '-created', filter: '');
      return records;
    } catch (e) {
      print('Error en $collectionName: $e');
      return [];
    }
  }

   static Future<RecordModel?> postAsistenciaPk({required ParticipantesModel data, required String collectionName}) async {
    try {
      final record = await pb.collection('$collectionName').create(
            body: data.toJson(),
          );
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

   static Future<RecordModel?> putAsitneciaPk(
      {String? id, ParticipantesModel? data, File? imagen, required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .update(id!, body: data!.toJson(), files: [
        if (imagen != null)
          http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
              filename: 'imagen${data.id}${data.nombre}.jpg')
      ]);
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<bool> deleteAsistentciaPk({required String collectionName,required  String id}) async {
    try {
      await pb.collection('$collectionName').delete(id);
      return true;
    } catch (e) {
      print('Error en $collectionName: $e');
      return false;
    }
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}

 /*manejo de errores para tus operaciones asincrónicas. Esto asegura que tu aplicación
   sea robusta y pueda manejar situaciones inesperadas de manera adecuada.*/
  //  static Future<List<RecordModel>> getAvanzado({
  //   int batch = 500,
  //   String? expand,
  //   String? filter,
  //   String? sort,
  //   String? fields,
  //   Map<String, dynamic> query = const {},
  //   Map<String, String> headers = const {},
  // }) async {
  //   try {
  //     final records = await pb.collection('$collectionParticipantes').getFullList(
  //       batch: batch,
  //       expand: expand,
  //       filter: filter,
  //       sort: sort,
  //       fields: fields,
  //       query: query,
  //       headers: headers,
  //     );
  //     return records;
  //   } catch (e) {
  //     print('Error en TParticipantesPk: $e');
  //     return [];
  //   }
  // } 

// void fetchData() async {
//   try {
//     // Filtra los registros por un estado específico
//     List<RecordModel> activeRecords = await TParticipantesPk.getAsitenciaPk(
//       filter: 'status="active"',
//     );

//     // Filtra los registros por fecha
//     List<RecordModel> dateRangeRecords = await TParticipantesPk.getAsitenciaPk(
//       filter: 'created_at >= "2024-01-01T00:00:00Z" AND created_at <= "2024-12-31T23:59:59Z"',
//       sort: '-created_at',
//     );

//     // Filtra registros basados en varios valores
//     List<RecordModel> categoryRecords = await TParticipantesPk.getAsitenciaPk(
//       filter: 'category IN ("sports", "technology", "education")',
//     );

//     // Filtra registros por valor en un campo relacionado
//     List<RecordModel> relatedFieldRecords = await TParticipantesPk.getAsitenciaPk(
//       filter: 'related_field.id="12345"',
//     );

//     // Maneja los registros obtenidos
//     print(activeRecords);
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }
