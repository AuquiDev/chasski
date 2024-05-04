
import 'package:chasski/utils/parse_fecha_nula.dart';

class TCheckPointsModel {
    int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idCorredor;
    String idCheckPoints;
    DateTime fecha;
    bool estado;
    String nombre;
    String dorsal;

    TCheckPointsModel({
         this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idCorredor,
        required this.idCheckPoints,
        required this.fecha,
        required this.estado,
        required this.nombre,
        required this.dorsal,
    });

    factory TCheckPointsModel.fromJson(Map<String, dynamic> json) => TCheckPointsModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idCorredor: json["id_corredor"],
        idCheckPoints: json["id_check_points"],
        fecha: parseDateTime(json["fecha"]),
        estado: json["estado"],
        nombre: json["nombre"],
        dorsal: json["dorsal"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created,
        // "updated": updated,
        "id_corredor": idCorredor,
        "id_check_points": idCheckPoints,
        "fecha": fecha.toIso8601String(),
        "estado": estado,
        "nombre": nombre,
        "dorsal": dorsal,
    };
}
