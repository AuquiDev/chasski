import 'dart:io';

import 'package:chasski/api/path_key_api.dart';
import 'package:http/http.dart' as http;
import 'package:chasski/models/model_check_list_2file.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http_parser/http_parser.dart';

class TChecklist_02 {
  static getAsitenciaPk() async {
    final records = await pb.collection('ar_chl_2_documentos').getFullList(
          sort: '-created',
        );
    // print(records);
    return records;
  }

  static postAsistenciaPk({TChekListmodel02File? data, File? file, File? deslinde}) async {
    final record = await pb.collection('ar_chl_2_documentos').create(
      body: data!.toJson(),
      files: [
        if (file != null)
        http.MultipartFile.fromBytes(
            'file',
            await file.readAsBytes(),
            filename: 'certficadoMedico_${data.id}_${data.nombre}.pdf',
            contentType:
                MediaType('application', 'pdf'), // Content type for PDF
          ),

         if (deslinde != null)
        http.MultipartFile.fromBytes(
            'deslinde',
            await deslinde.readAsBytes(),
            filename: 'deslinde_${data.id}_${data.nombre}.pdf',
            contentType:
                MediaType('application', 'pdf'), // Content type for PDF
          ),
      ],
    );
    return record;
  }

  static putAsitneciaPk(
      {String? id, TChekListmodel02File? data, File? imagen, File? deslinde}) async {
    final record = await pb.collection('ar_chl_2_documentos').update(
      id!,
      body: data!.toJson(),
      files: [
        if (imagen != null)
          http.MultipartFile.fromBytes(
            'file',
            await imagen.readAsBytes(),
            filename: 'documento${data.id}${data.nombre}.pdf',
            contentType:
                MediaType('application', 'pdf'), // Content type for PDF
          ),
         if (deslinde != null)
        http.MultipartFile.fromBytes(
            'deslinde',
            await deslinde.readAsBytes(),
            filename: 'deslinde_${data.id}_${data.nombre}.pdf',
            contentType:
                MediaType('application', 'pdf'), // Content type for PDF
          ),
      ],
    );
    return record;
  }

  static Future deleteAsistentciaPk(String id) async {
    final record = await pb.collection('ar_chl_2_documentos').delete(id);
    return record;
  }

  static Future<RealtimeService> realmTimePocket() async {
    return pb.realtime;
  }
}
