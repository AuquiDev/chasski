
// import 'package:chaskis/models/model_t_asistencia.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_check_points.dart';
import 'package:pocketbase/pocketbase.dart';

class TCheckPoitns_AR05 {
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_chp_5_punto').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TCheckPointsModel data) async {
    final record =
        await pb.collection('ar_chp_5_punto').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TCheckPointsModel? data}) async {
    final record =
        await pb.collection('ar_chp_5_punto').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_chp_5_punto').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}