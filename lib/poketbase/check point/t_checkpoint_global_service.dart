// import 'package:chaskis/models/model_t_asistencia.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/check%20point/model_check_points.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckPoitnsGlobalService {

  static Future<List<RecordModel>> getPk({required String collectionName}) async {
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
      {required TCheckPointsModel data, required String collectionName}) async {
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
      required TCheckPointsModel data,
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
      return false;
    } catch (e) {
      print('Error en $collectionName: $e');
      return true;
    }
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
