import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/productos/model_t_productos_app.dart';
import 'package:pocketbase/pocketbase.dart';

class TProductosApp {
  static Future<List<RecordModel>> getProductoApp(
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

  static Future<RecordModel?> postProductosApp(
      {required TProductosAppModel data,
      required String collectionName}) async {
    try {
      final record =
          await pb.collection('$collectionName').create(body: data.toJson());
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<RecordModel?> putProductosApp(
      {required String id,
      required TProductosAppModel data,
      required String collectionName}) async {
    try {
      final record = await pb
          .collection('$collectionName')
          .update(id, body: data.toJson());
      return record;
    } catch (e) {
      print('Error en $collectionName: $e');
      return null;
    }
  }

  static Future<bool> deleteProductosApp(
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
