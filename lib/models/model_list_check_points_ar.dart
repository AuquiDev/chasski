

import 'package:chasski/utils/parse_fecha_nula.dart';

class TListChekPoitnsModel {
   int? idsql;//Se añade con fines de uso en sqllite 
    String? id;
    String? collectionId;
    String? collectionName;
    DateTime? created;
    DateTime? updated;

    String idEvento;
    String ubicacion;
    String nombre;
    String descripcion;
    String elevacion;
    int orden;
    DateTime horaApertura;
    DateTime horaCierre;
    bool estatus;
    String? itemsList;
    String? personal;

    TListChekPoitnsModel({
        this.idsql,
         this.id,
         this.collectionId,
         this.collectionName,
         this.created,
         this.updated,

        required this.idEvento,
        required this.ubicacion,
        required this.nombre,
        required this.descripcion,
        required this.elevacion,
        required this.orden,
        required this.horaApertura,
        required this.horaCierre,
        required this.estatus,
         this.itemsList,
        this.personal
    });

    factory TListChekPoitnsModel.fromJson(Map<String, dynamic> json) => TListChekPoitnsModel(
        id: json["id"],
        collectionId: json["collectionId"],
        collectionName: json["collectionName"],
        created: (json["created"]),
        updated: (json["updated"]),
        idEvento: json["id_evento"],
        ubicacion: json["ubicacion"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        elevacion: json["elevacion"],
        orden: json["orden"],
        horaApertura: parseDateTime(json["hora_apertura"]),
        horaCierre: parseDateTime(json["hora_cierre"]),
        estatus: json["estatus"],
        itemsList: json["items_list"] ?? '',
        personal: json["personal"]?? ''
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "collectionId": collectionId,
        "collectionName": collectionName,
        // "created": created.toIso8601String(),
        // "updated": updated.toIso8601String(),
        "id_evento": idEvento,
        "ubicacion": ubicacion,
        "nombre": nombre,
        "descripcion": descripcion,
        "elevacion": elevacion,
        "orden": orden,
        "hora_apertura": horaApertura.toIso8601String(),
        "hora_cierre": horaCierre.toIso8601String(),
        "estatus": estatus,
        "items_list": itemsList,
        "personal": personal
    };
}
