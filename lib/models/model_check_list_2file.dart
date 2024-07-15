

import 'package:chasski/utils/parse_fecha_nula.dart';

class TChekListmodel02File {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idCorredor;
    String idCheckList;
    
    String fileUrl;
    DateTime fecha;
    bool estado;
    String detalles;
    String nombre;
    String dorsal;
    String? file;
    String? deslinde;

    TChekListmodel02File({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idCorredor,
        required this.idCheckList,
         this.file,
         this.deslinde,
        required this.fileUrl,
        required this.fecha,
        required this.estado,
        required this.detalles,
        required this.nombre,
        required this.dorsal,
    });

    factory TChekListmodel02File.fromJson(Map<String, dynamic> json) => TChekListmodel02File(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idCorredor: json["id_corredor"],
        idCheckList: json["id_check_list"],
        file: json["file"] != null ? json["file"].toString() : '',
      deslinde: json["deslinde"] != null ? json["deslinde"].toString() : '',
        // file: (json["file"]).toString() ?? '',
        // deslinde: json["deslinde"].toString() ?? '',
        fileUrl: json["file_url"],
        fecha: parseDateTime(json["fecha"]),
        estado: json["estado"],
        detalles: json["detalles"],
        nombre: json["nombre"],
        dorsal: json["dorsal"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created(),
        // "updated": updated(),
        "id_corredor": idCorredor,
        "id_check_list": idCheckList,
        "file": (file),
        "deslinde": deslinde,
        "file_url": fileUrl,
        "fecha": fecha.toIso8601String(),
        "estado": estado,
        "detalles": detalles,
        "nombre": nombre,
        "dorsal": dorsal,
    };
}

TChekListmodel02File chekListDocDefault() {
    return TChekListmodel02File(
        idCorredor: 'idCorredor', 
        idCheckList: 'idCheckList', 
        fileUrl: '', 
        fecha: DateTime.now(), 
        estado: true, 
        detalles: 'detalles', 
        nombre: 'nombre', 
        dorsal: 'dorsal', 
        file: '', 
        deslinde: '');
  }