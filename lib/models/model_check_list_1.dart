
import 'package:chasski/utils/parse_fecha_nula.dart';

class TChekListmodel01 {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idCorredor;
    String idCheckList;
    DateTime fecha;
    bool estado;
    String nombre;
    String dorsal;

    TChekListmodel01({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idCorredor,
        required this.idCheckList,
        required this.fecha,
        required this.estado,
        required this.nombre,
        required this.dorsal,
    });

    factory TChekListmodel01.fromJson(Map<String, dynamic> json) => TChekListmodel01(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idCorredor: json["id_corredor"],
        idCheckList: json["id_check_list"],
        fecha: parseDateTime(json["fecha"]),
        estado: json["estado"],
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
        "fecha": fecha.toIso8601String(),
        "estado": estado,
        "nombre": nombre,
        "dorsal": dorsal,
    };
}
