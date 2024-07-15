
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_distancias_ar.dart';
import 'package:pocketbase/pocketbase.dart';

class TDistanciasAr {
  
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_distancias').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TDistanciasModel data) async {
    final record = await pb.collection('ar_distancias').create(body: data.toJson());
    return record;
  }

  static  putAsitneciaPk({String? id, TDistanciasModel? data}) async {
    final record = await pb.collection('ar_distancias').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_distancias').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}