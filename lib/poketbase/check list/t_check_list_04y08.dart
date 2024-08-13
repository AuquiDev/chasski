import 'dart:io';
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/check%20list/model_check_list_2file.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

// String collectionname = 'ar_chl_4_recepcion_equipaje';

class TChecklist_04 {
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
      {required TChekListmodel02File data, List<File>? listaImagenes, required String collectionName}) async {
   try {
      final record = await pb
        .collection('$collectionName')
        .create(body: data.toJson(), files: [
      // Adjuntar la lista de imágenes al formulario
      if (listaImagenes != null)
        for (var i = 0; i < listaImagenes.length; i++)
          http.MultipartFile.fromBytes(
            'images',
            await listaImagenes[i].readAsBytes(),
            filename: 'image$i.jpg',
          ),
    ]);
    return record;
   } catch (e) {
     print('Error en $collectionName: $e');
      return null;
   }
  }

  static Future<RecordModel?> putAsitneciaPk(
      {required String id,
      required TChekListmodel02File data,
      required String collectionName,
      List<File>? listaImagenes}) async {
    try {
      final record = await pb
        .collection('$collectionName')
        .update(id, body: data.toJson(), files: [
      // Adjuntar la lista de imágenes al formulario
      if (listaImagenes != null)
        for (var i = 0; i < listaImagenes.length; i++)
          http.MultipartFile.fromBytes(
            'images',
            await listaImagenes[i].readAsBytes(),
            filename: 'image$i.jpg',
          ),
    ]);
    return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<bool> deleteAsistentciaPk({required String id, required String collectionName}) async {
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
