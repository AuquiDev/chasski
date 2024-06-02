
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_check_list_1.dart';
import 'package:pocketbase/pocketbase.dart';

class TChecklist_03 {
  
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_chl_3_entrega_kits').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TChekListmodel01 data) async {
    final record =
        await pb.collection('ar_chl_3_entrega_kits').create(body: data.toJson());
    return record;
  }

  static  putAsitneciaPk({String? id, TChekListmodel01? data}) async {
    final record =
        await pb.collection('ar_chl_3_entrega_kits').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_chl_3_entrega_kits').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}