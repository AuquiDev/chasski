
import 'package:chasski/api/path_key_api.dart';
// import 'package:chasski/models/model_check_list_1.dart';
import 'package:chasski/models/model_check_list_2file.dart';
import 'package:pocketbase/pocketbase.dart';

class TChecklist_02 {
  
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_chl_2_documentos').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TChekListmodel02File data) async {
    final record =
        await pb.collection('ar_chl_2_documentos').create(body: data.toJson());
    return record;
  }

  static  putAsitneciaPk({String? id, TChekListmodel02File? data}) async {
    final record =
        await pb.collection('ar_chl_2_documentos').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_chl_2_documentos').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
  
}