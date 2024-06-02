
import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_list_check_list_ar.dart';
import 'package:pocketbase/pocketbase.dart';

class TListCheckList_AR {
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_check_list').getFullList(
          sort: '-created',
        );
    print('LIST CHECK POINTS: $records');
    return records;
  }

  static  postAsistenciaPk(TListChekListModel data) async {
    final record =
        await pb.collection('ar_check_list').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TListChekListModel? data}) async {
    final record =
        await pb.collection('ar_check_list').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_check_list').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}