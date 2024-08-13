// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:chasski/api/path_key_api.dart';
import 'package:pocketbase/pocketbase.dart';

class VTablaParticipantesServices {
  static Future<List<RecordModel>> get_v_TablaParticipantes() async {
   try {
      final records =  await pb.collection('ar_view_check_points').getFullList();
    return records;
   } catch (e) {
     return [];
   }
  }
}
