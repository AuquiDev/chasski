

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
    String? file;
    String fileUrl;
    DateTime fecha;
    bool estado;
    String detalles;
    String nombre;
    String dorsal;

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
        // file: (json["file"]) ?? '',
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
        "file_url": fileUrl,
        "fecha": fecha.toIso8601String(),
        "estado": estado,
        "detalles": detalles,
        "nombre": nombre,
        "dorsal": dorsal,
    };
}
