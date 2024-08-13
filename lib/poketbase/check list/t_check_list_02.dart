import 'dart:io';

import 'package:chasski/api/path_key_api.dart';
import 'package:http/http.dart' as http;
import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http_parser/http_parser.dart';

class TChecklist_02 {
  static Future<List<RecordModel>> getAsitenciaPk(
      {required String collectionName}) async {
    try {
      final records = await pb.collection('$collectionName').getFullList(
            sort: '-created',
          );
      return records;
    } catch (e) {
      print('Error en $collectionName: $e');
      return [];
    }
  }

  static Future<RecordModel?> postAsistenciaPk(
      {required TChekListmodel02File data,
      File? file,
      File? deslinde,
      required String collectionName}) async {
    try {
      final record = await pb.collection('$collectionName').create(
        body: data.toJson(),
        files: [
          if (file != null)
            http.MultipartFile.fromBytes(
              'file',
              await file.readAsBytes(),
              filename: 'certficadoMedico_${data.id}_${data.nombre}.pdf',
              contentType:
                  MediaType('application', 'pdf'), // Content type for PDF
            ),
          if (deslinde != null)
            http.MultipartFile.fromBytes(
              'deslinde',
              await deslinde.readAsBytes(),
              filename: 'deslinde_${data.id}_${data.nombre}.pdf',
              contentType:
                  MediaType('application', 'pdf'), // Content type for PDF
            ),
        ],
      );
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<RecordModel?> putAsitneciaPk(
      {required String id,
      required TChekListmodel02File data,
      File? imagen,
      File? deslinde,
      required String collectionName}) async {
    try {
      final record = await pb.collection('$collectionName').update(
        id,
        body: data.toJson(),
        files: [
          if (imagen != null)
            http.MultipartFile.fromBytes(
              'file',
              await imagen.readAsBytes(),
              filename: 'documento${data.id}${data.nombre}.pdf',
              contentType:
                  MediaType('application', 'pdf'), // Content type for PDF
            ),
          if (deslinde != null)
            http.MultipartFile.fromBytes(
              'deslinde',
              await deslinde.readAsBytes(),
              filename: 'deslinde_${data.id}_${data.nombre}.pdf',
              contentType:
                  MediaType('application', 'pdf'), // Content type for PDF
            ),
        ],
      );
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<bool>  deleteAsistentciaPk(
      {required String collectionName, required String id}) async {
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
