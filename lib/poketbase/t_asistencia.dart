
import 'package:chasski/models/model_t_asistencia.dart';
import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class TAsistencia {
  static getAsitenciaPk() async {
    final records = await pb1.collection('asistencia_empleados').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static  postAsistenciaPk(TAsistenciaModel data) async {
    final record =
        await pb1.collection('asistencia_empleados').create(body: data.toJson());

    return record;
  }

  static  putAsitneciaPk({String? id, TAsistenciaModel? data}) async {
    final record =
        await pb1.collection('asistencia_empleados').update(id!, body: data!.toJson());
    return record;
  }

  static Future  deleteAsistentciaPk(String id) async {
    final record = await pb1.collection('asistencia_empleados').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb1.realtime;
  }
}