import 'dart:io';
import 'dart:async';
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/sponsor/model_sponsors.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class TSponsors {
  //GET
  static Future<List<RecordModel>> getAsitenciaPk(
      {required String collectionName}) async {
    try {
      final records = await pb.collection('$collectionName').getFullList(
            sort: '-created',
          );
      return records;
    } catch (e) {
      print('Error en Sponsor: $e');
      return [];
    }
  }

  //POST
  static Future<RecordModel?> postAsistenciaPk(
      {required TSponsosModel data,
      File? imagen,
      required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .create(body: data.toJson(), files: [
        if (imagen != null)
          http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
              filename: 'imagen${data.id}${data.title}.jpg')
      ]);

      return record;
    } catch (e) {
      print('Error en Sponsor: $e');
      return null;
    }
  }

  //UPDATE
  static Future<RecordModel?> putAsitneciaPk(
      {required String id,
      required TSponsosModel data,
      File? imagen,
      required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .update(id, body: data.toJson(), files: [
        if (imagen != null)
          http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
              filename: 'imagen${data.id}${data.title}.jpg')
      ]);
      return record;
    } catch (e) {
      print('Error en Sponsor: $e');
      return null;
    }
  }

  //DELETE
  static Future<bool> deleteAsistentciaPk({required String id, required String collectionName}) async {
    try {
      await pb.collection('$collectionName').delete(id);
      return true;
    } catch (e) {
      print('Error en deleteSponsor: $e');
      return false;
    }
  }

  //REALTIME
  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
