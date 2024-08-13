import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/check%20list/model_check_list_1.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckListGlobalService {
  static Future<List<RecordModel>> getPk(
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

  static Future<RecordModel?> postPk(
      {required TChekListmodel01 data, required String collectionName}) async {
    try {
      final record =
          await pb.collection('$collectionName').create(body: data.toJson());
      print(collectionName);
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<RecordModel?> putPK(
      {required String id,
      required TChekListmodel01 data,
      required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .update(id, body: data.toJson());
      print(collectionName);
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<bool> deletePk(
      {required String collectionName, required String id}) async {
    try {
      await pb.collection('$collectionName').delete(id);
      print(collectionName);
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
