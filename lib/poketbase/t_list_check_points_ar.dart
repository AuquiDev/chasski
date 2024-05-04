
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_list_check_points_ar.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckPoitns_AR {
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_check_points').getFullList(
          sort: '-created',
        );
    print('LIST CHECK POINTS: $records');
    return records;
  }

  static  postAsistenciaPk(TListCheckPoitns_ARModels data) async {
    final record =
        await pb.collection('ar_check_points').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TListCheckPoitns_ARModels? data}) async {
    final record =
        await pb.collection('ar_check_points').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_check_points').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}