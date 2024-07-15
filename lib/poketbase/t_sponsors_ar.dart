import 'dart:io';

import 'package:chasski/api/path_key_api.dart';
import 'package:chasski/models/model_sponsors.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class TSponsors {
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_sponsor').getFullList(
          sort: '-created',
        );
    print('POKETBASE SPONSORS :$records');
    return records;
  }

  static postAsistenciaPk({TSponsosModel? data, File? imagen}) async {
    final record =
        await pb.collection('ar_sponsor').create(body: data!.toJson(), files: [
      if (imagen != null)
        http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
            filename: 'imagen${data.id}${data.title}.jpg')
    ]);

    return record;
  }

  static putAsitneciaPk({String? id, TSponsosModel? data, File? imagen}) async {
    final record = await pb
        .collection('ar_sponsor')
        .update(id!, body: data!.toJson(), files: [
      if (imagen != null)
        http.MultipartFile.fromBytes('imagen', await imagen.readAsBytes(),
            filename: 'imagen${data.id}${data.title}.jpg')
    ]);
    return record;
  }

  static Future deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_sponsor').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
