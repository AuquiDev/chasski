import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/check%20list/model_list_check_list_ar.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckList_AR {
  static Future<List<RecordModel>> getPK(
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
      {required TListChekListModel data,
      required String collectionName}) async {
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
      {required String? id,
      required TListChekListModel? data,
      required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .update(id!, body: data!.toJson());
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

   static Future<bool> deleteAsistentciaPk(
      {required String id, required String collectionName}) async {
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